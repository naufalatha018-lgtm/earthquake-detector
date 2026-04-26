import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/providers/settings_provider.dart';
import '../../core/theme/app_style.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    final items = [
      {'title': settings.getString('account_access'), 'icon': Icons.person_outline_rounded, 'route': '/settings/account'},
      {'title': settings.getString('hardware_diag'), 'icon': Icons.memory_rounded, 'route': '/settings/hardware'},
      {'title': settings.getString('alert_params'), 'icon': Icons.warning_amber_rounded, 'route': '/settings/alerts'},
      {'title': settings.getString('emergency_proto'), 'icon': Icons.phone_in_talk_rounded, 'route': '/settings/emergency'},
      {'title': settings.getString('system_prefs'), 'icon': Icons.tune_rounded, 'route': '/settings/system'},
    ];

    return Scaffold(
      backgroundColor: AppStyle.bg(context),
      appBar: AppBar(
        title: Text(settings.getString('settings')),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push(item['route'] as String),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: AppStyle.card(context),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
