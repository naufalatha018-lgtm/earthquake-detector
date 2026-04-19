import 'package:flutter/material.dart';

/// Central color tokens for the Bhukampa neumorphism design system.
/// Never use raw Color() values outside this file.
abstract class AppColors {
  AppColors._();

  // ── Light Neumorphism Surface ──────────────────────────
  static const Color lightBg          = Color(0xFFE0E5EC);
  static const Color lightSurface     = Color(0xFFE8EDF4);
  static const Color lightShadowHigh  = Color(0xFFFFFFFF);
  static const Color lightShadowLow   = Color(0xFFA3B1C6);

  // ── Dark Neumorphism Surface ───────────────────────────
  static const Color darkBg           = Color(0xFF1E2230);
  static const Color darkSurface      = Color(0xFF252A3D);
  static const Color darkShadowHigh   = Color(0xFF2E3450);
  static const Color darkShadowLow    = Color(0xFF111420);

  // ── Brand / Semantic ───────────────────────────────────
  static const Color primary          = Color(0xFF6C7FD8);
  static const Color primaryVariant   = Color(0xFF5A6BC4);
  static const Color primaryGlow      = Color(0x336C7FD8);

  static const Color danger           = Color(0xFFCF6E6E);
  static const Color dangerSoft       = Color(0xFFE8A0A0);
  static const Color dangerGlow       = Color(0x33CF6E6E);
  static const Color dangerBg         = Color(0xFFF5E0E0);
  static const Color dangerBgDark     = Color(0xFF3A2020);

  static const Color warning          = Color(0xFFD4A056);
  static const Color warningSoft      = Color(0xFFEDC98C);
  static const Color warningBg        = Color(0xFFF5ECD8);

  static const Color safe             = Color(0xFF5DAA8F);
  static const Color safeSoft         = Color(0xFF8BC9B3);
  static const Color safeGlow         = Color(0x335DAA8F);
  static const Color safeBg           = Color(0xFFDFF2EC);
  static const Color safeBgDark       = Color(0xFF1A3028);

  static const Color online           = Color(0xFF4CAF8A);
  static const Color offline          = Color(0xFFADB5BD);

  // ── Text ───────────────────────────────────────────────
  static const Color textPrimary      = Color(0xFF2D3748);
  static const Color textSecondary    = Color(0xFF718096);
  static const Color textTertiary     = Color(0xFFB0BAC8);

  static const Color textPrimaryDark     = Color(0xFFE2E8F0);
  static const Color textSecondaryDark   = Color(0xFF94A3B8);
  static const Color textTertiaryDark    = Color(0xFF64748B);

  // ── Neumorphism Shadow Factories ───────────────────────

  /// Elevated (outer shadow) — light mode
  static List<BoxShadow> elevatedLight({
    double blur = 16,
    double offset = 6,
    double spread = 0,
  }) =>
      [
        BoxShadow(
          color: lightShadowHigh.withOpacity(0.92),
          blurRadius: blur,
          spreadRadius: spread,
          offset: Offset(-offset, -offset),
        ),
        BoxShadow(
          color: lightShadowLow.withOpacity(0.72),
          blurRadius: blur,
          spreadRadius: spread,
          offset: Offset(offset, offset),
        ),
      ];

  /// Elevated (outer shadow) — dark mode
  static List<BoxShadow> elevatedDark({
    double blur = 16,
    double offset = 6,
    double spread = 0,
  }) =>
      [
        BoxShadow(
          color: darkShadowHigh.withOpacity(0.55),
          blurRadius: blur,
          spreadRadius: spread,
          offset: Offset(-offset, -offset),
        ),
        BoxShadow(
          color: darkShadowLow.withOpacity(0.92),
          blurRadius: blur,
          spreadRadius: spread,
          offset: Offset(offset, offset),
        ),
      ];

  /// Pressed / inset shadow — light mode
  static List<BoxShadow> pressedLight({double blur = 8}) => [
        BoxShadow(
          color: lightShadowLow.withOpacity(0.55),
          blurRadius: blur,
          offset: const Offset(3, 3),
        ),
        BoxShadow(
          color: lightShadowHigh.withOpacity(0.92),
          blurRadius: blur,
          offset: const Offset(-3, -3),
        ),
      ];

  /// Pressed / inset shadow — dark mode
  static List<BoxShadow> pressedDark({double blur = 8}) => [
        BoxShadow(
          color: darkShadowLow.withOpacity(0.88),
          blurRadius: blur,
          offset: const Offset(3, 3),
        ),
        BoxShadow(
          color: darkShadowHigh.withOpacity(0.45),
          blurRadius: blur,
          offset: const Offset(-3, -3),
        ),
      ];
}
