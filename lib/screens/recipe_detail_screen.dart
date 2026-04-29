// lib/screens/recipe_detail_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
// Premium detail screen with large hero, stat row, ingredients chips,
// and step-by-step instructions — matching reference image style.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../utils/app_theme.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Add to recently viewed once built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().addToRecentlyViewed(recipe.id);
    });

    return Scaffold(
      backgroundColor:
          context.isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        slivers: [
          _DetailSliverAppBar(recipe: recipe),
          SliverToBoxAdapter(child: _DetailBody(recipe: recipe)),
        ],
      ),
    );
  }
}

// ── Sliver AppBar with large hero image ───────────────────────────────────────

class _DetailSliverAppBar extends StatelessWidget {
  final Recipe recipe;
  const _DetailSliverAppBar({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<RecipeProvider>();
    final isFav = prov.isFav(recipe.id);

    return SliverAppBar(
  expandedHeight: 420,
  pinned: true,
  backgroundColor: Colors.black,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => Navigator.pop(context),
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.favorite_border),
      onPressed: () {},
    ),
  ],
  flexibleSpace: FlexibleSpaceBar(
  background: ClipRRect(
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/quickcook_banner.png',
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),

        Container(
          color: Colors.black.withOpacity(0.25),
        ),

        Positioned(
          left: 20,
          bottom: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "QuickCook",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Where Time Meets Taste",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),
);
  }
}

// ── Hero image with gradient overlay ─────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  final Recipe recipe;
  const _HeroImage({required this.recipe});

  static const _palettes = [
    [Color(0xFFFF5C28), Color(0xFFFF9068)],
    [Color(0xFFFF8C00), Color(0xFFFFBE5C)],
    [Color(0xFF14B8A6), Color(0xFF5EEAD4)],
    [Color(0xFF8B5CF6), Color(0xFFC4B5FD)],
    [Color(0xFFEF4444), Color(0xFFFCA5A5)],
    [Color(0xFF22C55E), Color(0xFF86EFAC)],
  ];

  String get _emoji {
    final n = recipe.name.toLowerCase();
    if (n.contains('chicken') || n.contains('mutton')) return '🍗';
    if (n.contains('fish') || n.contains('prawn')) return '🐟';
    if (n.contains('biryani')) return '🍚';
    if (n.contains('dosa') || n.contains('idli')) return '🥞';
    if (n.contains('curry')) return '🍛';
    if (n.contains('halwa') ||
        n.contains('kheer') ||
        n.contains('gulab')) {
      return '🍮';
    }
    if (n.contains('salad') || n.contains('raita')) return '🥗';
    if (n.contains('dal') || n.contains('soup')) return '🥣';
    if (n.contains('roti') || n.contains('paratha')) return '🫓';
    if (n.contains('samosa')) return '🥟';
    return '🍽️';
  }

  @override
  Widget build(BuildContext context) {
    final idx =
        recipe.name.isEmpty ? 0 : recipe.name.codeUnitAt(0) % _palettes.length;
    final pair = _palettes[idx];

    return Stack(
      fit: StackFit.expand,
      children: [
        recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
            ? Image.network(
  recipe.imageUrl!,
  width: double.infinity,
  height: double.infinity,
  fit: BoxFit.fitWidth,
  alignment: Alignment.topCenter,
  errorBuilder: (context, error, stackTrace) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: pair,
        ),
      ),
      child: Center(
        child: Text(
          _emoji,
          style: const TextStyle(fontSize: 90),
        ),
      ),
    );
  },
)
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: pair,
                  ),
                ),
                child: Center(
                  child: Text(
                    _emoji,
                    style: const TextStyle(fontSize: 90),
                  ),
                ),
              ),

        // Dark overlay for readability
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
              stops: const [0.5, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}
// ── Detail body ────────────────────────────────────────────────────────────────

class _DetailBody extends StatelessWidget {
  final Recipe recipe;
  const _DetailBody({required this.recipe});

