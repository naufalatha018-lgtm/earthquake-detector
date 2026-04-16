import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// IMPORT PAGE
import 'package:gempa_bumi/presentation/pages/login_page.dart';
import 'package:gempa_bumi/presentation/pages/main_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [

    // LOGIN
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    // MAIN APP
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const MainPage(),
    ),

  ],
);
