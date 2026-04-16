import 'package:flutter/material.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  String selectedLevel = "Medium";
  bool notificationEnabled = true;

  Widget levelOption(String level, String desc) {
    return RadioListTile<String>(
      value: level,
      groupValue: selectedLevel,
      title: Text(level),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alert Parameters"),
        leading: const BackButton(),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            const Text(
              "Risk Level",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            levelOption(
              "Low",
              "Trigger if Magnitude > 5.0 within 100km",
            ),

            levelOption(
              "Medium",
              "Trigger if Magnitude > 4.5 within 200km",
            ),

            levelOption(
              "High",
              "Trigger if Magnitude > 4.0 within 300km",
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 10),

            SwitchListTile(
              title: const Text("Enable Push Notification"),
              value: notificationEnabled,
              onChanged: (value) {
                setState(() {
                  notificationEnabled = value;
                });
              },
            ),

          ],
        ),
      ),
    );
  }
}
