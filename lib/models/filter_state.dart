// lib/models/filter_state.dart

enum TimeFilter { any, under15, under30, under60, under120 }

extension TimeFilterX on TimeFilter {
  String get label {
    switch (this) {
      case TimeFilter.any:
        return 'All';
      case TimeFilter.under15:
        return '15 min';
      case TimeFilter.under30:
        return '30 min';
      case TimeFilter.under60:
        return '1 hr';
      case TimeFilter.under120:
        return '2 hr';
    }
  }

  int? get maxMinutes {
    switch (this) {
      case TimeFilter.any:
        return null;
      case TimeFilter.under15:
        return 15;
      case TimeFilter.under30:
        return 30;
      case TimeFilter.under60:
        return 60;
      case TimeFilter.under120:
        return 120;
    }
  }
}

class FilterState {
  final String searchQuery;
  final TimeFilter timeFilter;
  final List<String> ingredientTokens;
  final bool lazyModeOn;
  final String dietFilter;

  const FilterState({
    this.searchQuery = '',
    this.timeFilter = TimeFilter.any,
    this.ingredientTokens = const [],
    this.lazyModeOn = false,
    this.dietFilter = 'Veg',
  });

  FilterState copyWith({
    String? searchQuery,
    TimeFilter? timeFilter,
    List<String>? ingredientTokens,
    bool? lazyModeOn,
    String? dietFilter,
  }) =>
      FilterState(
        searchQuery:
            searchQuery ?? this.searchQuery,
        timeFilter:
            timeFilter ?? this.timeFilter,
        ingredientTokens:
            ingredientTokens ??
            this.ingredientTokens,
        lazyModeOn:
            lazyModeOn ?? this.lazyModeOn,
        dietFilter:
            dietFilter ?? this.dietFilter,
      );

  bool get isEmpty =>
      searchQuery.isEmpty &&
      timeFilter == TimeFilter.any &&
      ingredientTokens.isEmpty &&
      !lazyModeOn;
}