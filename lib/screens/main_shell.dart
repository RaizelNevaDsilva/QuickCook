// lib/screens/main_shell.dart
// ─────────────────────────────────────────────────────────────────────────────
// Root scaffold with floating bottom navigation bar.
// Tabs: Home · Explore · Favourites · Settings
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../utils/app_theme.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final qc = context.qc;

    final screens = [
      const HomeScreen(),
      const FavoritesScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: qc.bg,
      body: IndexedStack(
        index: _index,
        children: screens,
      ),
      bottomNavigationBar: _FloatingNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        qc: qc,
        isDark: context.isDark,
      ),
    );
  }
}

// ── Floating bottom nav bar ───────────────────────────────────────────────────

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final QuickCookThemeExt qc;
  final bool isDark;

  const _FloatingNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.qc,
    required this.isDark,
  });

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.favorite_rounded, label: 'Favourites'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    // Get fav count for badge
    final favCount =
        context.watch<RecipeProvider>().favourites.length;

    return Container(
      margin: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      height: 68,
      decoration: BoxDecoration(
        color: qc.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.5 : 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final isActive = i == currentIndex;
          final showBadge = i == 1 && favCount > 0;

          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 64,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.orange.withOpacity(0.14)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          item.icon,
                          size: 22,
                          color: isActive
                              ? AppColors.orange
                              : qc.text3,
                        ),
                      ),
                      if (showBadge)
                        Positioned(
                          top: -2,
                          right: -4,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                favCount > 9 ? '9+' : '$favCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: isActive ? AppColors.orange : qc.text3,
                      fontSize: 10,
                      fontWeight: isActive
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                    child: Text(item.label),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
