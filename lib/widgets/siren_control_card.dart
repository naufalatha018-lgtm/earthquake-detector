import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../providers/earthquake_provider.dart';
import 'neu_card.dart';

class SirenControlCard extends StatefulWidget {
  const SirenControlCard({super.key});

  @override
  State<SirenControlCard> createState() => _SirenControlCardState();
}

class _SirenControlCardState extends State<SirenControlCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _pulseAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  void _syncAnimation(bool active) {
    if (active && !_pulseCtrl.isAnimating) {
      _pulseCtrl.repeat(reverse: true);
    } else if (!active) {
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
    final provider = context.watch<EarthquakeProvider>();
    final active = provider.sirenActive;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    _syncAnimation(active);

    final color = active ? AppColors.danger : AppColors.safe;

    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, _) {
        return NeuCard(
          borderColor: color.withOpacity(active ? 0.35 : 0.2),
          borderWidth: 1.5,
          child: Row(
            children: [
              // Icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(active ? _pulseAnim.value * 0.2 : 0.1),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: color.withOpacity(_pulseAnim.value * 0.35),
                            blurRadius: 14,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
                child: Icon(
                  active ? Icons.campaign_rounded : Icons.campaign_outlined,
                  color: color,
                  size: 26,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // Labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sirine Peringatan',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      active ? 'AKTIF — Ketuk untuk nonaktifkan' : 'Tidak aktif',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: active ? FontWeight.w600 : null,
                          ),
                    ),
                  ],
                ),
              ),

              // Toggle
              _NeuToggle(
                value: active,
                activeColor: color,
                onToggle: () {
                  HapticFeedback.mediumImpact();
                  provider.toggleSiren();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NeuToggle extends StatefulWidget {
  const _NeuToggle({
    required this.value,
    required this.activeColor,
    required this.onToggle,
  });
  final bool value;
  final Color activeColor;
  final VoidCallback onToggle;

  @override
  State<_NeuToggle> createState() => _NeuToggleState();
}

class _NeuToggleState extends State<_NeuToggle> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final shadows = _pressed
        ? (isDark ? AppColors.pressedDark() : AppColors.pressedLight())
        : (isDark
            ? AppColors.elevatedDark(blur: 8, offset: 4)
            : AppColors.elevatedLight(blur: 8, offset: 4));

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onToggle();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 52,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          color: widget.value ? widget.activeColor.withOpacity(0.2) : bg,
          boxShadow: shadows,
          border: Border.all(
            color: widget.value
                ? widget.activeColor.withOpacity(0.4)
                : Colors.transparent,
            width: 1,
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
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.value ? widget.activeColor : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
