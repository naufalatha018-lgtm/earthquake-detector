import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.child,
    required this.location,
  });

  final Widget child;
  final String location;

  static const _tabs = [
    _TabItem(
      path: '/dashboard',
      icon: Icons.sensors_rounded,
      activeIcon: Icons.sensors_rounded,
      label: 'Dashboard',
    ),
    _TabItem(
      path: '/settings',
      icon: Icons.tune_rounded,
      activeIcon: Icons.tune_rounded,
      label: 'Pengaturan',
    ),
    _TabItem(
      path: '/account',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Akun',
    ),
  ];

  int get _currentIndex {
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final shadows = isDark
        ? AppColors.elevatedDark(blur: 20, offset: 0)
        : AppColors.elevatedLight(blur: 20, offset: 0);

    return Scaffold(
      backgroundColor: bg,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: bg,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? AppColors.darkShadowLow.withOpacity(0.8)
                  : AppColors.lightShadowLow.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final selected = _currentIndex == i;
                return _NeuTabItem(
                  tab: tab,
                  selected: selected,
                  isDark: isDark,
                  onTap: () => context.go(tab.path),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.path,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _NeuTabItem extends StatefulWidget {
  const _NeuTabItem({
    required this.tab,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final _TabItem tab;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_NeuTabItem> createState() => _NeuTabItemState();
}

class _NeuTabItemState extends State<_NeuTabItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
    final shadows = _pressed || widget.selected
        ? (widget.isDark ? AppColors.pressedDark() : AppColors.pressedLight())
        : (widget.isDark
            ? AppColors.elevatedDark(blur: 8, offset: 3)
            : AppColors.elevatedLight(blur: 8, offset: 3));

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: shadows,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                widget.selected ? widget.tab.activeIcon : widget.tab.icon,
                key: ValueKey(widget.selected),
                color: widget.selected
                    ? AppColors.primary
                    : (widget.isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary),
                size: AppSpacing.iconMd,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    widget.selected ? FontWeight.w700 : FontWeight.w400,
                color: widget.selected
                    ? AppColors.primary
                    : (widget.isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary),
              ),
              child: Text(widget.tab.label),
            ),
          ],
        ),
      ),
    );
  }
}
