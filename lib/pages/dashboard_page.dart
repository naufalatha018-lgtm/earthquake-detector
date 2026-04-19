import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../providers/earthquake_provider.dart';
import '../utils/risk_engine.dart';
import '../widgets/neu_card.dart';
import '../widgets/neu_button.dart';
import '../widgets/status_badge.dart';
import '../widgets/risk_indicator.dart';
import '../widgets/seismic_chart.dart';
import '../widgets/metric_card.dart';
import '../widgets/siren_control_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DashboardView();
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView>
    with TickerProviderStateMixin {
  late final AnimationController _dangerBannerCtrl;
  late final Animation<double> _dangerBannerAnim;
  bool _prevTrigger = false;

  @override
  void initState() {
    super.initState();
    _dangerBannerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _dangerBannerAnim = CurvedAnimation(
      parent: _dangerBannerCtrl,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _dangerBannerCtrl.dispose();
    super.dispose();
  }

  void _syncDangerBanner(bool trigger) {
    if (trigger && !_prevTrigger) {
      _dangerBannerCtrl.forward();
      HapticFeedback.heavyImpact();
    } else if (!trigger && _prevTrigger) {
      _dangerBannerCtrl.reverse();
    }
    _prevTrigger = trigger;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EarthquakeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    final data = provider.data;
    final risk = provider.risk;
    final trigger = data.statusTrigger;

    _syncDangerBanner(trigger);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  0,
                ),
                child: _buildHeader(
                  context,
                  provider,
                  isDark,
                  textPrimary,
                  textSecondary,
                ),
              ),
            ),

            // Danger Banner
            SliverToBoxAdapter(
              child: SizeTransition(
                sizeFactor: _dangerBannerAnim,
                child: FadeTransition(
                  opacity: _dangerBannerAnim,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      0,
                    ),
                    child: _DangerBanner(isDark: isDark),
                  ),
                ),
              ),
            ),

            // Body
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _DemoModeBadge(isDark: isDark),
                  const SizedBox(height: AppSpacing.md),

                  RiskIndicatorCard(result: risk),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: MetricCard(
                          label: 'MAGNITUDO',
                          value: data.magnitude.toStringAsFixed(1),
                          unit: 'SR',
                          icon: Icons.show_chart_rounded,
                          accentColor: _magnitudeColor(data.magnitude),
                          sublabel: _magnitudeLabel(data.magnitude),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: MetricCard(
                          label: 'JARAK',
                          value: data.distanceKm.toStringAsFixed(0),
                          unit: 'km',
                          icon: Icons.location_on_rounded,
                          accentColor: _distanceColor(data.distanceKm),
                          sublabel: _distanceLabel(data.distanceKm),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  SeismicChartCard(history: provider.magnitudeHistory),
                  const SizedBox(height: AppSpacing.md),

                  SirenControlCard(),
                  const SizedBox(height: AppSpacing.md),

                  _DemoControls(isDark: isDark),
                  const SizedBox(height: AppSpacing.md),

                  Center(
                    child: Text(
                      'Diperbarui: ${provider.lastUpdatedLabel}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: textSecondary.withOpacity(0.6),
                          ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    EarthquakeProvider provider,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo icon
        NeuCard(
          padding: const EdgeInsets.all(AppSpacing.sm),
          radius: AppSpacing.radiusMd,
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.primary, AppColors.safe],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: const Icon(
              Icons.sensors_rounded,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(width: AppSpacing.md),

        // Title block
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seismo Guard',
                style: GoogleFonts.inter(
                  color: textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Monitoring Gempa Realtime',
                style: GoogleFonts.inter(
                  color: textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        StatusBadge(status: provider.connection),
      ],
    );
  }

  Color _magnitudeColor(double mag) {
    if (mag < 3.0) return AppColors.safe;
    if (mag < 5.0) return AppColors.warning;
    return AppColors.danger;
  }

  String _magnitudeLabel(double mag) {
    if (mag < 2.0) return 'Mikro';
    if (mag < 3.0) return 'Minor';
    if (mag < 4.0) return 'Ringan';
    if (mag < 5.0) return 'Sedang';
    if (mag < 6.0) return 'Kuat';
    if (mag < 7.0) return 'Besar';
    return 'Ekstrem';
  }

  Color _distanceColor(double dist) {
    if (dist < 20) return AppColors.danger;
    if (dist < 60) return AppColors.warning;
    return AppColors.safe;
  }

  String _distanceLabel(double dist) {
    if (dist < 20) return 'Sangat dekat';
    if (dist < 60) return 'Dekat';
    if (dist < 150) return 'Menengah';
    return 'Jauh';
  }
}

// ── Sub-widgets ──────────────────────────────────────────────

class _DemoModeBadge extends StatelessWidget {
  const _DemoModeBadge({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      pressed: true,
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.warning,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'DEMO MODE — Data disimulasikan dari Firebase RTDB',
              style: const TextStyle(
                color: AppColors.warning,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }
}

class _DangerBanner extends StatefulWidget {
  const _DangerBanner({required this.isDark});
  final bool isDark;

  @override
  State<_DangerBanner> createState() => _DangerBannerState();
}

class _DangerBannerState extends State<_DangerBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.dangerBgDark : AppColors.dangerBg,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: AppColors.danger.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.danger.withOpacity(_glowAnim.value * 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: AppColors.danger,
                size: AppSpacing.iconLg,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PERINGATAN GEMPA AKTIF',
                      style: GoogleFonts.inter(
                        color: AppColors.danger,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Segera cari perlindungan. Hindari area terbuka.',
                      style: GoogleFonts.inter(
                        color: AppColors.dangerSoft,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DemoControls extends StatelessWidget {
  const _DemoControls({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<EarthquakeProvider>();
    return NeuCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.science_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Demo Controls',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: NeuButton(
                  label: 'Simulasi Bahaya',
                  icon: Icons.dangerous_rounded,
                  variant: NeuButtonVariant.danger,
                  compact: true,
                  expanded: true,
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    provider.simulateDangerEvent();
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: NeuButton(
                  label: 'Reset Aman',
                  icon: Icons.shield_rounded,
                  variant: NeuButtonVariant.outline,
                  compact: true,
                  expanded: true,
                  color: AppColors.safe,
                  onPressed: () {
                    provider.simulateCalmState();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
