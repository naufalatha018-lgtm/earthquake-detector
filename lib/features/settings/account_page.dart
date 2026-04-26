import 'package:flutter/material.dart';
import '../../core/theme/app_style.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account & Access", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
        leading: const BackButton(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: AppStyle.bg(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            // 🔥 PROFILE
            const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Save Changes"),
            ),

            const SizedBox(height: 30),

            // 🔥 FAMILY USERS
            const Text("Family Access", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            ListTile(
              title: const Text("User 1"),
              subtitle: const Text("Viewer"),
              trailing: DropdownButton<String>(
                value: role,
                items: ["Admin", "Viewer"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() => role = v!);
                },
              ),
            ),

            ListTile(
              title: const Text("User 2"),
              subtitle: const Text("Viewer"),
              trailing: DropdownButton<String>(
                value: role,
                items: ["Admin", "Viewer"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() => role = v!);
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
