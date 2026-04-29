// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'auth_wrapper.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final qc = context.qc;
    final themeProv = context.watch<ThemeProvider>();
    final isDark = themeProv.isDark;
    
    final user = FirebaseAuth.instance.currentUser;

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
              'Settings',
              style: TextStyle(
                color: qc.text1,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ── Profile card ─────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.orange, AppColors.orangeDeep],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.orange.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('👨‍🍳',
                                style: TextStyle(fontSize: 30)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.email?.split('@').first ?? 'Home Chef',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.email ?? 'QuickCook enthusiast 🍽️',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await AuthService().signOut();
                        // Assuming AuthWrapper is acting as the top-level route,
                        // this will automatically take us back to the Login Screen.
                        // However, since we used pushReplacement in SplashScreen, 
                        // this may just rebuild the screen.
                        // Actually, to be safe, pushReplacement to AuthWrapper:
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthWrapper()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text('Logout', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Appearance section ────────────────────────────────
                  _SectionLabel(label: 'Appearance', qc: qc),
                  const SizedBox(height: 12),

                  // Dark mode toggle
                  _SettingsTile(
                    qc: qc,
                    icon: isDark
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    iconColor: isDark ? AppColors.orange : const Color(0xFFFACC15),
                    title: 'Dark Mode',
                    subtitle: isDark ? 'Currently dark' : 'Currently light',
                    trailing: Switch(
                      value: isDark,
                      onChanged: (_) => themeProv.toggle(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Theme preview card
                  _ThemePreviewCard(isDark: isDark, qc: qc),

                  const SizedBox(height: 28),

                  // ── About section ─────────────────────────────────────
                  _SectionLabel(label: 'About', qc: qc),
                  const SizedBox(height: 12),

                  _SettingsTile(
                    qc: qc,
                    icon: Icons.info_outline,
                    iconColor: AppColors.orange,
                    title: 'QuickCook',
                    subtitle: 'Version 1.0.0 · Where Time Meets Taste',
                  ),
                  const SizedBox(height: 8),
                  _SettingsTile(
                    qc: qc,
                    icon: Icons.restaurant_outlined,
                    iconColor: AppColors.noCookTeal,
                    title: 'Recipe Dataset',
                    subtitle: 'Indian Food Collection',
                  ),
                  const SizedBox(height: 8),
                  _SettingsTile(
                    qc: qc,
                    icon: Icons.favorite_outline,
                    iconColor: Colors.red,
                    title: 'Made with ❤️',
                    subtitle: 'For Indian food lovers',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final QuickCookThemeExt qc;
  const _SectionLabel({required this.label, required this.qc});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: qc.text3,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final QuickCookThemeExt qc;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SettingsTile({
    required this.qc,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: qc.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: qc.text1,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: qc.text3,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _ThemePreviewCard extends StatelessWidget {
  final bool isDark;
  final QuickCookThemeExt qc;
  const _ThemePreviewCard({required this.isDark, required this.qc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: qc.cardAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: qc.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Theme',
            style: TextStyle(
              color: qc.text3,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ThemeOption(
                  label: '☀️ Light',
                  active: !isDark,
                  onTap: () =>
                      context.read<ThemeProvider>().setDark(false),
                  colors: const [Color(0xFFF7F3EE), Color(0xFFFF5C28)],
                  textColor: const Color(0xFF1A1008),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ThemeOption(
                  label: '🌙 Dark',
                  active: isDark,
                  onTap: () =>
                      context.read<ThemeProvider>().setDark(true),
                  colors: const [Color(0xFF0F0F0F), Color(0xFFFF5C28)],
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final List<Color> colors;
  final Color textColor;

  const _ThemeOption({
    required this.label,
    required this.active,
    required this.onTap,
    required this.colors,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? AppColors.orange : Colors.transparent,
            width: 2,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.orange.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (active) ...[
              const SizedBox(width: 4),
              Icon(Icons.check_circle, color: AppColors.orange, size: 14),
            ],
          ],
        ),
      ),
    );
  }
}
