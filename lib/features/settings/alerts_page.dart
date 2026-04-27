import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_style.dart';
import '../../state/providers/settings_provider.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  String selectedLevel = "Medium";
  bool notificationEnabled = true;

  Widget levelOption(BuildContext context, String level, String desc) {
    return RadioListTile<String>(
      value: level,
      groupValue: selectedLevel,
      title: Text(level, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(desc),
      onChanged: (value) {
        setState(() {
          selectedLevel = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.getString('alert_params')),
        leading: const BackButton(),
      ),
      backgroundColor: AppStyle.bg(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Risk Level Sensitivity",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: AppStyle.card(context),
              child: Column(
                children: [
                  levelOption(context, "Low", "Trigger if Magnitude > 5.0 within 100km"),
                  const Divider(height: 1),
                  levelOption(context, "Medium", "Trigger if Magnitude > 4.5 within 200km"),
                  const Divider(height: 1),
                  levelOption(context, "High", "Trigger if Magnitude > 4.0 within 300km"),
                ],
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              "Notifications",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: AppStyle.card(context),
              child: SwitchListTile(
                title: const Text("Push Notifications", style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text("Receive alerts on your device"),
                value: notificationEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationEnabled = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
