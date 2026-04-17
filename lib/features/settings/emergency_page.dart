// UPDATED UI - PREMIUM STYLE
import 'package:flutter/material.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final locationController = TextEditingController();

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
            Container(width: 3, height: 16, decoration: BoxDecoration(color: const Color(0xFFDC2626), borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
          ],
        ),
      );

  final _contacts = [
    {'name': 'BNPB', 'phone': '129', 'icon': Icons.emergency_rounded, 'color': 0xFFDC2626},
    {'name': 'Medical Emergency', 'phone': '118', 'icon': Icons.local_hospital_rounded, 'color': 0xFFEA580C},
    {'name': 'Police', 'phone': '110', 'icon': Icons.local_police_rounded, 'color': 0xFF2563EB},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text('Emergency Protocol', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Warning Banner ────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withOpacity(0.07),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDC2626).withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Simpan titik evakuasi dan kontak darurat sebelum terjadi bencana.',
                      style: TextStyle(fontSize: 12, color: Color(0xFFDC2626), fontWeight: FontWeight.w500, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Evacuation Point ──────────────────────────────
            _sectionLabel('Titik Evakuasi'),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDecor,
              child: Column(
                children: [
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan lokasi titik kumpul',
                      hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
                      prefixIcon: const Icon(Icons.location_on_outlined, size: 18, color: Colors.black38),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _dark, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location Saved')));
                      },
                      icon: const Icon(Icons.save_outlined, size: 18),
                      label: const Text('Save Location', style: TextStyle(fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _dark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Emergency Contacts ────────────────────────────
            _sectionLabel('Kontak Darurat'),
            Container(
              decoration: _cardDecor,
              child: Column(
                children: _contacts.asMap().entries.map((entry) {
                  final i = entry.key;
                  final c = entry.value;
                  final color = Color(c['color'] as int);
                  return Column(
                    children: [
                      if (i > 0) const Divider(height: 1, indent: 20, endIndent: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                              child: Icon(c['icon'] as IconData, size: 22, color: color),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                                  Text('No. ${c['phone']}', style: const TextStyle(fontSize: 12, color: Colors.black45)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling ${c['name']}...')));
                              },
                              child: Container(
                                width: 38, height: 38,
                                decoration: BoxDecoration(color: const Color(0xFF16A34A).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.call_rounded, size: 18, color: Color(0xFF16A34A)),
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
