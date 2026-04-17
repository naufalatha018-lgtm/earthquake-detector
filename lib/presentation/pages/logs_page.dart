import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gempa_bumi/state/providers/gempa_provider.dart';
import 'package:gempa_bumi/core/theme/app_style.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rawLogs = context.watch<GempaProvider>().logs;
    final List<dynamic> logs = rawLogs is List ? rawLogs : [];

    return Scaffold(
      backgroundColor: AppStyle.bg(context),
      appBar: AppBar(
        title: const Text('Logs'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: logs.isEmpty
            ? const Center(
                child: Text("Belum ada data"),
              )
            : ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final item = logs[index] as Map<String, dynamic>;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: AppStyle.cardDecoration(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Magnitude ${item['magnitude'] ?? '-'}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(item['wilayah'] ?? '-'),
                        const SizedBox(height: 4),
                        Text(
                          "${item['tanggal'] ?? '-'} • ${item['jam'] ?? '-'}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}