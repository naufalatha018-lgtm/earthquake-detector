import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum NeuButtonVariant { primary, outline, ghost, danger }

/// Neumorphism-styled button with smooth press feedback.
class NeuButton extends StatefulWidget {
  const NeuButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = NeuButtonVariant.primary,
    this.isLoading = false,
    this.expanded = false,
    this.compact = false,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final NeuButtonVariant variant;
  final bool isLoading;
  final bool expanded;
  final bool compact;
  final Color? color;

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  Color _resolveColor(bool isDark) {
    if (widget.color != null) return widget.color!;
    switch (widget.variant) {
      case NeuButtonVariant.primary:
        return AppColors.primary;
      case NeuButtonVariant.danger:
        return AppColors.danger;
      case NeuButtonVariant.outline:
      case NeuButtonVariant.ghost:
        return isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final accent = _resolveColor(isDark);
    final disabled = widget.onPressed == null && !widget.isLoading;

    final isPrimary = widget.variant == NeuButtonVariant.primary ||
        widget.variant == NeuButtonVariant.danger;

    final shadows = _isPressed
        ? (isDark ? AppColors.pressedDark() : AppColors.pressedLight())
        : (isDark
            ? AppColors.elevatedDark(blur: 12, offset: 5)
            : AppColors.elevatedLight(blur: 12, offset: 5));

    final bgColor = isPrimary ? accent : bg;
    final textColor = isPrimary
        ? Colors.white
        : accent;

    final h = widget.compact ? 40.0 : 52.0;

    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      height: h,
      decoration: BoxDecoration(
        color: bgColor.withOpacity(disabled ? 0.5 : 1.0),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: isPrimary ? [] : shadows,
        border: widget.variant == NeuButtonVariant.outline
            ? Border.all(color: accent.withOpacity(0.4), width: 1.5)
            : null,
      ),
      child: Center(
        child: widget.isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: textColor, size: AppSpacing.iconSm),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
      ),
    );

    return GestureDetector(
      onTapDown: (_) {
        if (disabled) return;
        HapticFeedback.lightImpact();
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        if (disabled) return;
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: widget.expanded
          ? SizedBox(width: double.infinity, child: content)
          : IntrinsicWidth(
              stepWidth: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: content,
              ),
            ),
    );
  }
}
