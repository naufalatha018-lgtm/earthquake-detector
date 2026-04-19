import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_style.dart';
import '../../presentation/widgets/seismo_app_bar.dart';

class SystemPage extends StatefulWidget {
  const SystemPage({super.key});
  @override
  State<SystemPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> {
  String _theme = 'Dark';
  String _language = 'English';
  bool _demoMode = true;
  bool _autoConnect = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              SeismoAppBar(title: 'System Preferences'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text('APPEARANCE', style: AppStyle.label),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppStyle.glassCard(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Theme', style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
                          )),
                          const SizedBox(height: 10),
                          Row(
                            children: ['Dark', 'Light', 'System'].map((t) {
                              final isSelected = _theme == t;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _theme = t),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.safe.withOpacity(0.15) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected ? AppColors.safe.withOpacity(0.5) : AppColors.border,
                                        width: isSelected ? 1.5 : 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      t,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? AppColors.safe : AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: AppStyle.glassCard(),
                      child: Row(
                        children: [
                          const Icon(Icons.language_rounded, size: 18, color: AppColors.textMuted),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text('Language', style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                            )),
                          ),
                          DropdownButton<String>(
                            value: _language,
                            dropdownColor: AppColors.surfaceElevated,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            underline: const SizedBox(),
                            items: ['English', 'Indonesia'].map((e) =>
                              DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (v) => setState(() => _language = v!),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text('APPLICATION', style: AppStyle.label),
                    const SizedBox(height: 12),
                    Container(
                      decoration: AppStyle.glassCard(),
                      child: Column(
                        children: [
                          _switchRow(
                            'Demo Mode',
                            'Use simulated seismic data',
                            Icons.science_outlined,
                            AppColors.warning,
                            _demoMode,
                            (v) => setState(() => _demoMode = v),
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _switchRow(
                            'Auto Reconnect',
                            'Auto-connect to device on startup',
                            Icons.wifi_rounded,
                            AppColors.safe,
                            _autoConnect,
                            (v) => setState(() => _autoConnect = v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text('ABOUT', style: AppStyle.label),
                    const SizedBox(height: 12),
                    Container(
                      decoration: AppStyle.glassCard(),
                      child: Column(
                        children: [
                          _infoTile('App Version', '1.0.0'),
                          const Divider(height: 1, color: AppColors.border),
                          _infoTile('Build', '2024.04'),
                          const Divider(height: 1, color: AppColors.border),
                          _infoTile('Device ID', 'SGQ-001-A1B2'),
                        ],
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

  Widget _switchRow(String title, String sub, IconData icon, Color color, bool value, ValueChanged<bool> cb) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                )),
                Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: cb,
            activeColor: AppColors.safe,
            activeTrackColor: AppColors.safe.withOpacity(0.3),
            inactiveThumbColor: AppColors.textMuted,
            inactiveTrackColor: AppColors.border,
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
          )),
        ],
      ),
    );
  }
}
