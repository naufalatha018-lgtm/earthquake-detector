import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_style.dart';
import '../../state/providers/settings_provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final nameController = TextEditingController(text: "Paul");
  final passController = TextEditingController();

  String role = "Admin";

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.getString('account_access')),
        leading: const BackButton(),
      ),
      backgroundColor: AppStyle.bg(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // 🔥 PROFILE
            _buildSectionTitle(settings.getString('profile')),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: settings.getString('name'),
                prefixIcon: const Icon(Icons.person_outline_rounded),
                filled: true,
                fillColor: AppStyle.card(context).color,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: settings.getString('new_password'),
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                filled: true,
                fillColor: AppStyle.card(context).color,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: AppStyle.primaryButton(context),
              child: Text(settings.getString('save_changes')),
            ),

            const SizedBox(height: 40),

            // 🔥 FAMILY USERS
            _buildSectionTitle(settings.getString('family_access')),
            const SizedBox(height: 12),
            _buildUserTile(context, "User 1", "Viewer"),
            const SizedBox(height: 8),
            _buildUserTile(context, "User 2", "Viewer"),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 0.5),
    );
  }

  Widget _buildUserTile(BuildContext context, String name, String currentRole) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: AppStyle.card(context),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(currentRole),
        trailing: DropdownButton<String>(
          value: role,
          underline: const SizedBox(),
          items: ["Admin", "Viewer"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            setState(() => role = v!);
          },
        ),
      ),
    );
  }
}
