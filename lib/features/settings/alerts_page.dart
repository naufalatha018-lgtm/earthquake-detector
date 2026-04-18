import 'package:flutter/material.dart';

// ⚠️ CATATAN PENTING:
// Halaman ini TIDAK DIGUNAKAN dalam logic aplikasi (DEMO MODE)
// Firebase status_trigger adalah SINGLE SOURCE OF TRUTH
// UI ini hanya untuk tampilan saja, tidak mempengaruhi alarm atau deteksi

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

            // ⚠️ INFO BANNER
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber.shade900),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "DEMO MODE: Pengaturan ini tidak aktif. Sistem menggunakan Firebase status_trigger.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

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