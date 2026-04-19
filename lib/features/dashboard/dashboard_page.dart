import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../state/providers/gempa_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_style.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {

  // Clocks
  String _currentTime = '';
  Timer? _clockTimer;

  // Fade-in
  double _opacity = 0;

  // Pulse animation for danger mode
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  // Screen shake
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;
  bool _wasInDanger = false;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _shakeAnim = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn),
    );

    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (mounted) {
        setState(() {
          _currentTime = '${_pad(now.hour)}:${_pad(now.minute)}:${_pad(now.second)}';
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _opacity = 1);
    });
  }

  String _pad(int v) => v.toString().padLeft(2, '0');

  @override
  void dispose() {
    _clockTimer?.cancel();
    _pulseCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  void _triggerShake() {
    HapticFeedback.heavyImpact();
    _shakeCtrl.forward(from: 0).then((_) => _shakeCtrl.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GempaProvider>();
    final mag = double.tryParse(p.gempa['magnitude'] ?? '0') ?? 0;
    final isDanger = mag >= 5.0;

    // Trigger shake on danger state change
    if (isDanger && !_wasInDanger) {
      _wasInDanger = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _triggerShake());
    } else if (!isDanger) {
      _wasInDanger = false;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      decoration: BoxDecoration(
        gradient: isDanger ? AppColors.dangerGradient : AppColors.backgroundGradient,
      ),
      child: AnimatedBuilder(
        animation: _shakeAnim,
        builder: (_, child) => Transform.translate(
          offset: _shakeCtrl.isAnimating
            ? Offset(sin(_shakeAnim.value * pi) * 6, 0)
            : Offset.zero,
          child: child,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: _opacity,
              child: Column(
                children: [
                  _buildTopBar(context, isDanger),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        children: [
                          _buildStatusHero(p, isDanger, mag),
                          const SizedBox(height: 20),
                          _buildDataGrid(p),
                          const SizedBox(height: 20),
                          _buildMagnitudeChart(p.magnitudes),
                          const SizedBox(height: 20),
                          _buildActions(context, isDanger),
                          const SizedBox(height: 16),
                          _buildNavRow(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDanger) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
      child: Row(
        children: [
          // Logo + title
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.shield_rounded, size: 18, color: AppColors.safe),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'SeismoGuard',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'QuakeAlert One',
                style: TextStyle(fontSize: 10, color: AppColors.textMuted, letterSpacing: 1),
              ),
            ],
          ),
          const Spacer(),
          // Clock
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: AppStyle.card(radius: 10),
            child: Text(
              _currentTime,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: () => context.go('/login'),
            icon: const Icon(Icons.logout_rounded, size: 20, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHero(GempaProvider p, bool isDanger, double mag) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: isDanger ? AppColors.dangerGradient : AppColors.safeGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: (isDanger ? AppColors.danger : AppColors.safe)
                    .withOpacity(isDanger ? _pulseAnim.value * 0.5 : 0.25),
                blurRadius: isDanger ? 40 : 20,
                spreadRadius: isDanger ? 4 : 2,
              ),
            ],
            border: Border.all(
              color: (isDanger ? AppColors.dangerLight : AppColors.safeLight)
                  .withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDanger ? AppColors.dangerLight : AppColors.safeLight,
                        boxShadow: [
                          BoxShadow(
                            color: (isDanger ? AppColors.dangerLight : AppColors.safeLight)
                                .withOpacity(_pulseAnim.value),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isDanger ? 'BAHAYA' : 'AMAN',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Magnitude
              Text(
                mag.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 0.9,
                  shadows: isDanger
                    ? [Shadow(color: AppColors.dangerLight.withOpacity(0.5), blurRadius: 20)]
                    : [],
                ),
              ),
              const Text(
                'MAGNITUDE',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white60,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Location
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on_rounded, size: 14, color: Colors.white60),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      p.gempa['wilayah'] ?? '-',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataGrid(GempaProvider p) {
    return Row(
      children: [
        Expanded(child: _dataCard('DATE', p.gempa['tanggal'] ?? '-', Icons.calendar_today_rounded)),
        const SizedBox(width: 12),
        Expanded(child: _dataCard('TIME', p.gempa['jam'] ?? '-', Icons.access_time_rounded)),
      ],
    );
  }

  Widget _dataCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppStyle.glassCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(label, style: AppStyle.label),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMagnitudeChart(List<double> data) {
    final safeData = data.isEmpty ? [1.0, 2.0, 3.0] : data;
    final maxVal = safeData.reduce(max);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppStyle.glassCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Magnitude History', style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.safe.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w700,
                    color: AppColors.safe, letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: safeData.asMap().entries.map((entry) {
                final val = entry.value;
                final isLast = entry.key == safeData.length - 1;
                final barH = maxVal > 0 ? (val / maxVal * 60).clamp(8.0, 60.0) : 8.0;
                final color = val >= 5.0 ? AppColors.danger
                    : val >= 4.0 ? AppColors.warning
                    : AppColors.safe;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isLast)
                          Text(
                            val.toStringAsFixed(1),
                            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
                          ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: barH,
                          decoration: BoxDecoration(
                            color: isLast ? color : color.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, bool isDanger) {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            label: 'Trigger Siren',
            icon: Icons.campaign_rounded,
            color: AppColors.danger,
            onTap: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(children: const [
                    Icon(Icons.campaign_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Siren Activated 🔊'),
                  ]),
                  backgroundColor: AppColors.danger,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionButton(
            label: 'Device Status',
            icon: Icons.sensors_rounded,
            color: AppColors.safe,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _navButton(
            context,
            label: 'View Logs',
            icon: Icons.list_alt_rounded,
            route: '/logs',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _navButton(
            context,
            label: 'Settings',
            icon: Icons.settings_rounded,
            route: '/settings',
          ),
        ),
      ],
    );
  }

  Widget _navButton(BuildContext context, {
    required String label,
    required IconData icon,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: AppStyle.card(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
