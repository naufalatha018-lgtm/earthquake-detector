import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/risk_engine.dart';
import 'neu_card.dart';

/// Prominent risk level display card with pulse animation for danger.
class RiskIndicatorCard extends StatefulWidget {
  const RiskIndicatorCard({
    super.key,
    required this.result,
  });

  final RiskResult result;

  @override
  State<RiskIndicatorCard> createState() => _RiskIndicatorCardState();
}

class _RiskIndicatorCardState extends State<RiskIndicatorCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _updateAnimation();
  }

  @override
  void didUpdateWidget(RiskIndicatorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.result.level != widget.result.level) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    if (widget.result.level == RiskLevel.bahaya) {
      _pulseCtrl.repeat(reverse: true);
    } else {
      _pulseCtrl.stop();
      _pulseCtrl.value = 1.0;
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final result = widget.result;
    final color = result.color;
    final bg = isDark ? result.bgColorDark : result.bgColor;

    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, _) {
        final pulseOpacity = result.level == RiskLevel.bahaya
            ? _pulseAnim.value * 0.25
            : 0.15;

        return NeuCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          color: isDark ? AppColors.darkBg : AppColors.lightBg,
          borderColor: color.withOpacity(0.3),
          borderWidth: 1.5,
          child: Column(
            children: [
              // Glow ring + icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(pulseOpacity),
                  border: Border.all(
                    color: color.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: result.level == RiskLevel.bahaya
                      ? [
                          BoxShadow(
                            color: color.withOpacity(_pulseAnim.value * 0.4),
                            blurRadius: 20,
                            spreadRadius: 4,
                          )
                        ]
                      : [],
                ),
                child: Icon(result.icon, color: color, size: 32),
              ),

              const SizedBox(height: AppSpacing.md),

              // Level label
              Text(
                result.label,
                style: GoogleFonts.inter(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              // Description
              Text(
                result.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
