import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_page.dart';
import '../../features/auth/register_page.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/dashboard/logs_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/settings/account_page.dart';
import '../../features/settings/hardware_page.dart';
import '../../features/settings/alerts_page.dart';
import '../../features/settings/emergency_page.dart';
import '../../features/settings/system_page.dart';
import '../../presentation/pages/splash_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (_, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashPage(),
        transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (_, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (_, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const RegisterPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
          return SlideTransition(position: slide, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/',
      pageBuilder: (_, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const DashboardPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/logs',
      pageBuilder: (_, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LogsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
          return SlideTransition(position: slide, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (_, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SettingsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
          return SlideTransition(position: slide, child: child);
        },
      ),
    ),
    GoRoute(path: '/settings/account', builder: (_, __) => const AccountPage()),
    GoRoute(path: '/settings/hardware', builder: (_, __) => const HardwarePage()),
    GoRoute(path: '/settings/alerts', builder: (_, __) => const AlertsPage()),
    GoRoute(path: '/settings/emergency', builder: (_, __) => const EmergencyPage()),
    GoRoute(path: '/settings/system', builder: (_, __) => const SystemPage()),
  ],
);
