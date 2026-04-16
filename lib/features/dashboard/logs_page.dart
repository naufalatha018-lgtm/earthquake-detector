import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/providers/gempa_provider.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GempaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Logs"),
        leading: const BackButton(), // 🔥 FIX
      ),
      body: ListView.builder(
        itemCount: p.magnitudes.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text("Magnitude: ${p.magnitudes[i]}"),
          );
        },
      ),
    );
  }
}
