import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Editorial design tokens — magenta accents, soft elevation on white.
class AppDecorations {
  AppDecorations._();

  static const double radiusXs = 8;
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 28;

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color borderColor(BuildContext context) =>
      _isDark(context) ? AppColors.darkBorder : AppColors.border;

  static Color mutedSurface(BuildContext context) =>
      _isDark(context) ? AppColors.darkCard : AppColors.surfaceMuted;

  static LinearGradient primaryGradient({bool isDark = false}) =>
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [AppColors.brandMid, AppColors.brandBright]
            : [AppColors.brandDeep, AppColors.brandBright],
      );

  static LinearGradient accentGradient({bool isDark = false}) =>
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [AppColors.brandBright, AppColors.brandSoft]
            : [AppColors.brandMid, AppColors.brandSoft],
      );

  static LinearGradient pageWash({bool isDark = false}) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [AppColors.darkBackground, AppColors.darkBackground]
            : [
                const Color(0xFFFFFFFF),
                AppColors.background,
                AppColors.backgroundAlt,
              ],
        stops: isDark ? const [0, 1] : const [0, 0.45, 1],
      );

  static List<BoxShadow> softShadow(BuildContext context) {
    final isDark = _isDark(context);
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.35)
            : AppColors.brandPrimary.withValues(alpha: 0.06),
        blurRadius: isDark ? 16 : 24,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
        blurRadius: 4,
        offset: const Offset(0, 1),
      ),
    ];
  }

  static List<BoxShadow> glowShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.18),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static BoxDecoration surfaceCard(BuildContext context, {Color? color}) =>
      BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radiusLg),
        border: Border.all(
          color: _isDark(context)
              ? AppColors.darkBorder
              : AppColors.borderLight,
        ),
      );

  static BoxDecoration elevatedCard(BuildContext context) => BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radiusLg),
        border: Border.all(
          color: _isDark(context)
              ? AppColors.darkBorder
              : AppColors.borderLight,
        ),
        boxShadow: softShadow(context),
      );

  static BoxDecoration glassCard(BuildContext context) => surfaceCard(context);

  static BoxDecoration meshBackground({bool isDark = false}) => BoxDecoration(
        gradient: pageWash(isDark: isDark),
      );
}
