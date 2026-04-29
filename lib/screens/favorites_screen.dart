// lib/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<RecipeProvider>();
    final qc = context.qc;
    final favs = prov.favourites;

    return Scaffold(
      backgroundColor: qc.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: qc.bg,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              'Favourites',
              style: TextStyle(
                color: qc.text1,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${favs.length}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (favs.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('❤️', style: const TextStyle(fontSize: 56)),
                    const SizedBox(height: 16),
                    Text(
                      'No favourites yet',
                      style: TextStyle(
                        color: qc.text1,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap ♥ on any recipe to save it here',
                      style: TextStyle(color: qc.text3, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final r = favs[i];
                  return Dismissible(
                    key: ValueKey(r.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.favorite_border,
                          color: Colors.red),
                    ),
                    onDismissed: (_) => prov.toggleFav(r.id),
                    child: RecipeCardFull(recipe: r),
                  );
                },
                childCount: favs.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
