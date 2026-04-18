import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

import 'package:gempa_bumi/state/providers/gempa_provider.dart';
import 'package:gempa_bumi/core/theme/app_style.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  Widget buildChart(List<double> data) {
    return SizedBox(
      height: 160,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: data
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              dotData: FlDotData(show: false),
              color: const Color(0xFF7EB8FF),
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF7EB8FF).withOpacity(0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GempaProvider>();
    final gempa = provider.gempa;

    // 🔥 DETEKSI BAHAYA - HANYA GUNAKAN status_trigger (SINGLE SOURCE OF TRUTH)
    final isBahaya = provider.statusTrigger;

    return Scaffold(
      // 🔴 BACKGROUND DINAMIS
      backgroundColor: isBahaya ? Colors.red.shade100 : AppStyle.bg(context),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isBahaya ? '⚠️ BAHAYA GEMPA' : 'Earthquake Monitor',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: isBahaya ? Colors.red : Colors.black87,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 100,
              ),
            ),

            const SizedBox(height: 16),


            const Text(
              'Live Seismic Activity',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black45,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),

            Text(
              gempa['wilayah'] == '-' ? 'Menunggu data...' : gempa['wilayah']!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isBahaya ? Colors.red : Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 CARD JADI MERAH SAAT BAHAYA
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isBahaya
                      ? [Colors.red.shade700, Colors.red.shade400]
                      : [const Color(0xFF1C1C2E), const Color(0xFF2E2E4E)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MAGNITUDE CHART',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'M ${gempa['magnitude']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildChart(provider.magnitudes),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.calendar_today_rounded,
                    label: 'Tanggal',
                    value: gempa['tanggal'] ?? '-',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.access_time_rounded,
                    label: 'Jam',
                    value: gempa['jam'] ?? '-',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.waves_rounded,
                    label: 'Magnitude',
                    value: gempa['magnitude'] ?? '-',
                    highlight: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.layers_rounded,
                    label: 'Kedalaman',
                    value: gempa['kedalaman'] ?? '-',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 🚨 TOMBOL HENTIKAN SIRENE (SUPABASE VERSION)
            if (isBahaya)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // 🟢 PANGGIL METHOD DARI PROVIDER (SUPABASE)
                    await provider.stopSiren();

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sirene dimatikan")),
                      );
                    }
                  },
                  icon: const Icon(Icons.volume_off),
                  label: const Text("Hentikan Sirene"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.go('/dashboard/logs');
                },
                icon: const Icon(Icons.list_alt_rounded, size: 18),
                label: const Text('Logs'),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// INFO CARD (TIDAK DIUBAH)
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFF1C1C2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: highlight ? Colors.white60 : Colors.black38,
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: highlight ? Colors.white54 : Colors.black45,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: highlight ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}