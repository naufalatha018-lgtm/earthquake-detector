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

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final bool isDark;

  _ParticlePainter({required this.particles, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = AppColors.primary.withOpacity(p.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.radius,
        paint,
      );
    }

    final crackPaint = Paint()
      ..color = isDark
          ? AppColors.safe.withOpacity(0.05)
          : AppColors.primary.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final rng = Random(42);
    for (var i = 0; i < 4; i++) {
      final path = Path();
      final sx = rng.nextDouble();
      final sy = rng.nextDouble();
      path.moveTo(sx * size.width, sy * size.height);
      for (var j = 0; j < 3; j++) {
        path.lineTo(
          (sx + rng.nextDouble() * 0.25 - 0.08) * size.width,
          (sy + rng.nextDouble() * 0.2) * size.height,
        );
      }
      canvas.drawPath(path, crackPaint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}

class _Particle {
  double x, y, radius, opacity, vx, vy;
  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.opacity,
    required this.vx,
    required this.vy,
  });
}

class _AnimatedParticleBackground extends StatefulWidget {
  const _AnimatedParticleBackground({required this.isDark});
  final bool isDark;

  @override
  State<_AnimatedParticleBackground> createState() =>
      _AnimatedParticleBackgroundState();
}

class _AnimatedParticleBackgroundState
    extends State<_AnimatedParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_Particle> _particles;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(
      28,
      (_) => _Particle(
        x: _rng.nextDouble(),
        y: _rng.nextDouble(),
        radius: 0.8 + _rng.nextDouble() * 2.2,
        opacity: 0.03 + _rng.nextDouble() * 0.08,
        vx: (_rng.nextDouble() - 0.5) * 0.00015,
        vy: -0.00008 - _rng.nextDouble() * 0.00012,
      ),
    );

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..addListener(_tick)
      ..repeat();
  }

  void _tick() {
    for (final p in _particles) {
      p.x += p.vx;
      p.y += p.vy;
      if (p.y < -0.05) {
        p.y = 1.05;
        p.x = _rng.nextDouble();
      }
      if (p.x < -0.05 || p.x > 1.05) {
        p.x = _rng.nextDouble();
        p.y = _rng.nextDouble();
      }
    }
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
        painter: _ParticlePainter(particles: _particles, isDark: widget.isDark),
        child: const SizedBox.expand(),
      ),
    );
  }
}

// ── Register Page ───────────────────────────────────────────

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  late final AnimationController _breathCtrl;
  late final Animation<double> _breathAnim;
  late final AnimationController _entryCtrl;
  late final Animation<double> _entryFade;
  late final Animation<double> _entrySlide;

  @override
  void initState() {
    super.initState();
    _breathCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
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
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _breathCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  void _onRegister() async {
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1400));
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
          // Cinematic particle background
          _AnimatedParticleBackground(isDark: isDark),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, 0.2),
                radius: 1.3,
                colors: [bg.withOpacity(0.0), bg.withOpacity(0.5)],
              ),
            ),
          ),

          // Main UI
          SafeArea(
            child: AnimatedBuilder(
              animation: _entryCtrl,
              builder: (context, _) {
                return FadeTransition(
                  opacity: _entryFade,
                  child: Transform.translate(
                    offset: Offset(0, _entrySlide.value),
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg),
                            child: Column(
                              children: [
                                const SizedBox(height: AppSpacing.lg),

                                // Back + header
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => context.go('/login'),
                                      child: NeuCard(
                                        padding:
                                            const EdgeInsets.all(AppSpacing.sm),
                                        radius: AppSpacing.radiusMd,
                                        child: Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          size: AppSpacing.iconSm,
                                          color: isDark
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Buat Akun',
                                          style: GoogleFonts.inter(
                                            color: textPrimary,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                        Text(
                                          'Daftar sebagai operator pemantauan',
                                          style: GoogleFonts.inter(
                                            color: textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: AppSpacing.lg),

                                // Logo (small, breathing)
                                ScaleTransition(
                                  scale: _breathAnim,
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppSpacing.radiusLg),
                                      color: isDark
                                          ? AppColors.darkBg
                                          : AppColors.lightBg,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              AppColors.primary.withOpacity(0.2),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                        ...(isDark
                                            ? AppColors.elevatedDark(
                                                blur: 16, offset: 6)
                                            : AppColors.elevatedLight(
                                                blur: 16, offset: 6)),
                                      ],
                                    ),
                                    child: Center(
                                      child: ShaderMask(
                                        shaderCallback: (bounds) =>
                                            const LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.safe
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds),
                                        child: const Icon(
                                          Icons.sensors_rounded,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: AppSpacing.lg),

                                _buildRegisterCard(
                                    isDark, textPrimary, textSecondary),

                                const SizedBox(height: AppSpacing.lg),

                                // Login link
                                GestureDetector(
                                  onTap: () => context.go('/login'),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Sudah punya akun? ',
                                        style: GoogleFonts.inter(
                                          color: textSecondary,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        'Masuk',
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
                      ],
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

  Widget _buildRegisterCard(
      bool isDark, Color textPrimary, Color textSecondary) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow behind card
        Container(
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            boxShadow: [
              BoxShadow(
                color: AppColors.safe.withOpacity(0.10),
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
              NeuTextField(
                controller: _nameCtrl,
                label: 'Nama Lengkap',
                hint: 'Nama operator',
                prefixIcon: Icons.person_outline_rounded,
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: AppSpacing.md),

              NeuTextField(
                controller: _emailCtrl,
                label: 'Email',
                hint: 'operator@seismoguard.app',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: AppSpacing.md),

              NeuTextField(
                controller: _passCtrl,
                label: 'Kata Sandi',
                hint: 'Min. 8 karakter',
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

              const SizedBox(height: AppSpacing.md),

              NeuTextField(
                controller: _confirmCtrl,
                label: 'Konfirmasi Kata Sandi',
                hint: 'Ulangi kata sandi',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscureConfirm,
                suffixIcon: GestureDetector(
                  onTap: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  child: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: AppSpacing.iconSm,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              NeuButton(
                label: _isLoading ? 'Mendaftar...' : 'Buat Akun',
                icon: _isLoading ? null : Icons.person_add_rounded,
                variant: NeuButtonVariant.primary,
                expanded: true,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _onRegister,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
