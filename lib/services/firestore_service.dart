import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  Future<void> saveFavorites(String uid, List<int> favs) async {
    await _db.collection('users').doc(uid).set({
      'favorites': favs,
    }, SetOptions(merge: true));
  }

  Future<void> saveRecentlyViewed(String uid, List<int> recents) async {
    await _db.collection('users').doc(uid).set({
      'recentlyViewed': recents,
    }, SetOptions(merge: true));
  }

  Future<void> updateDietPreference(String uid, String diet) async {
    await _db.collection('users').doc(uid).set({
      'dietPreference': diet,
    }, SetOptions(merge: true));
  }
}
