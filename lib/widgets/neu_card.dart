import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// The foundational neumorphism surface.
/// Every card, panel, and container in the app uses this widget.
///
/// [pressed] renders the inset/inner-shadow variant (for active states)
/// [child] can be any widget
class NeuCard extends StatelessWidget {
  const NeuCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.margin,
    this.radius = AppSpacing.radiusLg,
    this.pressed = false,
    this.color,
    this.blur = 16,
    this.shadowOffset = 6,
    this.borderColor,
    this.borderWidth = 0,
    this.width,
    this.height,
    this.onTap,
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final bool pressed;
  final Color? color;
  final double blur;
  final double shadowOffset;
  final Color? borderColor;
  final double borderWidth;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = color ?? (isDark ? AppColors.darkBg : AppColors.lightBg);

    final shadows = pressed
        ? (isDark
            ? AppColors.pressedDark()
            : AppColors.pressedLight())
        : (isDark
            ? AppColors.elevatedDark(blur: blur, offset: shadowOffset)
            : AppColors.elevatedLight(blur: blur, offset: shadowOffset));

    final decoration = BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(radius),
      gradient: gradient,
      border: borderWidth > 0 && borderColor != null
          ? Border.all(color: borderColor!, width: borderWidth)
          : null,
      boxShadow: shadows,
    );

    final container = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: decoration,
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      return _TappableNeuCard(
        onTap: onTap!,
        decoration: decoration,
        pressedDecoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
          gradient: gradient,
          border: borderWidth > 0 && borderColor != null
              ? Border.all(color: borderColor!, width: borderWidth)
              : null,
          boxShadow: isDark
              ? AppColors.pressedDark()
              : AppColors.pressedLight(),
        ),
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        child: child,
      );
    }

    return container;
  }
}

class _TappableNeuCard extends StatefulWidget {
  const _TappableNeuCard({
    required this.child,
    required this.onTap,
    required this.decoration,
    required this.pressedDecoration,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  final Widget child;
  final VoidCallback onTap;
  final BoxDecoration decoration;
  final BoxDecoration pressedDecoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  @override
  State<_TappableNeuCard> createState() => _TappableNeuCardState();
}

class _TappableNeuCardState extends State<_TappableNeuCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        decoration: _isPressed ? widget.pressedDecoration : widget.decoration,
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}
