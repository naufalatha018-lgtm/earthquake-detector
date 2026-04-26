import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/providers/settings_provider.dart';
import 'dashboard_page.dart';
import 'logs_page.dart';
import '../../features/settings/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final pages = const [
    DashboardPage(),
    LogsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_rounded),
            label: settings.getString('dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt_rounded),
            label: settings.getString('logs'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_rounded),
            label: settings.getString('settings'),
          ),
        ],
      ),
    );
  }
}
