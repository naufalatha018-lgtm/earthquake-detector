import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../state/providers/gempa_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String currentTime = "";
  double opacity = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // 🔥 REALTIME CLOCK (FIXED)
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (!mounted) return;
      setState(() {
        currentTime =
            "${now.hour.toString().padLeft(2, '0')}:"
            "${now.minute.toString().padLeft(2, '0')}:"
            "${now.second.toString().padLeft(2, '0')}";
      });
    });

    // 🔥 ANIMASI MASUK
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        opacity = 1;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // 🔥 PENTING: cegah memory leak
    super.dispose();
  }

  Widget card(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget graph(List<double> data) {
    final safeData = data.isEmpty ? [1, 2, 3, 2, 1] : data;

    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: safeData.map((e) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height:(e * 15).clamp(10, 100).toDouble(),
              color: Colors.black,
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GempaProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
  context.go('/login');
},
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: opacity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🔥 CLOCK
                Text(
                  "⏱ $currentTime",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 DEVICE STATUS
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Device Status"),
                      Text(
                        "ONLINE",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔥 GRAPH
                graph(p.magnitudes),

                // 🔥 DATA GEMPA
                card("Tanggal", p.gempa["tanggal"] ?? "-"),
                card("Jam", p.gempa["jam"] ?? "-"),
                card("Magnitude", p.gempa["magnitude"] ?? "-"),
                card("Kedalaman", p.gempa["kedalaman"] ?? "-"),
                card("Wilayah", p.gempa["wilayah"] ?? "-"),

                const SizedBox(height: 16),

                // 🔥 SIREN BUTTON
                Consumer<GempaProvider>(
                  builder: (context, gempa, child) {
                    final isActive = gempa.isSirenActive;
                    return ElevatedButton.icon(
                      onPressed: () {
                        gempa.setManualSiren(!isActive);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isActive ? "Siren Deactivated 🔇" : "Siren Triggered 🔊"),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: Icon(isActive ? Icons.volume_off_rounded : Icons.volume_up_rounded),
                      label: Text(isActive ? "Stop Siren" : "Trigger Siren"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isActive ? Colors.red : Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // 🔥 NAVIGATION BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.push('/logs'),
                        child: const Text("Logs"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.push('/settings'),
                        child: const Text("Settings"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}