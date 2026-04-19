import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../providers/theme_provider.dart';
import '../providers/earthquake_provider.dart';
import '../widgets/neu_card.dart';
import '../widgets/neu_button.dart';

// ── Preferences keys ─────────────────────────────────────────
class _Prefs {
  static const alertSound         = 'pref_alert_sound';
  static const vibration          = 'pref_vibration';
  static const sirenAuto          = 'pref_siren_auto';
  static const pushAndroid        = 'pref_push_android';
  static const pushIos            = 'pref_push_ios';
  static const pushDangerOnly     = 'pref_push_danger_only';
  static const alertProfile       = 'pref_alert_profile';  // low/medium/high/custom
  static const customMagnitude    = 'pref_custom_magnitude';
  static const customRadius       = 'pref_custom_radius';
}

// ── Settings Provider (local, SharedPreferences) ─────────────
class AlertSettingsProvider extends ChangeNotifier {
  bool alertSound      = true;
  bool vibration       = true;
  bool sirenAuto       = true;
  bool pushAndroid     = true;
  bool pushIos         = true;
  bool pushDangerOnly  = false;
  String alertProfile  = 'high';
  double customMag     = 4.0;
  double customRadius  = 50.0;

  bool _loaded = false;
  bool get loaded => _loaded;

  AlertSettingsProvider() { _load(); }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    alertSound     = p.getBool(_Prefs.alertSound)     ?? true;
    vibration      = p.getBool(_Prefs.vibration)      ?? true;
    sirenAuto      = p.getBool(_Prefs.sirenAuto)       ?? true;
    pushAndroid    = p.getBool(_Prefs.pushAndroid)     ?? true;
    pushIos        = p.getBool(_Prefs.pushIos)         ?? true;
    pushDangerOnly = p.getBool(_Prefs.pushDangerOnly)  ?? false;
    alertProfile   = p.getString(_Prefs.alertProfile)  ?? 'high';
    customMag      = p.getDouble(_Prefs.customMagnitude) ?? 4.0;
    customRadius   = p.getDouble(_Prefs.customRadius)   ?? 50.0;
    _loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_Prefs.alertSound,      alertSound);
    await p.setBool(_Prefs.vibration,       vibration);
    await p.setBool(_Prefs.sirenAuto,        sirenAuto);
    await p.setBool(_Prefs.pushAndroid,      pushAndroid);
    await p.setBool(_Prefs.pushIos,          pushIos);
    await p.setBool(_Prefs.pushDangerOnly,   pushDangerOnly);
    await p.setString(_Prefs.alertProfile,   alertProfile);
    await p.setDouble(_Prefs.customMagnitude, customMag);
    await p.setDouble(_Prefs.customRadius,    customRadius);
  }

  void setBool(String key, bool v) {
    switch (key) {
      case _Prefs.alertSound:      alertSound     = v; break;
      case _Prefs.vibration:       vibration      = v; break;
      case _Prefs.sirenAuto:        sirenAuto      = v; break;
      case _Prefs.pushAndroid:      pushAndroid    = v; break;
      case _Prefs.pushIos:          pushIos        = v; break;
      case _Prefs.pushDangerOnly:   pushDangerOnly = v; break;
    }
    _save();
    notifyListeners();
  }

  void setAlertProfile(String profile) {
    alertProfile = profile;
    _save();
    notifyListeners();
  }

  void setCustomMag(double v) {
    customMag = v;
    _save();
    notifyListeners();
  }

  void setCustomRadius(double v) {
    customRadius = v;
    _save();
    notifyListeners();
  }
}

