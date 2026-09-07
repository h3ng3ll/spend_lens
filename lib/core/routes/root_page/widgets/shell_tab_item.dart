import 'package:flutter/material.dart';

import '../../../resources/colors/app_color_scheme.dart';
import '../../../resources/text/app_text_theme.dart';
import '../../../widgets/app_svg_icon.dart';

/// One tab of the bottom pill (design_spendlens.md §5 — the 5-branch shell).
///
/// Layout only (A6, Container Rule): receives everything it needs to render
/// as constructor parameters, and dispatches the tap through [onTap] — the
/// parent decides what a tap means (`navigationShell.goBranch`), this widget
/// only reports the gesture.
class ShellTabItem extends StatelessWidget {
  final String asset;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ShellTabItem({
    super.key,
    required this.asset,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  /// Caps how far the OS text-scale setting can grow this label — the tab
  /// bar has a fixed pill of 5 items and no room for the label to double in
  /// height, so scaling is clamped rather than ignored outright (never a
  /// hard 64.0dp box with unclamped text — the fixed-dp-cell-height chronic
  /// bug, `sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`).
  static const double _kMaxLabelTextScale = 1.3;

  void _onTap() => onTap();

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final color = isSelected ? scheme.accent : scheme.ter;
    final clampedScaler = MediaQuery.textScalerOf(
      context,
    ).clamp(maxScaleFactor: _kMaxLabelTextScale);

    return Expanded(
      child: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 4.0,
          children: [
            AppSvgIcon(asset: asset, color: color, size: 22.0),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaler: clampedScaler,
              style: textTheme.tabLabel10.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
