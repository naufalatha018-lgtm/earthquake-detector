import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum RiskLevel { aman, waspada, bahaya }

class RiskResult {
  final RiskLevel level;
  final String label;
  final String description;
  final Color color;
  final Color bgColor;
  final Color bgColorDark;
  final IconData icon;

  const RiskResult({
    required this.level,
    required this.label,
    required this.description,
    required this.color,
    required this.bgColor,
    required this.bgColorDark,
    required this.icon,
  });
}

/// Pure local risk classification. No network, no backend.
///
/// Risk matrix:
/// ┌──────────────┬───────────────────┬────────────────────────┐
/// │ Magnitude    │ Distance          │ Result                 │
/// ├──────────────┼───────────────────┼────────────────────────┤
/// │ < 3.0        │ Any               │ AMAN                   │
/// │ 3.0 – 5.0    │ > 50 km           │ AMAN                   │
/// │ 3.0 – 5.0    │ 20 – 50 km        │ WASPADA                │
/// │ 3.0 – 5.0    │ < 20 km           │ BAHAYA                 │
/// │ 5.0 – 6.5    │ > 80 km           │ WASPADA                │
/// │ 5.0 – 6.5    │ ≤ 80 km           │ BAHAYA                 │
/// │ > 6.5        │ Any               │ BAHAYA                 │
/// └──────────────┴───────────────────┴────────────────────────┘
abstract class RiskEngine {
  RiskEngine._();

  static RiskResult classify(double magnitude, double distanceKm) {
    final level = _computeLevel(magnitude, distanceKm);
    return _toResult(level);
  }

  static RiskLevel _computeLevel(double mag, double dist) {
    if (mag < 3.0) return RiskLevel.aman;

    if (mag < 5.0) {
      if (dist > 50) return RiskLevel.aman;
      if (dist > 20) return RiskLevel.waspada;
      return RiskLevel.bahaya;
    }

    if (mag < 6.5) {
      if (dist > 80) return RiskLevel.waspada;
      return RiskLevel.bahaya;
    }

    // mag >= 6.5
    return RiskLevel.bahaya;
  }

  static RiskResult _toResult(RiskLevel level) {
    switch (level) {
      case RiskLevel.aman:
        return const RiskResult(
          level: RiskLevel.aman,
          label: 'AMAN',
          description: 'Tidak ada ancaman signifikan terdeteksi.',
          color: AppColors.safe,
          bgColor: AppColors.safeBg,
          bgColorDark: AppColors.safeBgDark,
          icon: Icons.shield_rounded,
        );
      case RiskLevel.waspada:
        return const RiskResult(
          level: RiskLevel.waspada,
          label: 'WASPADA',
          description: 'Aktivitas seismik terdeteksi. Tetap waspada.',
          color: AppColors.warning,
          bgColor: AppColors.warningBg,
          bgColorDark: Color(0xFF2E2510),
          icon: Icons.warning_amber_rounded,
        );
      case RiskLevel.bahaya:
        return const RiskResult(
          level: RiskLevel.bahaya,
          label: 'BAHAYA',
          description: 'Gempa signifikan! Segera cari perlindungan.',
          color: AppColors.danger,
          bgColor: AppColors.dangerBg,
          bgColorDark: AppColors.dangerBgDark,
          icon: Icons.dangerous_rounded,
        );
    }
  }
}
