import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:seismo_guard/state/providers/gempa_provider.dart';
import 'package:seismo_guard/state/providers/settings_provider.dart';
import 'package:seismo_guard/core/theme/app_style.dart';

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

  Widget buildChart(List<double> data, Color primaryColor) {
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
              color: primaryColor,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: primaryColor.withOpacity(0.15),
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
    final settings = context.watch<SettingsProvider>();
    final gempa = provider.gempa;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppStyle.bg(context),
      appBar: AppBar(
        title: Text(
          settings.getString('earthquake_monitor'),
        ),
        actions: [
          IconButton(
            onPressed: () => context.go('/'),
            icon: Icon(Icons.logout_rounded, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header subtitle ──────────────────────────────
            Text(
              settings.getString('live_seismic'),
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              gempa['wilayah'] == '-' ? settings.getString('waiting_data') : gempa['wilayah']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            // ── Chart Card ───────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primaryContainer, theme.colorScheme.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    settings.getString('mag_chart'),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withOpacity(0.7),
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'M ${gempa['magnitude']}',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildChart(provider.magnitudes, theme.colorScheme.onPrimary),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Info Cards ───────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.calendar_today_rounded,
                    label: settings.getString('date'),
                    value: gempa['tanggal'] ?? '-',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.access_time_rounded,
                    label: settings.getString('time'),
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
                    label: settings.getString('magnitude'),
                    value: gempa['magnitude'] ?? '-',
                    highlight: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.layers_rounded,
                    label: settings.getString('depth'),
                    value: gempa['kedalaman'] ?? '-',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Helper Widget ────────────────────────────────────────────────────────────
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight 
            ? theme.colorScheme.primary
            : (isDark ? theme.colorScheme.surfaceVariant : Colors.white),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: highlight 
                ? theme.colorScheme.onPrimary.withOpacity(0.8) 
                : theme.colorScheme.primary.withOpacity(0.6),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: highlight 
                  ? theme.colorScheme.onPrimary.withOpacity(0.7) 
                  : theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: highlight ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
