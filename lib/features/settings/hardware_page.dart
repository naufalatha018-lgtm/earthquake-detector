import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_style.dart';
import '../../presentation/widgets/seismo_app_bar.dart';

class HardwarePage extends StatefulWidget {
  const HardwarePage({super.key});
  @override
  State<HardwarePage> createState() => _HardwarePageState();
}

class _HardwarePageState extends State<HardwarePage> {
  bool isOnline = true;
  double rssi = 0.72;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              SeismoAppBar(title: 'Hardware & Diagnostics'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Device status card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: isOnline ? AppColors.safeGradient : AppColors.dangerGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (isOnline ? AppColors.safe : AppColors.danger).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50, height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                            ),
                            child: const Icon(Icons.sensors_rounded, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('SeismoGuard Sensor', style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white,
                                )),
                                const SizedBox(height: 4),
                                Text(
                                  isOnline ? 'Connected & Active' : 'Disconnected',
                                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isOnline ? 'ONLINE' : 'OFFLINE',
                              style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Signal card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppStyle.glassCard(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Signal Strength (RSSI)', style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                              )),
                              Text('${(rssi * 100).toInt()}%', style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.safe,
                              )),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: rssi,
                              minHeight: 8,
                              backgroundColor: AppColors.border,
                              valueColor: AlwaysStoppedAnimation(
                                rssi > 0.6 ? AppColors.safe : rssi > 0.3 ? AppColors.warning : AppColors.danger,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('Strong signal — excellent connection',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Actions
                    Container(
                      decoration: AppStyle.glassCard(),
                      child: Column(
                        children: [
                          _actionTile(
                            icon: Icons.campaign_rounded,
                            color: AppColors.warning,
                            title: 'Simulate Siren',
                            subtitle: 'Test alarm output',
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Siren Activated 🔊')),
                            ),
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _actionTile(
                            icon: Icons.system_update_rounded,
                            color: AppColors.safe,
                            title: 'Check OTA Update',
                            subtitle: 'Firmware v1.2.3 installed',
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Checking for updates...')),
                            ),
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _actionTile(
                            icon: Icons.link_off_rounded,
                            color: AppColors.danger,
                            title: 'Unbind Device',
                            subtitle: 'Remove device from account',
                            onTap: () => _showUnbindDialog(context),
                          ),
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

  Widget _actionTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withOpacity(0.2), width: 0.5),
              ),
              child: Icon(icon, size: 18, color: color),
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
            const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  void _showUnbindDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Unbind Device', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        content: const Text('This will remove your device. Continue?', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Device removed')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Unbind', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
