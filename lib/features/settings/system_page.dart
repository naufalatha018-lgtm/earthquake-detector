// UPDATED UI - PREMIUM STYLE
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/providers/app_settings_provider.dart';

class SystemPage extends StatefulWidget {
  const SystemPage({super.key});

  @override
  State<SystemPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> {

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

  Widget _dropdownRow<T>({
    required IconData icon,
    required String label,
    required String desc,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      decoration: _cardDecor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: _dark.withOpacity(0.07), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: _dark),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<T>(
              value: value,
              underline: const SizedBox(),
              isDense: true,
              style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
              borderRadius: BorderRadius.circular(12),
              items: items.map((e) {
                String text;

                if (e is ThemeMode) {
                  switch (e) {
                    case ThemeMode.light:
                      text = "Light";
                      break;
                    case ThemeMode.dark:
                      text = "Dark";
                      break;
                    case ThemeMode.system:
                      text = "System";
                      break;
                }
              } else if (e is Locale) {
                text = e.languageCode == 'id' ? "Indonesia" : "English";
              } else {
                text = e.toString();
              }

              return DropdownMenuItem(
                value: e,
                child: Text(text),
              );
            }).toList(),

              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text('System Preferences', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── App Info Banner ───────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_dark, Color(0xFF2E2E4E)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: _dark.withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 6))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.sensors_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('GempaBumi Monitor', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                      Text('v1.0.0 • IoT Seismic System', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Appearance ────────────────────────────────────
            _sectionLabel('Tampilan'),
            _dropdownRow<ThemeMode>(
              icon: Icons.palette_outlined,
              label: 'Theme',
              desc: 'Pilih tampilan aplikasi',
              value: settings.themeMode,
              items: const [
                ThemeMode.light,
                ThemeMode.dark,
                ThemeMode.system,
              ],
              onChanged: (v) {
                if (v != null) {
                  settings.setThemeMode(v);
                }
              },
            ),

            const SizedBox(height: 24),

            // ── Language ──────────────────────────────────────
            _sectionLabel('Bahasa'),
            _dropdownRow<Locale>(
              icon: Icons.language_rounded,
              label: 'Language',
              desc: 'Pilih bahasa aplikasi',
              value: settings.locale,
              items: const [
                Locale('en'),
                Locale('id'),
              ],
              onChanged: (v) {
                if (v != null) {
                  settings.setLocale(v);
                }
              },
            ),
            const SizedBox(height: 24),

            // ── App Info ──────────────────────────────────────
            _sectionLabel('Informasi Aplikasi'),
            Container(
              decoration: _cardDecor,
              child: Column(
                children: [
                  _InfoRow(icon: Icons.info_outline_rounded, label: 'Versi Aplikasi', value: '1.0.0'),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _InfoRow(icon: Icons.build_outlined, label: 'Build Number', value: '2026041701'),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _InfoRow(icon: Icons.storage_rounded, label: 'Platform', value: 'Flutter Web'),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black38),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87))),
          Text(value, style: const TextStyle(fontSize: 13, color: Colors.black45, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
