import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyle {
  // Card decoration
  static BoxDecoration card({Color? color, double radius = 16}) {
    return BoxDecoration(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.border, width: 0.5),
    );
  }

  static BoxDecoration glassCard({double radius = 16}) {
    return BoxDecoration(
      gradient: AppColors.cardGradient,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.border.withOpacity(0.8), width: 0.5),
    );
  }

  // Text styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.2,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14, color: AppColors.textSecondary, height: 1.5,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12, color: AppColors.textMuted, letterSpacing: 0.5,
  );
  static const TextStyle label = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 1.2,
  );

  // Button styles
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.safe,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );

  static ButtonStyle dangerButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.danger,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );
}
