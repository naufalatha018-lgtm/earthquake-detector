// UPDATED UI - PREMIUM STYLE
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final nameController = TextEditingController(text: "Paul");
  final passController = TextEditingController();

  String role = "Admin";

  static const _bg = Color(0xFFF8FAFC);
  static const _dark = Color(0xFF1C1C2E);
  static const _accent = Color(0xFF6366F1);

  BoxDecoration get _cardDecor => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
      );

  InputDecoration _inputDecor(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: Colors.black38),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _accent, width: 1.5)),
        labelStyle: const TextStyle(color: Colors.black45, fontSize: 13),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text('Account & Access', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Avatar ───────────────────────────────────────
            Center(
              child: Column(
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [_dark, Color(0xFF2E2E4E)]),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: _dark.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 10),
                  const Text('Paul', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87)),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(color: _dark.withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
                    child: const Text('Admin', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _dark)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Profile Section ──────────────────────────────
            _sectionLabel('Profile'),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDecor,
              child: Column(
                children: [
                  TextField(controller: nameController, decoration: _inputDecor('Name', Icons.person_outline_rounded)),
                  const SizedBox(height: 14),
                  TextField(controller: passController, obscureText: true, decoration: _inputDecor('New Password', Icons.lock_outline_rounded)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _dark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Family Access Section ─────────────────────────
            _sectionLabel('Family Access'),
            Container(
              decoration: _cardDecor,
              child: Column(
                children: [
                  _UserTile(name: 'User 1', subtitle: 'Viewer', role: role, onChanged: (v) => setState(() => role = v!)),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _UserTile(name: 'User 2', subtitle: 'Viewer', role: role, onChanged: (v) => setState(() => role = v!)),
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

class _UserTile extends StatelessWidget {
  final String name, subtitle, role;
  final ValueChanged<String?> onChanged;
  const _UserTile({required this.name, required this.subtitle, required this.role, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: const Color(0xFFF0F0F5), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.person_outline_rounded, size: 20, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black45)),
              ],
            ),
          ),
          DropdownButton<String>(
            value: role,
            underline: const SizedBox(),
            style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
            borderRadius: BorderRadius.circular(12),
            items: ['Admin', 'Viewer'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
