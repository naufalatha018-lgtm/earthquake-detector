import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_style.dart';
import '../../presentation/widgets/seismo_app_bar.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});
  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  String _selectedLevel = 'Medium';
  bool _notifEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  final _levels = [
    {
      'level': 'Low',
      'desc': 'Magnitude > 5.0 within 100km',
      'color': AppColors.safe,
      'icon': Icons.check_circle_outline_rounded,
    },
    {
      'level': 'Medium',
      'desc': 'Magnitude > 4.5 within 200km',
      'color': AppColors.warning,
      'icon': Icons.warning_amber_rounded,
    },
    {
      'level': 'High',
      'desc': 'Magnitude > 4.0 within 300km',
      'color': AppColors.danger,
      'icon': Icons.crisis_alert_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              SeismoAppBar(title: 'Alert Parameters'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text('SENSITIVITY LEVEL', style: AppStyle.label),
                    const SizedBox(height: 12),
                    ..._levels.map((l) {
                      final isSelected = _selectedLevel == l['level'];
                      final color = l['color'] as Color;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedLevel = l['level'] as String),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withOpacity(0.12)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? color.withOpacity(0.5) : AppColors.border,
                              width: isSelected ? 1.5 : 0.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42, height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color.withOpacity(0.15),
                                ),
                                child: Icon(l['icon'] as IconData, color: color, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l['level'] as String,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? color : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      l['desc'] as String,
                                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 20, height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? color : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected ? color : AppColors.border,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 24),
                    const Text('NOTIFICATIONS', style: AppStyle.label),
                    const SizedBox(height: 12),
                    Container(
                      decoration: AppStyle.glassCard(),
                      child: Column(
                        children: [
                          _switchTile(
                            'Push Notifications',
                            'Receive alerts on your phone',
                            Icons.notifications_outlined,
                            _notifEnabled,
                            (v) => setState(() => _notifEnabled = v),
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _switchTile(
                            'Alarm Sound',
                            'Play alarm when danger detected',
                            Icons.volume_up_rounded,
                            _soundEnabled,
                            (v) => setState(() => _soundEnabled = v),
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _switchTile(
                            'Vibration',
                            'Vibrate device on alert',
                            Icons.vibration_rounded,
                            _vibrationEnabled,
                            (v) => setState(() => _vibrationEnabled = v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Alert settings saved ✓')),
                        ),
                        style: AppStyle.primaryButton,
                        child: const Text('Save Settings',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchTile(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.safe.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.safe),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                )),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.safe,
            activeTrackColor: AppColors.safe.withOpacity(0.3),
            inactiveThumbColor: AppColors.textMuted,
            inactiveTrackColor: AppColors.border,
          ),
        ],
      ),
    );
  }
}
