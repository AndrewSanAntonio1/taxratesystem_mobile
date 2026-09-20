import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

/// macOS-style dock as the app's bottom navigation: a floating pill whose icons
/// magnify around the pointer and settle back when it leaves, with the active
/// destination marked by colour and a dot under its label.
///
/// The dock is a controlled widget — [activeIndex] and [onSelected] belong to
/// the shell that swaps the tab bodies — so its own state only tracks the
/// pointer position that drives the magnification.
class DockingBar extends StatefulWidget {
  const DockingBar({
    super.key,
    required this.icons,
    required this.labels,
    required this.activeIndex,
    required this.onSelected,
  });

  /// One filled glyph per destination, in tab order.
  final List<IconData> icons;

  /// One short label per destination, rendered beneath its icon.
  final List<String> labels;

  /// The shell's current tab; the dock never owns this.
  final int activeIndex;

  final ValueChanged<int> onSelected;

  /// Peak magnification under the pointer; neighbours fall off from here.
  static const double _maxScale = 1.5;

  @override
  State<DockingBar> createState() => _DockingBarState();
}

class _DockingBarState extends State<DockingBar> {
  /// Horizontal pointer position within the dock, or null while it is not
  /// hovered (touch never sets it, so the dock rests at its natural size).
  double? _pointerDx;

  /// Gaussian falloff around the pointer, in [itemWidth] units: the hovered
  /// icon reaches [_maxScale], its neighbours taper to 1.
  double _scaleFor(int index, double dockWidth) {
    final double? pointerDx = _pointerDx;
    if (pointerDx == null) return 1.0;
    final double itemWidth = dockWidth / widget.icons.length;
    final double center = itemWidth * (index + 0.5);
    final double distance = (center - pointerDx).abs() / itemWidth;
    final double falloff = math.exp(-distance * distance / 2);
    return 1.0 + (DockingBar._maxScale - 1.0) * falloff;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Material(
          color: AppColors.surface,
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusLarge),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: MouseRegion(
              onHover: (event) => setState(() {
                _pointerDx = event.localPosition.dx;
              }),
              onExit: (_) => setState(() => _pointerDx = null),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      for (int i = 0; i < widget.icons.length; i++)
                        Expanded(
                          child: _DockItem(
                            icon: widget.icons[i],
                            label: widget.labels[i],
                            active: i == widget.activeIndex,
                            scale: _scaleFor(i, constraints.maxWidth),
                            onTap: () => widget.onSelected(i),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One dock slot: the magnifying icon, its label and the active dot. The scale
/// arrives from the parent's pointer maths; this widget only animates toward
/// whatever it is given.
class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.scale,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = active ? AppColors.navActive : AppColors.navInactive;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: scale),
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        builder: (context, animatedScale, child) => Transform.scale(
          scale: animatedScale,
          alignment: Alignment.bottomCenter,
          child: child,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                height: 1.0,
                fontWeight: active ? FontWeight.bold : FontWeight.w400,
                color: color,
              ),
            ),
            const SizedBox(height: 3),
            // Active dot: an invisible spacer when inactive, so every slot
            // keeps the same height and the dock cannot jitter between tabs.
            SizedBox(
              width: 4,
              height: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: active ? color : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}