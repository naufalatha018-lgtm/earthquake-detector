// UPDATED UI - PREMIUM STYLE
import 'package:flutter/material.dart';

class HardwarePage extends StatefulWidget {
  const HardwarePage({super.key});

  @override
  State<HardwarePage> createState() => _HardwarePageState();
}

class _HardwarePageState extends State<HardwarePage> {
  bool isOnline = true;
  double rssi = 70;

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

  Color get _signalColor {
    if (rssi >= 70) return const Color(0xFF16A34A);
    if (rssi >= 40) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  String get _signalLabel {
    if (rssi >= 70) return 'Baik';
    if (rssi >= 40) return 'Sedang';
    return 'Lemah';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text('Hardware & Diagnostics', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Device Status Card ────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isOnline ? [_dark, const Color(0xFF2E2E4E)] : [const Color(0xFF6B7280), const Color(0xFF9CA3AF)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: _dark.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 8))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                    child: Icon(isOnline ? Icons.sensors_rounded : Icons.sensors_off_rounded, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Device Status', style: TextStyle(color: Colors.white54, fontSize: 11, letterSpacing: 0.8)),
                        const SizedBox(height: 2),
                        Text(isOnline ? 'ONLINE' : 'OFFLINE', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(
                      color: isOnline ? const Color(0xFF4ADE80) : Colors.white38,
                      shape: BoxShape.circle,
                      boxShadow: isOnline ? [const BoxShadow(color: Color(0xFF4ADE80), blurRadius: 8, spreadRadius: 2)] : null,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Signal Strength ───────────────────────────────
            _sectionLabel('Kekuatan Sinyal (RSSI)'),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDecor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.signal_cellular_alt_rounded, size: 18, color: _signalColor),
                          const SizedBox(width: 8),
                          Text('Signal', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('${rssi.toInt()}%', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _signalColor)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: _signalColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                            child: Text(_signalLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _signalColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: rssi / 100,
                      minHeight: 10,
                      backgroundColor: const Color(0xFFF0F0F5),
                      valueColor: AlwaysStoppedAnimation(_signalColor),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Actions ───────────────────────────────────────
            _sectionLabel('Aksi'),
            Container(
              decoration: _cardDecor,
              child: Column(
                children: [
                  _ActionTile(
                    icon: Icons.volume_up_rounded,
                    label: 'Simulate Siren',
                    desc: 'Uji perangkat alarm',
                    color: const Color(0xFF6366F1),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Siren Activated 🔊'))),
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _ActionTile(
                    icon: Icons.system_update_alt_rounded,
                    label: 'Check Update (OTA)',
                    desc: 'Periksa pembaruan firmware',
                    color: const Color(0xFF2563EB),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checking Update...'))),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Danger Zone ───────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDC2626).withOpacity(0.2)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFDC2626)),
                      SizedBox(width: 6),
                      Text('Danger Zone', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFFDC2626))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Melepas perangkat akan menghapus semua data konfigurasi.', style: TextStyle(fontSize: 12, color: Colors.black45, height: 1.4)),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Text('Unbind Device', style: TextStyle(fontWeight: FontWeight.w700)),
                          content: const Text('Yakin ingin melepas perangkat ini?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Device Removed')));
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              child: const Text('Ya, Lepas'),
                            ),
                          ],
                        ),
                      ),
                      icon: const Icon(Icons.link_off_rounded, size: 16, color: Color(0xFFDC2626)),
                      label: const Text('Unbind Device', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFDC2626)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label, desc;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({required this.icon, required this.label, required this.desc, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                  Text(desc, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