// ════════════════════════════════════════════════════════════
// ── Settings Page ────────────────────────────────────────────
// ════════════════════════════════════════════════════════════

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlertSettingsProvider(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pengaturan',
                      style: GoogleFonts.inter(
                        color: textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Konfigurasi aplikasi',
                      style: GoogleFonts.inter(
                          color: textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 1. Tampilan
                  _SectionHeader(label: 'Tampilan', isDark: isDark),
                  const SizedBox(height: AppSpacing.sm),
                  _ThemeSection(isDark: isDark),
                  const SizedBox(height: AppSpacing.lg),

                  // 2. Parameter Alert (NEW — expanded)
                  _SectionHeader(
                      label: 'Parameter Alert', isDark: isDark),
                  const SizedBox(height: AppSpacing.sm),
                  _AlertParametersSection(isDark: isDark),
                  const SizedBox(height: AppSpacing.lg),

                  // 3. Notifikasi Push (NEW — proper Android/iOS toggles)
                  _SectionHeader(
                      label: 'Notifikasi Push', isDark: isDark),
                  const SizedBox(height: AppSpacing.sm),
                  _PushNotificationSection(isDark: isDark),
                  const SizedBox(height: AppSpacing.lg),

                  // 4. Ambang Batas Risiko (existing)
                  _SectionHeader(
                      label: 'Ambang Batas Risiko', isDark: isDark),
                  const SizedBox(height: AppSpacing.sm),
                  _RiskThresholdsCard(isDark: isDark),
                  const SizedBox(height: AppSpacing.lg),

                  // 5. Koneksi Demo (existing)
                  _SectionHeader(
                      label: 'Koneksi Demo', isDark: isDark),
                  const SizedBox(height: AppSpacing.sm),
                  _ConnectionSection(isDark: isDark),
                  const SizedBox(height: AppSpacing.lg),

                  // 6. Tentang (existing)
                  _SectionHeader(label: 'Tentang', isDark: isDark),
                  const SizedBox(height: AppSpacing.sm),
                  _AboutCard(isDark: isDark),
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

// ════════════════════════════════════════════════════════════
// ── 2. Alert Parameters Section ──────────────────────────────
// ════════════════════════════════════════════════════════════

class _AlertParametersSection extends StatelessWidget {
  const _AlertParametersSection({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AlertSettingsProvider>();

    return NeuCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Alarm Sound ──────────────────────────────
          _SettingsTile(
            icon: Icons.volume_up_rounded,
            iconColor: AppColors.safe,
            title: 'Suara Alarm',
            subtitle: 'Putar alarm saat bahaya terdeteksi',
            isDark: isDark,
            trailing: _NeuSwitch(
              value: s.alertSound,
              onChanged: (v) {
                HapticFeedback.lightImpact();
                s.setBool(_Prefs.alertSound, v);
              },
            ),
          ),
          _Divider(isDark: isDark),

          // ── Vibration ────────────────────────────────
          _SettingsTile(
            icon: Icons.vibration_rounded,
            iconColor: AppColors.warning,
            title: 'Getaran Perangkat',
            subtitle: 'Getar saat menerima peringatan gempa',
            isDark: isDark,
            trailing: _NeuSwitch(
              value: s.vibration,
              onChanged: (v) {
                HapticFeedback.lightImpact();
                s.setBool(_Prefs.vibration, v);
              },
            ),
          ),
          _Divider(isDark: isDark),

          // ── Siren Auto ───────────────────────────────
          _SettingsTile(
            icon: Icons.campaign_rounded,
            iconColor: AppColors.danger,
            title: 'Sirine Otomatis',
            subtitle: 'Aktifkan sirine saat status_trigger = true',
            isDark: isDark,
            trailing: _NeuSwitch(
              value: s.sirenAuto,
              onChanged: (v) {
                HapticFeedback.lightImpact();
                s.setBool(_Prefs.sirenAuto, v);
              },
            ),
          ),
          _Divider(isDark: isDark),

          // ── Alert Profile selector ───────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: const Icon(Icons.tune_rounded,
                          color: AppColors.primary, size: AppSpacing.iconSm),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profil Sensitifitas Alert',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Seberapa cepat sistem memicu peringatan',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _ProfileChip(
                        label: 'Rendah',
                        value: 'low',
                        color: AppColors.safe,
                        selected: s.alertProfile == 'low',
                        isDark: isDark,
                        onTap: () => s.setAlertProfile('low')),
                    const SizedBox(width: AppSpacing.xs),
                    _ProfileChip(
                        label: 'Sedang',
                        value: 'medium',
                        color: AppColors.warning,
                        selected: s.alertProfile == 'medium',
                        isDark: isDark,
                        onTap: () => s.setAlertProfile('medium')),
                    const SizedBox(width: AppSpacing.xs),
                    _ProfileChip(
                        label: 'Tinggi',
                        value: 'high',
                        color: AppColors.danger,
                        selected: s.alertProfile == 'high',
                        isDark: isDark,
                        onTap: () => s.setAlertProfile('high')),
                    const SizedBox(width: AppSpacing.xs),
                    _ProfileChip(
                        label: 'Kustom',
                        value: 'custom',
                        color: AppColors.primary,
                        selected: s.alertProfile == 'custom',
                        isDark: isDark,
                        onTap: () => s.setAlertProfile('custom')),
                  ],
                ),

                // ── Custom threshold (shown only when custom) ──
                AnimatedSize(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  child: s.alertProfile == 'custom'
                      ? Padding(
                          padding:
                              const EdgeInsets.only(top: AppSpacing.md),
                          child: _CustomThresholdSliders(
                              isDark: isDark, s: s),
                        )
                      : const SizedBox.shrink(),
                ),

                const SizedBox(height: AppSpacing.xs),
                // Profile description
                _ProfileDescription(
                    profile: s.alertProfile, isDark: isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileChip extends StatefulWidget {
  const _ProfileChip({
    required this.label,
    required this.value,
    required this.color,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });
  final String label, value;
  final Color color;
  final bool selected, isDark;
  final VoidCallback onTap;

  @override
  State<_ProfileChip> createState() => _ProfileChipState();
}

class _ProfileChipState extends State<_ProfileChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
    final shadows = _pressed || widget.selected
        ? (widget.isDark
            ? AppColors.pressedDark()
            : AppColors.pressedLight())
        : (widget.isDark
            ? AppColors.elevatedDark(blur: 8, offset: 3)
            : AppColors.elevatedLight(blur: 8, offset: 3));

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: widget.selected
                ? widget.color.withOpacity(0.15)
                : bg,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            boxShadow: shadows,
            border: Border.all(
              color: widget.selected
                  ? widget.color.withOpacity(0.45)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.selected
                      ? widget.color
                      : (widget.isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiary),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.selected
                      ? widget.color
                      : (widget.isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary),
                  fontSize: 10,
                  fontWeight: widget.selected
                      ? FontWeight.w700
                      : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileDescription extends StatelessWidget {
  const _ProfileDescription(
      {required this.profile, required this.isDark});
  final String profile;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final (color, desc) = switch (profile) {
      'low' => (
          AppColors.safe,
          'Hanya alert untuk gempa besar (Mag > 5.5). Cocok untuk area rendah risiko.'
        ),
      'medium' => (
          AppColors.warning,
          'Alert untuk gempa sedang ke atas (Mag > 4.0). Rekomendasi umum.'
        ),
      'high' => (
          AppColors.danger,
          'Alert untuk semua aktivitas seismik terdeteksi. Sensitifitas maksimum.'
        ),
      'custom' => (
          AppColors.primary,
          'Threshold magnitudo dan radius dikonfigurasi secara manual.'
        ),
      _ => (AppColors.primary, ''),
    };

    if (desc.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              size: 12, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              desc,
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomThresholdSliders extends StatelessWidget {
  const _CustomThresholdSliders(
      {required this.isDark, required this.s});
  final bool isDark;
  final AlertSettingsProvider s;

  @override
  Widget build(BuildContext context) {
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return NeuCard(
      pressed: true,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Magnitude
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Min. Magnitudo',
                  style: TextStyle(
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  '${s.customMag.toStringAsFixed(1)} SR',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.primary.withOpacity(0.15),
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primaryGlow,
              trackHeight: 3,
            ),
            child: Slider(
              value: s.customMag,
              min: 1.0,
              max: 8.0,
              divisions: 70,
              onChanged: s.setCustomMag,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Radius
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Radius Bahaya',
                  style: TextStyle(
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  '${s.customRadius.toStringAsFixed(0)} km',
                  style: TextStyle(
                      color: AppColors.danger,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.danger,
              inactiveTrackColor: AppColors.danger.withOpacity(0.15),
              thumbColor: AppColors.danger,
              overlayColor: AppColors.dangerGlow,
              trackHeight: 3,
            ),
            child: Slider(
              value: s.customRadius,
              min: 5.0,
              max: 300.0,
              divisions: 59,
              onChanged: s.setCustomRadius,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// ── 3. Push Notification Section ─────────────────────────────
// ════════════════════════════════════════════════════════════

class _PushNotificationSection extends StatelessWidget {
  const _PushNotificationSection({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AlertSettingsProvider>();

    return Column(
      children: [
        NeuCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              // Android Push
              _SettingsTile(
                icon: Icons.android_rounded,
                iconColor: const Color(0xFF3DDC84),
                title: 'Notifikasi Android',
                subtitle: 'Push notification via FCM (Android)',
                isDark: isDark,
                trailing: _NeuSwitch(
                  value: s.pushAndroid,
                  activeColor: const Color(0xFF3DDC84),
                  onChanged: (v) {
                    HapticFeedback.lightImpact();
                    s.setBool(_Prefs.pushAndroid, v);
                  },
                ),
              ),
              _Divider(isDark: isDark),

              // iOS Push
              _SettingsTile(
                icon: Icons.apple_rounded,
                iconColor: isDark ? Colors.white70 : Colors.black87,
                title: 'Notifikasi iOS',
                subtitle: 'Push notification via APNs (iPhone/iPad)',
                isDark: isDark,
                trailing: _NeuSwitch(
                  value: s.pushIos,
                  activeColor: isDark ? Colors.white70 : Colors.black87,
                  onChanged: (v) {
                    HapticFeedback.lightImpact();
                    s.setBool(_Prefs.pushIos, v);
                  },
                ),
              ),
              _Divider(isDark: isDark),

              // Danger only filter
              _SettingsTile(
                icon: Icons.filter_alt_rounded,
                iconColor: AppColors.danger,
                title: 'Hanya BAHAYA',
                subtitle:
                    'Kirim push hanya saat risk level = BAHAYA (bukan WASPADA)',
                isDark: isDark,
                trailing: _NeuSwitch(
                  value: s.pushDangerOnly,
                  activeColor: AppColors.danger,
                  onChanged: (v) {
                    HapticFeedback.lightImpact();
                    s.setBool(_Prefs.pushDangerOnly, v);
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // Info note
        NeuCard(
          pressed: true,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: AppColors.primary, size: 14),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Push notification membutuhkan koneksi internet dan izin notifikasi dari sistem operasi perangkat.',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
// ── Existing sections — preserved exactly ────────────────────
// ════════════════════════════════════════════════════════════

class _ThemeSection extends StatelessWidget {
  const _ThemeSection({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return NeuCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.dark_mode_rounded,
            iconColor: AppColors.primary,
            title: 'Mode Gelap',
            subtitle: 'Tampilan neumorphism gelap',
            isDark: isDark,
            trailing: _NeuSwitch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (_) => themeProvider.toggle(),
            ),
          ),
          _Divider(isDark: isDark),
          _SettingsTile(
            icon: Icons.contrast_rounded,
            iconColor: AppColors.primary,
            title: 'Ikuti Sistem',
            subtitle: 'Sesuaikan tema otomatis',
            isDark: isDark,
            trailing: _NeuSwitch(
              value: themeProvider.themeMode == ThemeMode.system,
              onChanged: (v) => themeProvider.setThemeMode(
                v ? ThemeMode.system : ThemeMode.light,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskThresholdsCard extends StatelessWidget {
  const _RiskThresholdsCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Klasifikasi Risiko Lokal',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          _ThresholdRow(
            label: 'AMAN',
            description:
                'Mag < 3.0  atau  Jarak > 50km + Mag < 5.0',
            color: AppColors.safe,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ThresholdRow(
            label: 'WASPADA',
            description:
                'Mag 3–5  +  Jarak 20–50km\nMag 5–6.5  +  Jarak > 80km',
            color: AppColors.warning,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ThresholdRow(
            label: 'BAHAYA',
            description:
                'Mag 3–5  +  Jarak < 20km\nMag > 5.0  +  Jarak ≤ 80km\nMag ≥ 6.5  (Jarak apapun)',
            color: AppColors.danger,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 14, color: AppColors.primary),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Klasifikasi dihitung lokal — tidak memerlukan koneksi.',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500),
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

class _ThresholdRow extends StatelessWidget {
  const _ThresholdRow({
    required this.label,
    required this.description,
    required this.color,
    required this.isDark,
  });
  final String label, description;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: 3),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            description,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: 11, height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _ConnectionSection extends StatelessWidget {
  const _ConnectionSection({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EarthquakeProvider>();
    return NeuCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Firebase RTDB (Demo)',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '/demo_environment/earthquake_data',
                      style: GoogleFonts.sourceCodePro(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  'SIMULATED',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: NeuButton(
                  label: 'Simulasi Offline',
                  icon: Icons.wifi_off_rounded,
                  variant: NeuButtonVariant.outline,
                  compact: true,
                  expanded: true,
                  onPressed: provider.simulateOffline,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: NeuButton(
                  label: 'Reconnect',
                  icon: Icons.wifi_rounded,
                  variant: NeuButtonVariant.outline,
                  compact: true,
                  expanded: true,
                  color: AppColors.safe,
                  onPressed: provider.simulateReconnect,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _InfoTile(
              icon: Icons.app_shortcut_rounded,
              label: 'Versi Aplikasi',
              value: '1.0.0+1',
              isDark: isDark),
          _Divider(isDark: isDark),
          _InfoTile(
              icon: Icons.code_rounded,
              label: 'Framework',
              value: 'Flutter 3.x',
              isDark: isDark),
          _Divider(isDark: isDark),
          _InfoTile(
              icon: Icons.palette_rounded,
              label: 'Desain',
              value: 'Neumorphism UI',
              isDark: isDark),
          _Divider(isDark: isDark),
          _InfoTile(
              icon: Icons.cloud_rounded,
              label: 'Backend',
              value: 'Firebase RTDB (Demo)',
              isDark: isDark),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });
  final IconData icon;
  final String label, value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return _SettingsTile(
      icon: icon,
      iconColor: AppColors.primary,
      title: label,
      isDark: isDark,
      trailing: Text(
        value,
        style: TextStyle(
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// ── Shared Widgets ────────────────────────────────────────────
// ════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.isDark});
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: 2),
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

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.isDark,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool isDark;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm + 4),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, color: iconColor, size: AppSpacing.iconSm),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                        style: TextStyle(
                            color: textSecondary, fontSize: 11)),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
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
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Divider(
        height: 1,
        thickness: 1,
        color:
            (isDark ? AppColors.textTertiaryDark : AppColors.textTertiary)
                .withOpacity(0.15),
      ),
    );
  }
}

// ── Neumorphism Switch (accepts optional custom activeColor) ──

class _NeuSwitch extends StatefulWidget {
  const _NeuSwitch({
    required this.value,
    required this.onChanged,
    this.activeColor,
  });
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;

  @override
  State<_NeuSwitch> createState() => _NeuSwitchState();
}

class _NeuSwitchState extends State<_NeuSwitch> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final activeColor = widget.activeColor ?? AppColors.primary;

    final shadows = _pressed
        ? (isDark ? AppColors.pressedDark() : AppColors.pressedLight())
        : (isDark
            ? AppColors.elevatedDark(blur: 6, offset: 3)
            : AppColors.elevatedLight(blur: 6, offset: 3));

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onChanged(!widget.value);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 48,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          color: widget.value ? activeColor.withOpacity(0.15) : bg,
          boxShadow: shadows,
          border: Border.all(
            color: widget.value
                ? activeColor.withOpacity(0.35)
                : Colors.transparent,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment:
              widget.value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.value
                    ? activeColor
                    : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