  String _cap(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  @override
  Widget build(BuildContext context) {
    final qc = context.qc;

    return Container(
      color: qc.bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title & badges ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Diet badge
                    _DietBadge(isVeg: recipe.isVeg),
                    if (recipe.noCook) ...[
                      const SizedBox(width: 8),
                      _Badge('🥗 No Cook', AppColors.noCookTeal),
                    ],
                    if (recipe.flavorProfile.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      _Badge(
                          _cap(recipe.flavorProfile), AppColors.orange),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  recipe.name,
                  style: TextStyle(
                    color: qc.text1,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
                if (recipe.state.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.place_outlined,
                          size: 14, color: qc.text3),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.state}, ${recipe.region}',
                        style: TextStyle(color: qc.text3, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // ── Stat pills ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                _StatBox(
                  icon: Icons.timer_outlined,
                  value: recipe.totalTime > 0
                      ? '${recipe.totalTime}m'
                      : '—',
                  label: 'Total',
                  color: AppColors.orange,
                  qc: qc,
                ),
                const SizedBox(width: 10),
                _StatBox(
                  icon: Icons.cut_outlined,
                  value: recipe.prepTime > 0
                      ? '${recipe.prepTime}m'
                      : '—',
                  label: 'Prep',
                  color: AppColors.noCookTeal,
                  qc: qc,
                ),
                const SizedBox(width: 10),
                _StatBox(
                  icon: Icons.local_fire_department_outlined,
                  value: recipe.cookTime > 0
                      ? '${recipe.cookTime}m'
                      : '0m',
                  label: 'Cook',
                  color: const Color(0xFFEF4444),
                  qc: qc,
                ),
                if (recipe.course.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  _StatBox(
                    icon: Icons.restaurant_menu_outlined,
                    value: _cap(recipe.course).split(' ').first,
                    label: 'Course',
                    color: const Color(0xFF8B5CF6),
                    qc: qc,
                  ),
                ],
              ],
            ),
          ),

          const _Divider(),

          // ── Ingredients ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: _SectionTitle(title: 'Ingredients', qc: qc),
          ),
          const SizedBox(height: 14),

          // Scrollable ingredient chips (horizontal)
          if (recipe.ingredients.isNotEmpty) ...[
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: recipe.ingredients.length,
                itemBuilder: (_, i) => _IngChip(
                  label: _cap(recipe.ingredients[i]),
                  isSelected: i == 0,
                  qc: qc,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ] else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'No ingredients listed.',
                style: TextStyle(color: qc.text3),
              ),
            ),

          const _Divider(),

          // ── Instructions ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: _SectionTitle(title: 'Instructions', qc: qc),
          ),
          const SizedBox(height: 16),
          _InstructionsView(instructions: recipe.instructions, qc: qc),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _DietBadge extends StatelessWidget {
  final bool isVeg;
  const _DietBadge({required this.isVeg});

  @override
  Widget build(BuildContext context) {
    final color = isVeg ? AppColors.vegGreen : AppColors.nonVegRed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            isVeg ? 'Vegetarian' : 'Non-Veg',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final QuickCookThemeExt qc;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.qc,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.09),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: qc.text3,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IngChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final QuickCookThemeExt qc;

  const _IngChip({
    required this.label,
    required this.isSelected,
    required this.qc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.orange : qc.chip,
        borderRadius: BorderRadius.circular(30),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : qc.text2,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final QuickCookThemeExt qc;
  const _SectionTitle({required this.title, required this.qc});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: qc.text1,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: context.qc.divider,
    );
  }
}

class _InstructionsView extends StatelessWidget {
  final String instructions;
  final QuickCookThemeExt qc;
  const _InstructionsView({required this.instructions, required this.qc});

  @override
  Widget build(BuildContext context) {
    final steps = instructions
        .split(RegExp(r'\.\s+(?=[A-Z0-9])'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (steps.length <= 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          instructions,
          style: TextStyle(color: qc.text2, fontSize: 14, height: 1.7),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: steps.asMap().entries.map((entry) {
          return _StepRow(
            step: entry.key + 1,
            text: entry.value,
            qc: qc,
          );
        }).toList(),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int step;
  final String text;
  final QuickCookThemeExt qc;
  const _StepRow({required this.step, required this.text, required this.qc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number bubble
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.orange, AppColors.orangeDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: qc.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: qc.divider),
              ),
              child: Text(
                text.endsWith('.') ? text : '$text.',
                style: TextStyle(
                  color: qc.text2,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
