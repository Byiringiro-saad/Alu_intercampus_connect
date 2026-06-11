import 'package:flutter/material.dart';

/// ALU Connect — magenta brand (#C031B5) on clean whitish surfaces.
class AppColors {
  AppColors._();

  // Brand core — primary #C031B5
  static const Color brandPrimary = Color(0xFFC031B5);
  static const Color brandDeep = Color(0xFF952588);
  static const Color brandMid = Color(0xFFC031B5);
  static const Color brandBright = Color(0xFFD54BC4);
  static const Color brandSoft = Color(0xFFE879DE);

  // Legacy aliases — same tokens, updated to brand magenta
  static const Color navy = Color(0xFF1A0F18);
  static const Color navyDeep = brandDeep;
  static const Color navyMid = brandMid;
  static const Color navyBright = brandBright;
  static const Color navySoft = brandSoft;

  // Semantic aliases (used across widgets)
  static const Color primary = brandMid;
  static const Color primaryLight = brandBright;
  static const Color secondary = brandSoft;
  static const Color accent = brandMid;
  @Deprecated('Use AppColors.brand() — kept for gradual migration')
  static const Color accentGold = brandBright;

  // Whitish light surfaces — cool, airy, modern
  static const Color background = Color(0xFFFAFBFD);
  static const Color backgroundAlt = Color(0xFFF4F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFEEF2F7);
  static const Color textPrimary = Color(0xFF1A0F18);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Dark mode — deep magenta ink (optional toggle)
  static const Color darkBackground = Color(0xFF120A14);
  static const Color darkSurface = Color(0xFF1A111C);
  static const Color darkCard = Color(0xFF221428);
  static const Color darkElevated = Color(0xFF2A1830);
  static const Color darkBorder = Color(0xFF3D2545);

  // Semantic
  static const Color success = Color(0xFF059669);
  static const Color error = Color(0xFFDC2626);
  static const Color purple = Color(0xFFD54BC4);
  static const Color indigo = Color(0xFF952588);
  static const Color teal = Color(0xFF0D9488);

  // Category accents — magenta family
  static const Color categoryEvents = Color(0xFFC031B5);
  static const Color categoryHackathons = Color(0xFFD54BC4);
  static const Color categoryWorkshops = Color(0xFF952588);
  static const Color categoryStartups = Color(0xFF9A268F);

  /// Primary interactive brand — adapts for dark surfaces.
  static Color brand(bool isDark) =>
      isDark ? const Color(0xFFF0A8EB) : brandMid;

  static Color brandMuted(bool isDark) =>
      brand(isDark).withValues(alpha: isDark ? 0.18 : 0.1);
}
