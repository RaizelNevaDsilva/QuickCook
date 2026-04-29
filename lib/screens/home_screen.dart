// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/filter_state.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/section_header.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/ingredient_chips.dart';
import '../widgets/lazy_mode_card.dart';
import '../utils/app_colors.dart';
import 'category_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  bool _showIngredientInput = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<RecipeProvider>();
    final bool filtersActive = prov.hasActiveFilter;

    if (prov.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _HeroHeader()),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: QCSearchBar(
                controller: _searchCtrl,
                onChanged: prov.updateSearch,
                hint: 'Search recipes, ingredients…',
                onFilterTap: () => setState(
                  () => _showIngredientInput = !_showIngredientInput,
                ),
              ),
            ),
          ),

          if (_showIngredientInput)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: IngredientChipsInput(
                  chips: prov.filter.ingredientTokens,
                  onChanged: prov.updateIngredients,
                ),
              ),
            ),

          SliverToBoxAdapter(
            child: _TimeChips(
              selected: prov.filter.timeFilter,
              onSelect: prov.updateTimeFilter,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _buildToggle(
                        context, 'Veg', prov.filter.dietFilter == 'Veg'),
                    _buildToggle(context, 'Non-Veg',
                        prov.filter.dietFilter == 'Non-Veg'),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: LazyModeCard(
                isOn: prov.filter.lazyModeOn,
                onToggle: prov.toggleLazy,
              ),
            ),
          ),

          if (filtersActive) ...[
            SliverToBoxAdapter(
              child: _FilteredResultsHeader(
                count: prov.filtered.length,
                onClear: () {
                  prov.clearFilters();
                  _searchCtrl.clear();
                  setState(() => _showIngredientInput = false);
                },
              ),
            ),
            prov.filtered.isEmpty
                ? const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _NoResultsPlaceholder(),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => RecipeCardFull(
                        recipe: prov.filtered[i],
                      ),
                      childCount: prov.filtered.length,
                    ),
                  ),
          ] else ...[
            _buildSection('⚡ Quick Recipes', prov.quickRecipes),
            _buildSection(
                '🕒 Recently Viewed', prov.recentlyViewedRecipes),
            _buildSection(
                '✨ Recommended For You', prov.recommendedRecipes),
            _buildSection('🥗 No-Cook Picks', prov.noCookRecipes),
            _buildSection('🍛 Trending Now', prov.trending),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 110)),
        ],
      ),
    );
  }

  Widget _buildToggle(BuildContext context, String text, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<RecipeProvider>().updateDietFilter(text);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color:
                    selected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Recipe> recipes) {
    if (recipes.isEmpty) {
  return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverToBoxAdapter(
      child: Column(
        children: [
          SectionHeader(
            title: title,
            actionLabel: 'See all',
            onAction: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (_, __, ___) => CategoryResultsScreen(
                    title: title,
                    recipes: List.from(recipes), // ✅ FIX HERE
                  ),
                  transitionsBuilder: (_, anim, __, child) =>
                      FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(parent: anim, curve: Curves.easeOut),
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.2, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                            parent: anim, curve: Curves.easeOutCubic),
                      ),
                      child: child,
                    ),
                  ),
                ),
              );
            },
          ),
          _HorizontalList(recipes: recipes),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────

class _HorizontalList extends StatelessWidget {
  final List<Recipe> recipes;
  final double cardWidth;

  const _HorizontalList({
    required this.recipes,
    this.cardWidth = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: cardWidth,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: RecipeCardH(recipe: recipes[index]),
            ),
          );
        },
      ),
    );
  }
}

// (rest unchanged — keeping same as your file)

class _FilteredResultsHeader extends StatelessWidget {
  final int count;
  final VoidCallback onClear;

  const _FilteredResultsHeader({
    required this.count,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$count recipes found',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          TextButton(
            onPressed: onClear,
            child: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }
}

class _NoResultsPlaceholder extends StatelessWidget {
  const _NoResultsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off,
                size: 64, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text(
              'No recipes found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try changing your filters or ingredients',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeChips extends StatelessWidget {
  final TimeFilter selected;
  final Function(TimeFilter) onSelect;

  const _TimeChips({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      TimeFilter.any,
      TimeFilter.under15,
      TimeFilter.under30,
      TimeFilter.under60,
      TimeFilter.under120,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Wrap(
        spacing: 12,
        children: options.map((tf) {
          final isSelected = selected == tf;

          return ChoiceChip(
            label: Text(tf.label),
            selected: isSelected,
            onSelected: (_) => onSelect(tf),
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            labelStyle: TextStyle(
              color:
                  isSelected ? Colors.white : AppColors.textSecondary,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 240,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/homepage_banner.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ],
    );
  }
}