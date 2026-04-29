import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/recipe.dart';
import '../models/filter_state.dart';
import '../services/firestore_service.dart';

class RecipeProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  // ── Raw data ───────────────────────────────────────────────────────────────
  List<Recipe> _all = [];
  bool _loading = true;
  String? _error;

  // ── Filter state ───────────────────────────────────────────────────────────
  FilterState _filter = const FilterState();

  // ── Favourites & Activity ──────────────────────────────────────────────────
  Set<int> _favIds = {};
  List<int> _recentlyViewed = [];

  // ── Getters ────────────────────────────────────────────────────────────────
  bool get isLoading => _loading;
  String? get error => _error;
  FilterState get filter => _filter;

  List<Recipe> get all => _all;

  Iterable<Recipe> get _dietFilteredAll {
    if (_filter.dietFilter == 'All') return _all;
    final isVegSelected = _filter.dietFilter == 'Veg';
    return _all.where((r) => isVegSelected ? r.isVeg : !r.isVeg);
  }

  List<Recipe> get filtered {
    return _dietFilteredAll.where((r) {
      // Lazy Mode
      if (_filter.lazyModeOn) {
  final isQuick = r.totalTime <= 15;
  final isSimple = r.stepsCount <= 5;
  final isNoCook = r.noCook;

  if (!(isQuick && (isSimple || isNoCook))) return false;
}

      // Time Filter
      final max = _filter.timeFilter.maxMinutes;
      if (max != null && r.totalTime > max) return false;

      // Ingredient Filter
      if (!r.matchesIngredients(_filter.ingredientTokens)) {
        return false;
      }

      // Search Query
      final q = _filter.searchQuery.trim().toLowerCase();
      if (q.isNotEmpty && !r.searchableName.contains(q)) {
        return false;
      }

      return true;
    }).toList();
  }

  // 🔥 FIXED: Do NOT include diet filter here
  bool get hasActiveFilter =>
      _filter.searchQuery.isNotEmpty ||
      _filter.timeFilter != TimeFilter.any ||
      _filter.ingredientTokens.isNotEmpty ||
      _filter.lazyModeOn;

  List<Recipe> get quickRecipes =>
      _dietFilteredAll.where((r) => r.totalTime > 0 && r.totalTime <= 30).toList();

  List<Recipe> get noCookRecipes =>
      _dietFilteredAll.where((r) => r.noCook).toList();

  List<Recipe> get trending => _dietFilteredAll.take(10).toList();

  List<Recipe> get favourites =>
      _dietFilteredAll.where((r) => _favIds.contains(r.id)).toList();

  List<Recipe> get recentlyViewedRecipes =>
      _recentlyViewed.map((id) => findById(id)).whereType<Recipe>().toList();

  List<Recipe> get recommendedRecipes {
    Set<String> preferredFlavors = {};

    for (var r in favourites) {
      if (r.flavorProfile.isNotEmpty) {
        preferredFlavors.add(r.flavorProfile);
      }
    }

    for (var r in recentlyViewedRecipes) {
      if (r.flavorProfile.isNotEmpty) {
        preferredFlavors.add(r.flavorProfile);
      }
    }

    if (preferredFlavors.isEmpty) {
      return trending;
    }

    return _dietFilteredAll
        .where((r) => preferredFlavors.contains(r.flavorProfile))
        .where((r) =>
            !_favIds.contains(r.id) &&
            !_recentlyViewed.contains(r.id))
        .take(10)
        .toList();
  }

  bool isFav(int id) => _favIds.contains(id);

  // ── Init ───────────────────────────────────────────────────────────────────
  Future<void> init() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final raw = await rootBundle.loadString('assets/data/recipes.json');
      final list = json.decode(raw) as List<dynamic>;

      _all = list.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();

      FirebaseAuth.instance.authStateChanges().listen((user) async {
        if (user != null) {
          await syncUserData();
        } else {
          _favIds.clear();
          _recentlyViewed.clear();
          _filter = const FilterState();
          notifyListeners();
        }
      });
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── Sync User Data ─────────────────────────────────────────────────────────
  Future<void> syncUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final data = await _firestoreService.getUserData(uid);

    // 🔥 FIX: handle first-time user
    if (data == null) {
      await _firestoreService.saveFavorites(uid, []);
      await _firestoreService.saveRecentlyViewed(uid, []);
      return;
    }

    if (data.containsKey('favorites')) {
      _favIds = (data['favorites'] as List<dynamic>)
          .map((e) => e as int)
          .toSet();
    }

    if (data.containsKey('recentlyViewed')) {
      _recentlyViewed = (data['recentlyViewed'] as List<dynamic>)
          .map((e) => e as int)
          .toList();
    }

    if (data.containsKey('dietPreference')) {
      String diet = data['dietPreference'];
      _filter = _filter.copyWith(dietFilter: diet);
    }

    notifyListeners();
  }

  // ── Filter updaters ────────────────────────────────────────────────────────
  void updateSearch(String q) {
    _filter = _filter.copyWith(searchQuery: q);
    notifyListeners();
  }

  void updateTimeFilter(TimeFilter tf) {
    _filter = _filter.copyWith(timeFilter: tf);
    notifyListeners();
  }

  void updateIngredients(List<String> tokens) {
    _filter = _filter.copyWith(ingredientTokens: tokens);
    notifyListeners();
  }

  void toggleLazy(bool v) {
    _filter = _filter.copyWith(lazyModeOn: v);
    notifyListeners();
  }

  void updateDietFilter(String value) {
    _filter = _filter.copyWith(dietFilter: value);
    notifyListeners();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _firestoreService.updateDietPreference(uid, value);
    }
  }

  void clearFilters() {
    _filter = const FilterState();
    notifyListeners();
  }

  // ── Favourites ─────────────────────────────────────────────────────────────
  Future<void> toggleFav(int id) async {
    if (_favIds.contains(id)) {
      _favIds.remove(id);
    } else {
      _favIds.add(id);
    }
    notifyListeners();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _firestoreService.saveFavorites(uid, _favIds.toList());
    }
  }

  // ── Recently Viewed ────────────────────────────────────────────────────────
  Future<void> addToRecentlyViewed(int id) async {
    _recentlyViewed.remove(id);
    _recentlyViewed.insert(0, id);

    if (_recentlyViewed.length > 10) {
      _recentlyViewed = _recentlyViewed.take(10).toList();
    }

    notifyListeners();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _firestoreService.saveRecentlyViewed(uid, _recentlyViewed);
    }
  }

  Recipe? findById(int id) {
    try {
      return _all.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}