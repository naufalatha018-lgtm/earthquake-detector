// UPDATED UI
// SETTINGS + MULTIPROVIDER

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/providers/gempa_provider.dart';
import 'state/providers/app_settings_provider.dart'; // 👈 TAMBAH
import 'core/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // EXISTING (JANGAN DIUBAH)
        ChangeNotifierProvider(
          create: (_) {
            final p = GempaProvider();
            p.startSimulation();
            return p;
          },
        ),

        // 👇 TAMBAHAN BARU
        ChangeNotifierProvider(
          create: (_) => AppSettingsProvider(),
        ),
      ],

      // 🔥 INI YANG PENTING
      child: Consumer<AppSettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,

            // 🌙 THEME (AKTIF)
            themeMode: settings.themeMode,
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),

            // 🌐 LANGUAGE (AKTIF)
            locale: settings.locale,
            supportedLocales: const [
              Locale('id'),
              Locale('en'),
            ],

            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}