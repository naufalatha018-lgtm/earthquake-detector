import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../providers/earthquake_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/neu_card.dart';
import '../widgets/neu_button.dart';
import '../widgets/status_badge.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    final provider = context.watch<EarthquakeProvider>();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Akun',
                          style: GoogleFonts.inter(
                            color: textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Profil & perangkat',
                          style: GoogleFonts.inter(
                            color: textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    StatusBadge(status: provider.connection),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Profile card
                  _ProfileCard(isDark: isDark),
                  const SizedBox(height: AppSpacing.lg),

                  // Device node info
                  _DeviceCard(isDark: isDark),
                  const SizedBox(height: AppSpacing.lg),

                  // Session stats
                  _SessionStatsCard(isDark: isDark),
                  const SizedBox(height: AppSpacing.lg),

                  // System info
                  _SystemCard(isDark: isDark),
                  const SizedBox(height: AppSpacing.xl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Profile Card ─────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return NeuCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.safe],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: isDark
                  ? AppColors.elevatedDark(blur: 16, offset: 6)
                  : AppColors.elevatedLight(blur: 16, offset: 6),
            ),
            child: const Center(
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            'Demo Operator',
            style: GoogleFonts.inter(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'operator@bhukampa.tech',
            style: GoogleFonts.inter(
              color: textSecondary,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  size: 12,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  'Operator Lapangan',
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Device Card ──────────────────────────────────────────────

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(label: 'Perangkat IoT', isDark: isDark),
        const SizedBox(height: AppSpacing.sm),
        NeuCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              _DeviceNodeRow(
                icon: Icons.hub_rounded,
                label: 'Node Data Gempa',
                value: '/demo_environment/earthquake_data',
                color: AppColors.primary,
                isDark: isDark,
                mono: true,
              ),
              const SizedBox(height: AppSpacing.md),
              _DeviceNodeRow(
                icon: Icons.campaign_rounded,
                label: 'Node Kontrol Sirine',
                value: '/demo_device_control/siren_active',
                color: AppColors.danger,
                isDark: isDark,
                mono: true,
              ),
              const SizedBox(height: AppSpacing.md),
              _DeviceNodeRow(
                icon: Icons.update_rounded,
                label: 'Interval Polling',
                value: '3 detik',
                color: AppColors.safe,
                isDark: isDark,
                mono: false,
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                    color: AppColors.warning.withOpacity(0.25),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.science_rounded,
                      size: 14,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Mode Simulasi Aktif — Data tidak real',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeviceNodeRow extends StatelessWidget {
  const _DeviceNodeRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
    required this.mono,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(icon, color: color, size: AppSpacing.iconSm),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: mono
                    ? GoogleFonts.sourceCodePro(
                        color: textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      )
                    : TextStyle(
                        color: textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Session Stats Card ───────────────────────────────────────

class _SessionStatsCard extends StatelessWidget {
  const _SessionStatsCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EarthquakeProvider>();
    final historyLen = provider.magnitudeHistory.length;
    final maxMag = historyLen > 0
        ? provider.magnitudeHistory.reduce((a, b) => a > b ? a : b)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(label: 'Statistik Sesi', isDark: isDark),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: NeuCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: _StatTile(
                  label: 'Pembacaan',
                  value: '$historyLen',
                  unit: 'data',
                  color: AppColors.primary,
                  isDark: isDark,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: NeuCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: _StatTile(
                  label: 'Mag Tertinggi',
                  value: maxMag.toStringAsFixed(1),
                  unit: 'SR',
                  color: AppColors.danger,
                  isDark: isDark,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: NeuCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: _StatTile(
                  label: 'Status',
                  value: provider.sirenActive ? 'ON' : 'OFF',
                  unit: 'sirine',
                  color: provider.sirenActive ? AppColors.danger : AppColors.safe,
                  isDark: isDark,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.isDark,
  });
  final String label;
  final String value;
  final String unit;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: GoogleFonts.inter(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            height: 1,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ── System Info ──────────────────────────────────────────────

class _SystemCard extends StatelessWidget {
  const _SystemCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(label: 'Sistem', isDark: isDark),
        const SizedBox(height: AppSpacing.sm),
        NeuCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _InfoRow(
                icon: Icons.memory_rounded,
                label: 'Engine Risiko',
                value: 'Lokal (No Network)',
                color: AppColors.safe,
                isDark: isDark,
              ),
              _Divider(isDark: isDark),
              _InfoRow(
                icon: Icons.storage_rounded,
                label: 'Penyimpanan',
                value: 'SharedPreferences',
                color: AppColors.primary,
                isDark: isDark,
              ),
              _Divider(isDark: isDark),
              _InfoRow(
                icon: Icons.security_rounded,
                label: 'Autentikasi',
                value: 'Tidak diperlukan',
                color: AppColors.warning,
                isDark: isDark,
              ),
              _Divider(isDark: isDark),
              _InfoRow(
                icon: Icons.design_services_rounded,
                label: 'Desain',
                value: 'Neumorphism v1.0',
                color: AppColors.primary,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.isDark});
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Divider(
        height: 1,
        thickness: 1,
        color: (isDark ? AppColors.textTertiaryDark : AppColors.textTertiary)
            .withOpacity(0.15),
      ),
    );
  }
}
