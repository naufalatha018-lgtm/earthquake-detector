import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

abstract class AppTheme {
  AppTheme._();

  // ── Public factories ────────────────────────────────────

  static ThemeData light() => _build(
        brightness: Brightness.light,
        bg: AppColors.lightBg,
        surface: AppColors.lightSurface,
        textPrimary: AppColors.textPrimary,
        textSecondary: AppColors.textSecondary,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: AppColors.lightBg,
        ),
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        bg: AppColors.darkBg,
        surface: AppColors.darkSurface,
        textPrimary: AppColors.textPrimaryDark,
        textSecondary: AppColors.textSecondaryDark,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: AppColors.darkBg,
        ),
      );

  // ── Builder ─────────────────────────────────────────────

  static ThemeData _build({
    required Brightness brightness,
    required Color bg,
    required Color surface,
    required Color textPrimary,
    required Color textSecondary,
    required SystemUiOverlayStyle systemOverlayStyle,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,

      colorScheme: ColorScheme(
        brightness: brightness,
        background: bg,
        surface: surface,
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryGlow,
        onPrimary: Colors.white,
        onPrimaryContainer: AppColors.primary,
        secondary: AppColors.safe,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.safeGlow,
        onSecondaryContainer: AppColors.safe,
        error: AppColors.danger,
        onError: Colors.white,
        errorContainer: isDark ? AppColors.dangerBgDark : AppColors.dangerBg,
        onErrorContainer: AppColors.danger,
        onBackground: textPrimary,
        onSurface: textPrimary,
        outline: textSecondary.withOpacity(0.3),
        surfaceVariant: surface,
        onSurfaceVariant: textSecondary,
      ),

      textTheme: _buildTextTheme(textPrimary, textSecondary),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: systemOverlayStyle,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: textPrimary, size: AppSpacing.iconMd),
      ),

      // NavigationBar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: bg,
        indicatorColor: AppColors.primary.withOpacity(0.15),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          final selected = states.contains(MaterialState.selected);
          return GoogleFonts.inter(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 11,
            color: selected ? AppColors.primary : textSecondary,
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          final selected = states.contains(MaterialState.selected);
          return IconThemeData(
            color: selected ? AppColors.primary : textSecondary,
            size: AppSpacing.iconMd,
          );
        }),
        elevation: 0,
      ),

      // Card (used as fallback, prefer NeuCard widget)
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),

      // TextField
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bg,
        hintStyle: GoogleFonts.inter(
          color: textSecondary.withOpacity(0.6),
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.inter(
          color: textSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: textSecondary.withOpacity(0.12),
        thickness: 1,
        space: AppSpacing.lg,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        labelStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.primary.withOpacity(0.2),
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primaryGlow,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (s) => s.contains(MaterialState.selected) ? AppColors.primary : textSecondary,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (s) => s.contains(MaterialState.selected)
              ? AppColors.primary.withOpacity(0.4)
              : textSecondary.withOpacity(0.2),
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.textPrimary,
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Text Theme ──────────────────────────────────────────

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
          color: primary, fontWeight: FontWeight.w800, fontSize: 40, letterSpacing: -1.5),
      displayMedium: GoogleFonts.inter(
          color: primary, fontWeight: FontWeight.w700, fontSize: 32, letterSpacing: -1),
      displaySmall: GoogleFonts.inter(
          color: primary, fontWeight: FontWeight.w700, fontSize: 28, letterSpacing: -0.5),
      headlineLarge: GoogleFonts.inter(
          color: primary, fontWeight: FontWeight.w700, fontSize: 24, letterSpacing: -0.5),
      headlineMedium: GoogleFonts.inter(
          color: primary, fontWeight: FontWeight.w600, fontSize: 20, letterSpacing: -0.3),
      headlineSmall: GoogleFonts.inter(
          color: primary, fontWeight: FontWeight.w600, fontSize: 18, letterSpacing: -0.2),
      titleLarge: GoogleFonts.inter(
          color: primary, fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: -0.2),
      titleMedium: GoogleFonts.inter(
          color: primary, fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: -0.1),
      titleSmall: GoogleFonts.inter(
          color: primary, fontWeight: FontWeight.w500, fontSize: 12),
      bodyLarge: GoogleFonts.inter(
          color: primary, fontWeight: FontWeight.w400, fontSize: 16),
      bodyMedium: GoogleFonts.inter(
          color: secondary, fontWeight: FontWeight.w400, fontSize: 14),
      bodySmall: GoogleFonts.inter(
          color: secondary, fontWeight: FontWeight.w400, fontSize: 12),
      labelLarge: GoogleFonts.inter(
          color: primary, fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.1),
      labelMedium: GoogleFonts.inter(
          color: secondary, fontWeight: FontWeight.w500, fontSize: 12),
      labelSmall: GoogleFonts.inter(
          color: secondary, fontWeight: FontWeight.w400, fontSize: 10, letterSpacing: 0.5),
    );
  }
}
