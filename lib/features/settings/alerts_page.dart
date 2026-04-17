// UPDATED UI - PREMIUM STYLE
import 'package:flutter/material.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  String selectedLevel = "Medium";
  bool notificationEnabled = true;

  static const _bg = Color(0xFFF8FAFC);
  static const _dark = Color(0xFF1C1C2E);

  BoxDecoration get _cardDecor => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
      );

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Container(width: 3, height: 16, decoration: BoxDecoration(color: _dark, borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
          ],
        ),
      );

  final _levels = [
    {'key': 'Low', 'desc': 'Magnitude > 5.0 dalam radius 100km', 'color': 0xFF16A34A, 'icon': Icons.shield_outlined},
    {'key': 'Medium', 'desc': 'Magnitude > 4.5 dalam radius 200km', 'color': 0xFFD97706, 'icon': Icons.warning_amber_rounded},
    {'key': 'High', 'desc': 'Magnitude > 4.0 dalam radius 300km', 'color': 0xFFDC2626, 'icon': Icons.crisis_alert_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text('Alert Parameters', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Active level banner ───────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_dark, Color(0xFF2E2E4E)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: _dark.withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 6))],
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active_rounded, color: Colors.white70, size: 28),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Active Alert Level', style: TextStyle(color: Colors.white54, fontSize: 11, letterSpacing: 0.8)),
                      Text(selectedLevel, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Risk Level Section ────────────────────────────
            _sectionLabel('Risk Level'),
            Container(
              decoration: _cardDecor,
              child: Column(
                children: _levels.asMap().entries.map((entry) {
                  final i = entry.key;
                  final level = entry.value;
                  final key = level['key'] as String;
                  final isSelected = selectedLevel == key;
                  final color = Color(level['color'] as int);
                  final icon = level['icon'] as IconData;

                  return Column(
                    children: [
                      if (i > 0) const Divider(height: 1, indent: 20, endIndent: 20),
                      InkWell(
                        onTap: () => setState(() => selectedLevel = key),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(isSelected ? 0.15 : 0.07),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(icon, size: 20, color: color),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(key, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: isSelected ? color : Colors.black87)),
                                    const SizedBox(height: 2),
                                    Text(level['desc'] as String, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 20, height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: isSelected ? color : Colors.black26, width: 2),
                                  color: isSelected ? color : Colors.transparent,
                                ),
                                child: isSelected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // ── Notification Section ──────────────────────────
            _sectionLabel('Notifikasi'),
            Container(
              decoration: _cardDecor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: notificationEnabled ? const Color(0xFF6366F1).withOpacity(0.1) : const Color(0xFFF0F0F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        notificationEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_outlined,
                        size: 20,
                        color: notificationEnabled ? const Color(0xFF6366F1) : Colors.black38,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Push Notification', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                          Text('Aktifkan notifikasi push', style: TextStyle(fontSize: 12, color: Colors.black45)),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: notificationEnabled,
                      activeColor: const Color(0xFF6366F1),
                      onChanged: (value) => setState(() => notificationEnabled = value),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
