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

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<GempaProvider>().startSimulation();
    });
  }

  Widget buildChart(List<double> data) {
    return SizedBox(
      height: 200,
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
              color: Colors.black,
              barWidth: 3,
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

    return Scaffold(
      backgroundColor: AppStyle.bg(context),
      appBar: AppBar(
        title: const Text('Earthquake Monitor'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔥 CHART
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppStyle.cardDecoration(context),
              child: buildChart(provider.magnitudes),
            ),

            const SizedBox(height: 20),

            Text("Magnitude: ${gempa['magnitude']}"),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {  
                      context.go('/dashboard/logs');
                    },
                    child: const Text('Logs'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<GempaProvider>().stopSimulation();
                    },
                    child: const Text('Stop'),
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}
