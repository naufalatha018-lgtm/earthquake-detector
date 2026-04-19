import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_style.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      {
        'label': 'USER',
        'items': [
          {'title': 'Account & Access', 'subtitle': 'Profile, password, family users',
           'icon': Icons.person_outline_rounded, 'route': '/settings/account',
           'color': AppColors.safe},
        ],
      },
      {
        'label': 'DEVICE',
        'items': [
          {'title': 'Hardware & Diagnostics', 'subtitle': 'Device status, signal, OTA',
           'icon': Icons.memory_rounded, 'route': '/settings/hardware',
           'color': const Color(0xFF7B61FF)},
        ],
      },
      {
        'label': 'ALERTS',
        'items': [
          {'title': 'Alert Parameters', 'subtitle': 'Risk level, notifications',
           'icon': Icons.warning_amber_rounded, 'route': '/settings/alerts',
           'color': AppColors.warning},
          {'title': 'Emergency Protocol', 'subtitle': 'Contacts, evacuation point',
           'icon': Icons.phone_in_talk_rounded, 'route': '/settings/emergency',
           'color': AppColors.danger},
        ],
      },
      {
        'label': 'APP',
        'items': [
          {'title': 'System Preferences', 'subtitle': 'Theme, language',
           'icon': Icons.tune_rounded, 'route': '/settings/system',
           'color': AppColors.textSecondary},
        ],
      },
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary, size: 18),
                    ),
                    const Expanded(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile card at top
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppStyle.glassCard(),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.safe],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'P',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Paul',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Administrator',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.safe.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.safe.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'ONLINE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.safe,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: sections.length,
                  itemBuilder: (context, si) {
                    final section = sections[si];
                    final items = section['items'] as List;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            section['label'] as String,
                            style: AppStyle.label,
                          ),
                        ),
                        Container(
                          decoration: AppStyle.glassCard(),
                          child: Column(
                            children: items.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final item = entry.value as Map<String, dynamic>;
                              return Column(
                                children: [
                                  if (idx > 0)
                                    const Divider(
                                      height: 1,
                                      color: AppColors.border,
                                      indent: 64,
                                    ),
                                  _buildSettingsTile(context, item),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, Map<String, dynamic> item) {
    final color = item['color'] as Color;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push(item['route'] as String),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withOpacity(0.2), width: 0.5),
              ),
              child: Icon(item['icon'] as IconData, size: 18, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['subtitle'] as String,
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
