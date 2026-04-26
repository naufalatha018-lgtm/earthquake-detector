import 'package:flutter/material.dart';
import 'package:seismo_guard/core/theme/app_style.dart';

class AppLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showBack;

  const AppLayout({
    super.key,
    required this.title,
    required this.child,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppStyle.bg(context),
      appBar: AppBar(
        leading: showBack ? const BackButton() : null,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
