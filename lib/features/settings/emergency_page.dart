import 'package:flutter/material.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final locationController = TextEditingController();

  Widget contact(String name, String phone) {
    return ListTile(
      title: Text(name),
      subtitle: Text(phone),
      trailing: IconButton(
        icon: const Icon(Icons.call, color: Colors.green),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Calling $name...")),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Protocol"),
        leading: const BackButton(),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            // 🔥 EVACUATION POINT
            const Text(
              "Evacuation Point",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                hintText: "Enter meeting point location",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Location Saved")),
                );
              },
              child: const Text("Save Location"),
            ),

            const SizedBox(height: 30),

            // 🔥 CONTACTS
            const Text(
              "Emergency Contacts",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            contact("BNPB", "129"),
            contact("Medical Emergency", "118"),
            contact("Police", "110"),

          ],
        ),
      ),
    );
  }
}
