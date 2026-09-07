import 'package:flutter/material.dart';

import '../resources/app_icons.dart';
import '../resources/colors/app_color_scheme.dart';
import '../resources/text/app_text_theme.dart';
import 'app_container.dart';
import 'app_svg_icon.dart';

/// A single settings-style row: label on the left, an optional trailing
/// value/text, an optional chevron, and a hairline bottom divider
/// (design_spendlens.md's Settings artboard — every grouped-card row shares
/// this exact 52dp shape).
///
/// No fixed height anywhere — the row grows with its tallest child under a
/// larger `textScaleFactor` (same guard as `RecordListRow`), so `height:
/// 52.0` in the artboard is a MINIMUM, applied via a `ConstrainedBox`, never
/// a hard clip.
class SettingsRow extends StatelessWidget {
  final String label;
  final String? trailingText;
  final Color? trailingTextColor;
  final Widget? trailing;
  final bool showChevron;
  final bool showBottomDivider;
  final Color? labelColor;
  final VoidCallback? onTap;

  const SettingsRow({
    super.key,
    required this.label,
    this.trailingText,
    this.trailingTextColor,
    this.trailing,
    this.showChevron = true,
    this.showBottomDivider = true,
    this.labelColor,
    this.onTap,
  });

  static const double _minHeight = 52.0;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _minHeight),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: textTheme.body17.copyWith(color: labelColor ?? scheme.ink),
            ),
          ),
          ?trailing,
          if (trailing == null && trailingText != null)
            Text(
              trailingText!,
              style: textTheme.body17.copyWith(
                color: trailingTextColor ?? scheme.sec,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (showChevron)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: AppSvgIcon(
                asset: AppIcons.chevronRight,
                color: scheme.ter,
                size: 18.0,
              ),
            ),
        ],
      ),
    );

    final content = AppContainer(
      border: showBottomDivider
          ? Border(bottom: BorderSide(color: scheme.field, width: 0.5))
          : null,
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      child: row,
    );

    if (onTap == null) return content;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}
