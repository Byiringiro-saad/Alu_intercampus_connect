import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_decorations.dart';

/// Material 3 theme — magenta brand (#C031B5) on whitish, modern campus feel.
class AppTheme {
  AppTheme._();

  static TextTheme _textTheme(Brightness brightness) {
    final color = brightness == Brightness.dark
        ? Colors.white
        : AppColors.textPrimary;
    final body = GoogleFonts.figtreeTextTheme(
      brightness == Brightness.dark
          ? ThemeData.dark().textTheme
          : ThemeData.light().textTheme,
    );
    return body.copyWith(
      displaySmall: GoogleFonts.sora(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.8,
        color: color,
        height: 1.15,
      ),
      headlineMedium: GoogleFonts.sora(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: color,
      ),
      headlineSmall: GoogleFonts.sora(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: color,
      ),
      titleLarge: GoogleFonts.figtree(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleMedium: GoogleFonts.figtree(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      bodyLarge: GoogleFonts.figtree(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.figtree(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.72)
            : AppColors.textSecondary,
        height: 1.45,
      ),
      labelLarge: GoogleFonts.figtree(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelSmall: GoogleFonts.figtree(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        color: AppColors.textTertiary,
      ),
    );
  }

  static ThemeData light() {
    final colorScheme = ColorScheme.light(
      primary: AppColors.brandMid,
      onPrimary: Colors.white,
      secondary: AppColors.brandSoft,
      onSecondary: Colors.white,
      tertiary: AppColors.brandBright,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      outline: AppColors.border,
    );

    return _base(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      overlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.brandBright,
      onPrimary: Colors.white,
      secondary: AppColors.brandSoft,
      surface: AppColors.darkSurface,
      onSurface: Colors.white,
      outline: AppColors.darkBorder,
    );

    return _base(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      overlayStyle: SystemUiOverlayStyle.light,
    );
  }

  static ThemeData _base({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required SystemUiOverlayStyle overlayStyle,
  }) {
    final isDark = brightness == Brightness.dark;
    final textTheme = _textTheme(brightness);
    final brand = AppColors.brand(isDark);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : AppColors.navy,
        systemOverlayStyle: overlayStyle,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: isDark ? Colors.white : AppColors.navy,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusLg),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.borderLight,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkCard : AppColors.surface,
        hintStyle: TextStyle(
          color: isDark
              ? Colors.white.withValues(alpha: 0.35)
              : AppColors.textTertiary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
          borderSide: BorderSide(color: brand, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: isDark ? AppColors.brandBright : AppColors.brandMid,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
          ),
          textStyle: GoogleFonts.figtree(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brand,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
          ),
          side: BorderSide(color: brand.withValues(alpha: 0.45)),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusSm),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 2),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppColors.darkCard : AppColors.brandDeep,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusSm),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        elevation: 0,
        backgroundColor: Colors.transparent,
        indicatorColor: AppColors.brandMuted(isDark),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? brand
                : (isDark
                    ? Colors.white.withValues(alpha: 0.45)
                    : AppColors.textTertiary),
            size: 22,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return GoogleFonts.figtree(
            fontSize: 11,
            color: states.contains(WidgetState.selected)
                ? brand
                : AppColors.textTertiary,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
          );
        }),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: AppColors.brandMid,
        textColor: Colors.white,
      ),
    );
  }
}
