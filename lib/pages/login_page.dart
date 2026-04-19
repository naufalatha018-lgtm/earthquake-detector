import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/neu_card.dart';
import '../widgets/neu_button.dart';
import '../widgets/neu_text_field.dart';

// ── Cinematic Seismic Wave Background ──────────────────────
class _SeismicWavePainter extends CustomPainter {
  final double phase;
  final bool isDark;

  _SeismicWavePainter({required this.phase, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final baseColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final waveColor = isDark
        ? AppColors.primary.withOpacity(0.06)
        : AppColors.primary.withOpacity(0.07);

    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Draw 6 seismic wave lines at different heights
    final waveLevels = [0.18, 0.32, 0.48, 0.62, 0.76, 0.88];
    for (var k = 0; k < waveLevels.length; k++) {
      final y = size.height * waveLevels[k];
      final amplitude = 6.0 + (k % 3) * 4.0;
      final freq = 0.012 + (k % 4) * 0.003;
      final phaseShift = phase + k * 0.8;

      final path = Path();
      path.moveTo(0, y);

      for (double x = 0; x <= size.width; x += 2) {
        // Composite wave: slow base + brief seismic spike
        final baseWave = amplitude * sin(freq * x + phaseShift);
        final spike = (k == 2 || k == 4)
            ? 12.0 *
                sin(freq * 3.5 * x + phaseShift * 0.7) *
                exp(-0.0003 * pow(x - size.width * 0.4, 2))
            : 0.0;
        path.lineTo(x, y + baseWave + spike);
      }

      canvas.drawPath(path, paint);
    }

    // Subtle crack lines — very low opacity
    final crackPaint = Paint()
      ..color = isDark
          ? AppColors.primary.withOpacity(0.04)
          : AppColors.primary.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final cracks = [
      [0.25, 0.0, 0.38, 0.22, 0.45, 0.18],
      [0.7, 1.0, 0.62, 0.78, 0.55, 0.82],
      [0.85, 0.3, 0.75, 0.5, 0.78, 0.65],
    ];

    for (final crack in cracks) {
      final p = Path();
      p.moveTo(size.width * crack[0], size.height * crack[1]);
      p.quadraticBezierTo(
        size.width * crack[2],
        size.height * crack[3],
        size.width * crack[4],
        size.height * crack[5],
      );
      canvas.drawPath(p, crackPaint);
    }
  }

  @override
  bool shouldRepaint(_SeismicWavePainter oldDelegate) =>
      oldDelegate.phase != phase;
}

class _AnimatedSeismicBackground extends StatefulWidget {
  const _AnimatedSeismicBackground({required this.isDark});
  final bool isDark;

  @override
  State<_AnimatedSeismicBackground> createState() =>
      _AnimatedSeismicBackgroundState();
}

class _AnimatedSeismicBackgroundState
    extends State<_AnimatedSeismicBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _SeismicWavePainter(
          phase: _ctrl.value * 2 * pi,
          isDark: widget.isDark,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

// ── Login Page ──────────────────────────────────────────────

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;

  // Card breathing animation
  late final AnimationController _breathCtrl;
  late final Animation<double> _breathAnim;

  // Entry animation
  late final AnimationController _entryCtrl;
  late final Animation<double> _entryFade;
  late final Animation<double> _entrySlide;

  @override
  void initState() {
    super.initState();

    _breathCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    _breathAnim = Tween<double>(begin: 0.98, end: 1.0).animate(
      CurvedAnimation(parent: _breathCtrl, curve: Curves.easeInOut),
    );

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _entryFade = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _entrySlide = Tween<double>(begin: 32, end: 0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.1, 0.85, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _breathCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  void _onLogin() async {
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/dashboard');
    }
  }

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
      body: Stack(
        children: [
          // ── Cinematic animated background
          _AnimatedSeismicBackground(isDark: isDark),

          // ── Soft gradient overlay for depth
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.3),
                radius: 1.2,
                colors: [
                  (isDark ? AppColors.darkBg : AppColors.lightBg)
                      .withOpacity(0.0),
                  (isDark ? AppColors.darkBg : AppColors.lightBg)
                      .withOpacity(0.55),
                ],
              ),
            ),
          ),

          // ── Main login UI
          SafeArea(
            child: AnimatedBuilder(
              animation: _entryCtrl,
              builder: (context, _) {
                return FadeTransition(
                  opacity: _entryFade,
                  child: Transform.translate(
                    offset: Offset(0, _entrySlide.value),
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: AppSpacing.xxl),

                            // ── Logo
                            ScaleTransition(
                              scale: _breathAnim,
                              child: _buildLogo(isDark),
                            ),

                            const SizedBox(height: AppSpacing.lg),

                            // App name
                            Text(
                              'Bhukampa Tech',
                              style: GoogleFonts.inter(
                                color: textPrimary,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.8,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Sistem Peringatan Dini Gempa Bumi',
                              style: GoogleFonts.inter(
                                color: textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.1,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // ── Card with glow behind
                            _buildLoginCard(
                                isDark, textPrimary, textSecondary),

                            const SizedBox(height: AppSpacing.lg),

                            // Register link
                            GestureDetector(
                              onTap: () => context.go('/register'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Belum punya akun? ',
                                    style: GoogleFonts.inter(
                                      color: textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Daftar',
                                    style: GoogleFonts.inter(
                                      color: AppColors.primary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSpacing.xxl),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        color: isDark ? AppColors.darkBg : AppColors.lightBg,
        boxShadow: [
          // Glow behind logo
          BoxShadow(
            color: AppColors.primary.withOpacity(0.22),
            blurRadius: 28,
            spreadRadius: 4,
          ),
          ...(isDark
              ? AppColors.elevatedDark(blur: 20, offset: 8)
              : AppColors.elevatedLight(blur: 20, offset: 8)),
        ],
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.primary, AppColors.safe],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Icon(
            Icons.sensors_rounded,
            size: 44,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(
      bool isDark, Color textPrimary, Color textSecondary) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Soft glow behind card
        Container(
          height: 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.12),
                blurRadius: 40,
                spreadRadius: 8,
              ),
            ],
          ),
        ),

        NeuCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          radius: AppSpacing.radiusXl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang',
                style: GoogleFonts.inter(
                  color: textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Masuk untuk memantau aktivitas seismik',
                style: GoogleFonts.inter(
                  color: textSecondary,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              NeuTextField(
                controller: _emailCtrl,
                label: 'Email',
                hint: 'operator@bhukampa.tech',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: AppSpacing.md),

              NeuTextField(
                controller: _passCtrl,
                label: 'Kata Sandi',
                hint: '••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscurePass,
                suffixIcon: GestureDetector(
                  onTap: () => setState(() => _obscurePass = !_obscurePass),
                  child: Icon(
                    _obscurePass
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: AppSpacing.iconSm,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Lupa kata sandi?',
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              NeuButton(
                label: _isLoading ? 'Memproses...' : 'Masuk',
                icon: _isLoading ? null : Icons.login_rounded,
                variant: NeuButtonVariant.primary,
                expanded: true,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _onLogin,
              ),

              const SizedBox(height: AppSpacing.md),

              // Demo skip
              NeuButton(
                label: 'Lewati — Demo Mode',
                icon: Icons.science_rounded,
                variant: NeuButtonVariant.outline,
                expanded: true,
                compact: true,
                color: AppColors.warning,
                onPressed: () => context.go('/dashboard'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
