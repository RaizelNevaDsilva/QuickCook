import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import '../utils/app_colors.dart';

class CategoryResultsScreen extends StatelessWidget {
  final String title;
  final List<Recipe> recipes;

  const CategoryResultsScreen({
    super.key,
    required this.title,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: recipes.isEmpty
          ? const Center(
              child: Text(
                'No recipes found',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return RecipeCardH(
                  recipe: recipes[index],
                  width: double.infinity,
                  margin: EdgeInsets.zero,
                );
              },
            ),
    );
  }
}
