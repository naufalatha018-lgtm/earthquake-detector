import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// pages
import '../../features/dashboard/dashboard_page.dart';
import '../../features/dashboard/logs_page.dart';
import '../../features/settings/settings_page.dart';

// settings pages
import '../../features/settings/account_page.dart';
import '../../features/settings/hardware_page.dart';
import '../../features/settings/alerts_page.dart';
import '../../features/settings/emergency_page.dart';
import '../../features/settings/system_page.dart';

// auth
import '../../features/auth/login_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const DashboardPage(),
    ),

    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
    ),

    GoRoute(
      path: '/logs',
      builder: (_, __) => const LogsPage(),
    ),

    GoRoute(
      path: '/settings',
      builder: (_, __) => const SettingsPage(),
    ),

    // 🔥 SETTINGS DETAIL
    GoRoute(
      path: '/settings/account',
      builder: (_, __) => const AccountPage(),
    ),
    GoRoute(
      path: '/settings/hardware',
      builder: (_, __) => const HardwarePage(),
    ),
    GoRoute(
      path: '/settings/alerts',
      builder: (_, __) => const AlertsPage(),
    ),
    GoRoute(
      path: '/settings/emergency',
      builder: (_, __) => const EmergencyPage(),
    ),
    GoRoute(
      path: '/settings/system',
      builder: (_, __) => const SystemPage(),
    ),
  ],
);