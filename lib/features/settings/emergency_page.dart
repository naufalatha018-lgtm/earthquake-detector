import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_style.dart';
import '../../state/providers/settings_provider.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final locationController = TextEditingController();

  Widget contact(BuildContext context, String name, String phone) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: AppStyle.card(context),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(phone),
        trailing: IconButton(
          icon: Icon(Icons.call, color: theme.colorScheme.primary),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Calling $name...")),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.getString('emergency_proto')),
        leading: const BackButton(),
      ),
      backgroundColor: AppStyle.bg(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // 🔥 EVACUATION POINT
            const Text(
              "Evacuation Point",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: "Enter meeting point location",
                filled: true,
                fillColor: AppStyle.card(context).color,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Location Saved")),
                );
              },
              style: AppStyle.primaryButton(context),
              child: const Text("Save Location"),
            ),

            const SizedBox(height: 40),

            // 🔥 CONTACTS
            const Text(
              "Emergency Contacts",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 12),
            contact(context, "BNPB", "129"),
            contact(context, "Medical Emergency", "118"),
            contact(context, "Police", "110"),
          ],
        ),
      ),
    );
  }
}
