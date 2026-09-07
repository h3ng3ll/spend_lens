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

  void _onTap() => onTap();

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final color = isSelected ? scheme.accent : scheme.ter;

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
              style: textTheme.tabLabel10.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
