import 'package:flutter/material.dart';

class AppColors {
  // === BRAND COLORS ===
  static const Color primary = Color(0xFF0A2540);      // Navy deep
  static const Color primaryLight = Color(0xFF1A3A5C); // Navy medium
  static const Color primaryDark = Color(0xFF051525);  // Navy darkest

  static const Color danger = Color(0xFFE63946);       // Alert red
  static const Color dangerLight = Color(0xFFFF6B6B);  // Soft red
  static const Color dangerDark = Color(0xFFC1121F);   // Deep red

  static const Color safe = Color(0xFF0096C7);         // Alert blue
  static const Color safeLight = Color(0xFF48CAE4);    // Soft blue
  static const Color safeDark = Color(0xFF0077A8);     // Deep blue

  static const Color success = Color(0xFF06D6A0);      // Green
  static const Color warning = Color(0xFFFFB703);      // Amber

  // === NEUTRAL ===
  static const Color background = Color(0xFF050D1A);   // Dark bg
  static const Color surface = Color(0xFF0D1E35);      // Card surface
  static const Color surfaceElevated = Color(0xFF112240); // Elevated card
  static const Color border = Color(0xFF1E3A5F);       // Border

  static const Color textPrimary = Color(0xFFEFF6FF);
  static const Color textSecondary = Color(0xFF8BA5C4);
  static const Color textMuted = Color(0xFF4A6FA5);

  // === GRADIENT ===
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF050D1A), Color(0xFF0A1628), Color(0xFF0D2240)],
  );

  static const LinearGradient safeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A2540), Color(0xFF0077A8), Color(0xFF0096C7)],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A0A0A), Color(0xFF8B0000), Color(0xFFE63946)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D1E35), Color(0xFF112240)],
  );
}
