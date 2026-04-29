// lib/models/recipe.dart

class Recipe {
  final int id;
  final String name;
  final String searchableName;
  final List<String> ingredients;
  final String ingredientsRaw;
  final String diet;
  final int prepTime;
  final int cookTime;
  final int totalTime;
  final bool noCook;
  final String flavorProfile;
  final String course;
  final String state;
  final String region;
  final String instructions;

  // NEW: automatically calculated step count
  final int stepsCount;

  // Image URL fetched from Pexels
  final String? imageUrl;

  const Recipe({
    required this.id,
    required this.name,
    required this.searchableName,
    required this.ingredients,
    required this.ingredientsRaw,
    required this.diet,
    required this.prepTime,
    required this.cookTime,
    required this.totalTime,
    required this.noCook,
    required this.flavorProfile,
    required this.course,
    required this.state,
    required this.region,
    required this.instructions,
    required this.stepsCount,
    this.imageUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final rawIng = json['ingredients'];

    List<String> ingList = [];

    if (rawIng is List) {
      ingList = rawIng
          .map((e) => e.toString().trim().toLowerCase())
          .toList();
    } else if (rawIng is String && rawIng.isNotEmpty) {
      ingList = rawIng
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .toList();
    }

    final image = (json['imageUrl'] as String?)?.trim();

    final instructionsText =
        json['instructions'] as String? ?? '';

    return Recipe(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      searchableName: json['searchableName'] as String? ?? '',
      ingredients: ingList,
      ingredientsRaw:
          json['ingredientsRaw'] as String? ??
          ingList.join(', '),
      diet: json['diet'] as String? ?? '',
      prepTime: json['prepTime'] as int? ?? 0,
      cookTime: json['cookTime'] as int? ?? 0,
      totalTime: json['totalTime'] as int? ?? 0,
      noCook: json['noCook'] as bool? ?? false,
      flavorProfile: json['flavorProfile'] as String? ?? '',
      course: json['course'] as String? ?? '',
      state: json['state'] as String? ?? '',
      region: json['region'] as String? ?? '',
      instructions: instructionsText,

      // NEW: count number of instruction steps
      stepsCount: _calculateStepsCount(instructionsText),

      imageUrl: image != null && image.isNotEmpty ? image : null,
    );
  }

  // NEW: helper function to calculate step count
  static int _calculateStepsCount(String instructions) {
    if (instructions.trim().isEmpty) return 0;

    final steps = instructions
        .split(RegExp(r'[.\n]+'))
        .where((step) => step.trim().isNotEmpty)
        .toList();

    return steps.length;
  }

  bool get isVeg => !diet.toLowerCase().contains('non');

  String get timeLabel {
    if (totalTime <= 0) return '—';

    if (totalTime < 60) {
      return '${totalTime}m';
    }

    final h = totalTime ~/ 60;
    final m = totalTime % 60;

    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  bool matchesIngredients(List<String> tokens) {
    if (tokens.isEmpty) return true;

    final ingredientSet = ingredients
        .expand(
          (ing) => ing.toLowerCase().split(
            RegExp(r'[\s,-]+'),
          ),
        )
        .map((e) => e.trim())
        .toSet();

    return tokens.every(
      (token) => ingredientSet.contains(
        token.toLowerCase().trim(),
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe && other.id == id);

  @override
  int get hashCode => id.hashCode;
}