import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_style.dart';
import '../../state/providers/settings_provider.dart';

class HardwarePage extends StatefulWidget {
  const HardwarePage({super.key});

  @override
  State<HardwarePage> createState() => _HardwarePageState();
}

class _HardwarePageState extends State<HardwarePage> {
  bool isOnline = true;
  double rssi = 70; // dummy signal %

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.getString('hardware_diag')),
        leading: const BackButton(),
      ),
      backgroundColor: AppStyle.bg(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // 🔥 DEVICE STATUS
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppStyle.card(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Device Status",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isOnline ? "ONLINE" : "OFFLINE",
                      style: TextStyle(
                        color: isOnline ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔥 RSSI
            const Text(
              "Signal Strength (RSSI)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: rssi / 100,
                minHeight: 12,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            ),

            const SizedBox(height: 32),

            // 🔥 ACTION BUTTONS
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Siren Activated 🔊")),
                );
              },
              icon: const Icon(Icons.volume_up_rounded),
              label: const Text("Simulate Siren"),
              style: AppStyle.primaryButton(context),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Checking Update...")),
                );
              },
              icon: const Icon(Icons.system_update_rounded),
              label: const Text("Check Update (OTA)"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 32),

            // 🔥 DELETE DEVICE
            TextButton(
              style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Unbind Device"),
                    content: const Text("Are you sure? This action cannot be undone."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Device Removed")),
                          );
                        },
                        child: Text("Unbind", style: TextStyle(color: theme.colorScheme.error)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Unbind Device"),
            ),
          ],
        ),
      ),
    );
  }
}
