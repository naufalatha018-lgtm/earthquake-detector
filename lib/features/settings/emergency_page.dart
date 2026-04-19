import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_style.dart';
import '../../presentation/widgets/seismo_app_bar.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});
  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final _locationCtrl = TextEditingController();

  final _contacts = [
    {'name': 'BNPB', 'role': 'National Disaster Agency', 'phone': '129', 'color': AppColors.danger},
    {'name': 'Medical Emergency', 'role': 'Ambulance / Hospital', 'phone': '118', 'color': AppColors.warning},
    {'name': 'Police', 'role': 'Law Enforcement', 'phone': '110', 'color': AppColors.safe},
  ];

  @override
  void dispose() {
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              SeismoAppBar(title: 'Emergency Protocol'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Evac Point
                    const Text('EVACUATION POINT', style: AppStyle.label),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppStyle.glassCard(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.location_on_rounded, size: 16, color: AppColors.danger),
                              SizedBox(width: 8),
                              Text('Meeting Point', style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                              )),
                            ],
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _locationCtrl,
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'e.g. Lapangan Taman Kota, RT 05',
                              prefixIcon: Icon(Icons.flag_rounded, size: 18, color: AppColors.textMuted),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Evacuation point saved ✓')),
                              ),
                              style: AppStyle.primaryButton,
                              child: const Text('Save Location',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text('EMERGENCY CONTACTS', style: AppStyle.label),
                    const SizedBox(height: 12),
                    Container(
                      decoration: AppStyle.glassCard(),
                      child: Column(
                        children: _contacts.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final c = entry.value;
                          final color = c['color'] as Color;
                          return Column(
                            children: [
                              if (idx > 0) const Divider(height: 1, color: AppColors.border),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44, height: 44,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: color.withOpacity(0.12),
                                        border: Border.all(color: color.withOpacity(0.25), width: 1),
                                      ),
                                      child: Center(
                                        child: Text(
                                          (c['name'] as String)[0],
                                          style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w700, color: color,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(c['name'] as String, style: const TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                                          )),
                                          Text(c['role'] as String, style: const TextStyle(
                                            fontSize: 12, color: AppColors.textMuted,
                                          )),
                                        ],
                                      ),
                                    ),
                                    // Phone number badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: color.withOpacity(0.25)),
                                      ),
                                      child: Text(
                                        c['phone'] as String,
                                        style: TextStyle(
                                          fontSize: 13, fontWeight: FontWeight.w700, color: color,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Calling ${c['name']}...')),
                                        );
                                      },
                                      child: Container(
                                        width: 36, height: 36,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.safe.withOpacity(0.15),
                                          border: Border.all(color: AppColors.safe.withOpacity(0.3)),
                                        ),
                                        child: const Icon(Icons.call_rounded, size: 16, color: AppColors.safe),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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
}
