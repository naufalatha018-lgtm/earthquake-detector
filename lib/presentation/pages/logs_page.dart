import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seismo_guard/state/providers/gempa_provider.dart';
import 'package:seismo_guard/core/theme/app_style.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = context.watch<GempaProvider>().logs;

    return Scaffold(
      backgroundColor: AppStyle.bg(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Logs',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: logs.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_rounded, size: 48, color: Colors.black26),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada data log',
                    style: TextStyle(color: Colors.black45, fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final item = logs[index];
                final mag = double.tryParse(item['magnitude'] ?? '0') ?? 0;
                final isHigh = mag >= 5;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isHigh
                              ? const Color(0xFF1C1C2E)
                              : const Color(0xFFF0F0F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            item['magnitude'] ?? '-',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: isHigh ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['wilayah'] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item['tanggal']} • ${item['jam']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isHigh
                              ? const Color(0xFFFFECEC)
                              : const Color(0xFFECF5EC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isHigh ? 'Tinggi' : 'Normal',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isHigh
                                ? const Color(0xFFCC3333)
                                : const Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
