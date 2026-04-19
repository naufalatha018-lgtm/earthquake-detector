import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/providers/gempa_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_style.dart';
import '../../presentation/widgets/seismo_app_bar.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  Color _magColor(double mag) {
    if (mag >= 6.0) return AppColors.danger;
    if (mag >= 5.0) return AppColors.dangerLight;
    if (mag >= 4.0) return AppColors.warning;
    return AppColors.safe;
  }

  String _magLabel(double mag) {
    if (mag >= 6.0) return 'SEVERE';
    if (mag >= 5.0) return 'HIGH';
    if (mag >= 4.0) return 'MODERATE';
    return 'LOW';
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GempaProvider>();
    final mags = p.magnitudes;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                        size: 18,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Seismic Logs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.safe.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.safe.withOpacity(0.3)),
                      ),
                      child: Text(
                        '${mags.length} records',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.safe,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: mags.isEmpty
                  ? const Center(
                      child: Text(
                        'No seismic data yet',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      itemCount: mags.length,
                      itemBuilder: (context, index) {
                        final reversedIndex = mags.length - 1 - index;
                        final mag = mags[reversedIndex];
                        final color = _magColor(mag);
                        final label = _magLabel(mag);
                        final now = DateTime.now().subtract(
                          Duration(seconds: (mags.length - reversedIndex) * 3),
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: AppStyle.glassCard(),
                          child: Row(
                            children: [
                              // Magnitude circle
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color.withOpacity(0.15),
                                  border: Border.all(color: color.withOpacity(0.4), width: 1.5),
                                ),
                                child: Center(
                                  child: Text(
                                    mag.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            label,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: color,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      p.gempa['wilayah'] ?? 'Unknown Region',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${_pad(now.hour)}:${_pad(now.minute)}:${_pad(now.second)}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Depth
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('DEPTH', style: AppStyle.label),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${10 + reversedIndex} km',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _pad(int v) => v.toString().padLeft(2, '0');
}
