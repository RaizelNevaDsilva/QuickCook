// lib/widgets/recipe_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../utils/app_colors.dart';
import '../screens/recipe_detail_screen.dart';

/// Compact horizontal card
class RecipeCardH extends StatelessWidget {
  final Recipe recipe;
  final double width;
  final EdgeInsetsGeometry? margin;

  const RecipeCardH({
    super.key,
    required this.recipe,
    this.width = 180,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        _slideRoute(RecipeDetailScreen(recipe: recipe)),
      ),
      child: Container(
        width: width,
        margin: margin ?? const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _RecipeImage(recipe: recipe, height: 120, radius: 18),

                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),

                Positioned(top: 8, right: 8, child: _FavButton(id: recipe.id)),

                if (recipe.noCook)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _Badge(label: 'No Cook'),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 13, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        recipe.timeLabel,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      _DietDot(isVeg: recipe.isVeg),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full card
class RecipeCardFull extends StatelessWidget {
  final Recipe recipe;

  const RecipeCardFull({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        _slideRoute(RecipeDetailScreen(recipe: recipe)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              child: SizedBox(
                width: 110,
                height: 110,
                child: _RecipeImageRaw(recipe: recipe),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _DietDot(isVeg: recipe.isVeg),
                        const SizedBox(width: 6),
                        Text(
                          recipe.isVeg ? 'Veg' : 'Non-Veg',
                          style: TextStyle(
                            color: recipe.isVeg
                                ? Colors.green
                                : Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      recipe.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        _StatPill(
                          icon: Icons.timer_outlined,
                          label: recipe.timeLabel,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _FavButton(id: recipe.id),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────── Helpers ─────────

class _RecipeImage extends StatelessWidget {
  final Recipe recipe;
  final double height;
  final double radius;

  const _RecipeImage({
    required this.recipe,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(radius)),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: _RecipeImageRaw(recipe: recipe),
      ),
    );
  }
}

class _RecipeImageRaw extends StatelessWidget {
  final Recipe recipe;
  const _RecipeImageRaw({required this.recipe});

  @override
  Widget build(BuildContext context) {
    if (recipe.imageUrl == null || recipe.imageUrl!.isEmpty) {
      return _GradientPlaceholder(name: recipe.name);
    }

    return Image.network(
      recipe.imageUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : _GradientPlaceholder(name: recipe.name),
      errorBuilder: (_, __, ___) =>
          _GradientPlaceholder(name: recipe.name),
    );
  }
}

class _GradientPlaceholder extends StatelessWidget {
  final String name;
  const _GradientPlaceholder({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.surfaceLight],
        ),
      ),
      child: const Center(
        child: Text("🍽️", style: TextStyle(fontSize: 32)),
      ),
    );
  }
}

class _FavButton extends StatelessWidget {
  final int id;
  const _FavButton({required this.id});

  @override
  Widget build(BuildContext context) {
    final prov = context.read<RecipeProvider>(); // ✅ FIX
    final isFav = context.select<RecipeProvider, bool>(
      (p) => p.isFav(id),
    ); // ✅ selective rebuild

    return GestureDetector(
      onTap: () => prov.toggleFav(id),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          size: 18,
          color: isFav ? Colors.red : Colors.white,
        ),
      ),
    );
  }
}

class _DietDot extends StatelessWidget {
  final bool isVeg;
  const _DietDot({required this.isVeg});

  @override
  Widget build(BuildContext context) {
    final color = isVeg ? Colors.green : Colors.red;

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

PageRouteBuilder _slideRoute(Widget page) => PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child,
      ),
    );