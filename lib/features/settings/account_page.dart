import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_style.dart';
import '../../presentation/widgets/seismo_app_bar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _nameCtrl = TextEditingController(text: 'Paul');
  final _passCtrl = TextEditingController();
  String _role = 'Admin';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _passCtrl.dispose();
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
              SeismoAppBar(title: 'Account & Access'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Avatar
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, AppColors.safe],
                              ),
                            ),
                            child: const Center(
                              child: Text('P', style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white,
                              )),
                            ),
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              width: 26, height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.safe,
                                border: Border.all(color: AppColors.background, width: 2),
                              ),
                              child: const Icon(Icons.edit_rounded, size: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    _sectionLabel('PROFILE'),
                    const SizedBox(height: 12),
                    Container(
                      decoration: AppStyle.glassCard(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _labeledField('Full Name', _nameCtrl, Icons.person_outline_rounded),
                          const SizedBox(height: 16),
                          _labeledField('New Password', _passCtrl, Icons.lock_outline_rounded, obscure: true),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Changes saved')),
                                );
                              },
                              style: AppStyle.primaryButton,
                              child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    _sectionLabel('FAMILY ACCESS'),
                    const SizedBox(height: 12),
                    Container(
                      decoration: AppStyle.glassCard(),
                      child: Column(
                        children: [
                          _userTile('User 1', 'member@email.com'),
                          const Divider(height: 1, color: AppColors.border),
                          _userTile('User 2', 'member2@email.com'),
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

  Widget _userTile(String name, String email) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.safe.withOpacity(0.1),
            ),
            child: Center(
              child: Text(name[0], style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.safe,
              )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(email, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          DropdownButton<String>(
            value: _role,
            dropdownColor: AppColors.surfaceElevated,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            underline: const SizedBox(),
            items: ['Admin', 'Viewer'].map((e) =>
              DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => _role = v!),
          ),
        ],
      ),
    );
  }

  Widget _labeledField(String label, TextEditingController ctrl, IconData icon, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyle.label),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text, style: AppStyle.label);
  }
}
