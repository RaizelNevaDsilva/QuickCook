// lib/utils/app_theme.dart
// ─────────────────────────────────────────────────────────────────────────────
// QuickCook premium dual-theme system.
// Dark: deep charcoal + saffron orange (reference image style)
// Light: warm cream + orange accents
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AppColors {
  AppColors._();

  // ── Brand palette (shared) ─────────────────────────────────────────────────
  static const Color orange       = Color(0xFFFF5C28);   // primary CTA
  static const Color orangeLight  = Color(0xFFFF7A4D);
  static const Color orangeDeep   = Color(0xFFE04010);
  static const Color orangeGlow   = Color(0x33FF5C28);   // 20% opacity glow

  // ── Dark theme tokens ──────────────────────────────────────────────────────
  static const Color darkBg       = Color(0xFF0F0F0F);
  static const Color darkSurface  = Color(0xFF1A1A1A);
  static const Color darkCard     = Color(0xFF222222);
  static const Color darkCardAlt  = Color(0xFF2A2A2A);
  static const Color darkDivider  = Color(0xFF2E2E2E);
  static const Color darkText1    = Color(0xFFFFFFFF);
  static const Color darkText2    = Color(0xFFB0B0B0);
  static const Color darkText3    = Color(0xFF707070);
  static const Color darkChip     = Color(0xFF2C2C2C);
  static const Color darkInput    = Color(0xFF1E1E1E);

  // ── Light theme tokens ─────────────────────────────────────────────────────
  static const Color lightBg      = Color(0xFFF7F3EE);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard    = Color(0xFFFFFFFF);
  static const Color lightCardAlt = Color(0xFFFFF4ED);
  static const Color lightDivider = Color(0xFFEDE8E2);
  static const Color lightText1   = Color(0xFF1A1008);
  static const Color lightText2   = Color(0xFF6B5E52);
  static const Color lightText3   = Color(0xFFAA9E96);
  static const Color lightChip    = Color(0xFFFFEDE4);
  static const Color lightInput   = Color(0xFFFFFFFF);

  // ── Badge colours ──────────────────────────────────────────────────────────
  static const Color vegGreen     = Color(0xFF22C55E);
  static const Color nonVegRed    = Color(0xFFEF4444);
  static const Color noCookTeal   = Color(0xFF14B8A6);
}

// ─────────────────────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  // ── DARK ──────────────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
        colorScheme: const ColorScheme.dark(
          primary:        AppColors.orange,
          secondary:      AppColors.orangeLight,
          surface:        AppColors.darkSurface,
          onPrimary:      Colors.white,
          onSurface:      AppColors.darkText1,
          onSurfaceVariant: AppColors.darkText2,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: AppColors.darkText1),
          titleTextStyle: TextStyle(
            color: AppColors.darkText1,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkInput,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(
            color: AppColors.darkText3,
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 14,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.darkChip,
          selectedColor: AppColors.orange,
          labelStyle: const TextStyle(
            color: AppColors.darkText2,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.orange,
          unselectedItemColor: AppColors.darkText3,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppColors.orange
                : AppColors.darkText3,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppColors.orangeGlow
                : AppColors.darkChip,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.darkDivider,
          thickness: 1,
        ),
        extensions: const [QuickCookThemeExt.dark],
      );

  // ── LIGHT ─────────────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
        colorScheme: const ColorScheme.light(
          primary:        AppColors.orange,
          secondary:      AppColors.orangeLight,
          surface:        AppColors.lightSurface,
          onPrimary:      Colors.white,
          onSurface:      AppColors.lightText1,
          onSurfaceVariant: AppColors.lightText2,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightBg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: AppColors.lightText1),
          titleTextStyle: TextStyle(
            color: AppColors.lightText1,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.lightCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightInput,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(
            color: AppColors.lightText3,
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 14,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.lightChip,
          selectedColor: AppColors.orange,
          labelStyle: const TextStyle(
            color: AppColors.lightText2,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.lightSurface,
          selectedItemColor: AppColors.orange,
          unselectedItemColor: AppColors.lightText3,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppColors.orange
                : Colors.grey,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppColors.orangeGlow
                : Colors.grey.withOpacity(0.2),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.lightDivider,
          thickness: 1,
        ),
        extensions: const [QuickCookThemeExt.light],
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Theme extension: gives widgets easy access to semantic colours that differ
// between dark / light without needing Theme.of(context).brightness checks.
// ─────────────────────────────────────────────────────────────────────────────
class QuickCookThemeExt extends ThemeExtension<QuickCookThemeExt> {
  final Color bg;
  final Color surface;
  final Color card;
  final Color cardAlt;
  final Color text1;
  final Color text2;
  final Color text3;
  final Color chip;
  final Color input;
  final Color divider;

  const QuickCookThemeExt({
    required this.bg,
    required this.surface,
    required this.card,
    required this.cardAlt,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.chip,
    required this.input,
    required this.divider,
  });

  static const dark = QuickCookThemeExt(
    bg:       AppColors.darkBg,
    surface:  AppColors.darkSurface,
    card:     AppColors.darkCard,
    cardAlt:  AppColors.darkCardAlt,
    text1:    AppColors.darkText1,
    text2:    AppColors.darkText2,
    text3:    AppColors.darkText3,
    chip:     AppColors.darkChip,
    input:    AppColors.darkInput,
    divider:  AppColors.darkDivider,
  );

  static const light = QuickCookThemeExt(
    bg:       AppColors.lightBg,
    surface:  AppColors.lightSurface,
    card:     AppColors.lightCard,
    cardAlt:  AppColors.lightCardAlt,
    text1:    AppColors.lightText1,
    text2:    AppColors.lightText2,
    text3:    AppColors.lightText3,
    chip:     AppColors.lightChip,
    input:    AppColors.lightInput,
    divider:  AppColors.lightDivider,
  );

  @override
  QuickCookThemeExt copyWith({
    Color? bg, Color? surface, Color? card, Color? cardAlt,
    Color? text1, Color? text2, Color? text3,
    Color? chip, Color? input, Color? divider,
  }) =>
      QuickCookThemeExt(
        bg:      bg      ?? this.bg,
        surface: surface ?? this.surface,
        card:    card    ?? this.card,
        cardAlt: cardAlt ?? this.cardAlt,
        text1:   text1   ?? this.text1,
        text2:   text2   ?? this.text2,
        text3:   text3   ?? this.text3,
        chip:    chip    ?? this.chip,
        input:   input   ?? this.input,
        divider: divider ?? this.divider,
      );

  @override
  QuickCookThemeExt lerp(QuickCookThemeExt? other, double t) {
    if (other == null) return this;
    return QuickCookThemeExt(
      bg:      Color.lerp(bg,      other.bg,      t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card:    Color.lerp(card,    other.card,    t)!,
      cardAlt: Color.lerp(cardAlt, other.cardAlt, t)!,
      text1:   Color.lerp(text1,   other.text1,   t)!,
      text2:   Color.lerp(text2,   other.text2,   t)!,
      text3:   Color.lerp(text3,   other.text3,   t)!,
      chip:    Color.lerp(chip,    other.chip,     t)!,
      input:   Color.lerp(input,   other.input,   t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Convenience extension to get QC colours from any BuildContext
// ─────────────────────────────────────────────────────────────────────────────
extension QCTheme on BuildContext {
  QuickCookThemeExt get qc =>
      Theme.of(this).extension<QuickCookThemeExt>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
