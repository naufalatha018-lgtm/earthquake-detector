import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seismo_guard/state/providers/gempa_provider.dart';
import 'package:seismo_guard/state/providers/settings_provider.dart';
import 'package:seismo_guard/core/theme/app_style.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GempaProvider>();
    final settings = context.watch<SettingsProvider>();
    final logs = provider.logs;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppStyle.bg(context),
      appBar: AppBar(
        title: Text(settings.getString('logs')),
      ),
      body: logs.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_rounded, size: 48, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3)),
                  const SizedBox(height: 12),
                  const Text(
                    'No data available',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
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
                  decoration: AppStyle.card(context),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isHigh
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            item['magnitude'] ?? '-',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: isHigh ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
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
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item['tanggal']} • ${item['jam']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isHigh
                              ? theme.colorScheme.errorContainer
                              : theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isHigh ? 'High' : 'Normal',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isHigh
                                ? theme.colorScheme.error
                                : theme.colorScheme.primary,
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
