// UPDATED UI - PREMIUM STYLE
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gempa_bumi/state/providers/gempa_provider.dart';
import 'package:gempa_bumi/core/theme/app_style.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  Color _magnitudeColor(double mag) {
    if (mag >= 6.0) return const Color(0xFFDC2626);
    if (mag >= 5.0) return const Color(0xFFEA580C);
    if (mag >= 4.0) return const Color(0xFFD97706);
    return const Color(0xFF16A34A);
  }

  String _magnitudeLabel(double mag) {
    if (mag >= 6.0) return 'Kritis';
    if (mag >= 5.0) return 'Tinggi';
    if (mag >= 4.0) return 'Sedang';
    return 'Normal';
  }

  @override
  Widget build(BuildContext context) {
    final logs = context.watch<GempaProvider>().logs;

    return Scaffold(
      backgroundColor: AppStyle.bg(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text(
          'Seismic Logs',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black87),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C2E).withOpacity(0.07),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${logs.length} records',
                style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      body: logs.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
                    ),
                    child: const Icon(Icons.sensors_off_rounded, size: 36, color: Colors.black26),
                  ),
                  const SizedBox(height: 16),
                  const Text('Belum ada data log', style: TextStyle(color: Colors.black45, fontSize: 15, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  const Text('Data akan muncul saat simulasi berjalan', style: TextStyle(color: Colors.black26, fontSize: 12)),
                ],
              ),
            )
          : Column(
              children: [
                // ── Summary Header ───────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Row(
                    children: [
                      _SummaryChip(label: 'Normal', color: const Color(0xFF16A34A), logs: logs, maxMag: 4.0),
                      const SizedBox(width: 8),
                      _SummaryChip(label: 'Sedang', color: const Color(0xFFD97706), logs: logs, minMag: 4.0, maxMag: 5.0),
                      const SizedBox(width: 8),
                      _SummaryChip(label: 'Tinggi', color: const Color(0xFFDC2626), logs: logs, minMag: 5.0),
                    ],
                  ),
                ),
                // ── List ─────────────────────────────────────
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final item = logs[logs.length - 1 - index]; // newest first
                      final mag = double.tryParse(item['magnitude'] ?? '0') ?? 0;
                      final color = _magnitudeColor(mag);
                      final label = _magnitudeLabel(mag);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: Row(
                          children: [
                            // Left accent bar
                            Container(
                              width: 4,
                              height: 72,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Magnitude badge
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['magnitude'] ?? '-',
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: color),
                                  ),
                                  Text('M', style: TextStyle(fontSize: 9, color: color.withOpacity(0.7))),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['wilayah'] ?? '-',
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule_rounded, size: 11, color: Colors.black38),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${item['tanggal']} • ${item['jam']}',
                                        style: const TextStyle(fontSize: 11, color: Colors.black45),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Badge
                            Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  label,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final Color color;
  final List logs;
  final double minMag;
  final double maxMag;

  const _SummaryChip({
    required this.label,
    required this.color,
    required this.logs,
    this.minMag = 0,
    this.maxMag = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final count = logs.where((e) {
      final m = double.tryParse(e['magnitude'] ?? '0') ?? 0;
      return m >= minMag && m < maxMag;
    }).length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text('$label ($count)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
