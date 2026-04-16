#!/bin/bash

echo "Fixing project..."

# PROVIDER
cat << 'EOP' > lib/state/providers/gempa_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';

class GempaProvider extends ChangeNotifier {
  Map<String, String> gempa = {
    "tanggal": "-",
    "jam": "-",
    "magnitude": "-",
    "kedalaman": "-",
    "wilayah": "-",
  };

  List<double> magnitudes = [1, 2, 3];
  List<Map<String, String>> logs = [];

  Timer? _timer;

  void startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _updateGempa();
    });
  }

  void _updateGempa() {
    final now = DateTime.now();

    gempa = {
      "tanggal": "${now.day}/${now.month}/${now.year}",
      "jam": "${now.hour}:${now.minute}:${now.second}",
      "magnitude": (2 + (now.second % 5)).toString(),
      "kedalaman": "${10 + now.second} km",
      "wilayah": "Dummy Area",
    };

    logs.insert(0, Map.from(gempa));
    if (logs.length > 20) logs.removeLast();

    magnitudes.add(double.parse(gempa["magnitude"]!));
    if (magnitudes.length > 10) magnitudes.removeAt(0);

    notifyListeners();
  }
}
EOP

# LOGS
cat << 'EOP' > lib/presentation/pages/logs_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/providers/gempa_provider.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = context.watch<GempaProvider>().logs;

    return Scaffold(
      appBar: AppBar(title: const Text("Logs")),
      body: logs.isEmpty
          ? const Center(child: Text("Belum ada data"))
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (_, i) {
                final log = logs[i];
                return ListTile(
                  title: Text("M ${log['magnitude']} - ${log['wilayah']}"),
                  subtitle: Text("${log['tanggal']} ${log['jam']}"),
                );
              },
            ),
    );
  }
}
EOP

# SETTINGS
cat << 'EOP' > lib/presentation/pages/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          ListTile(title: Text('Account')),
          ListTile(title: Text('Hardware')),
          ListTile(title: Text('Alerts')),
          ListTile(title: Text('Emergency')),
          ListTile(title: Text('System')),
        ],
      ),
    );
  }
}
EOP

# ROUTER
cat << 'EOP' > lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import '../../presentation/pages/dashboard_page.dart';
import '../../presentation/pages/logs_page.dart';
import '../../presentation/pages/settings_page.dart';

final router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/dashboard',
      builder: (_, __) => const DashboardPage(),
    ),
    GoRoute(
      path: '/logs',
      builder: (_, __) => const LogsPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (_, __) => const SettingsPage(),
    ),
  ],
);
EOP

echo "DONE"
