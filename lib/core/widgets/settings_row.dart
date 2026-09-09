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
/// Layout is content-driven: `MainAxisAlignment.spaceBetween` pushes the
/// label and the trailing group to opposite edges, so a trailing value sits
/// hard against the right (or the chevron) instead of floating inside a
/// reserved column. No hardcoded flex split.
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
      // `spaceBetween` + content-sized children, NOT a fixed flex split.
      //
      // The label and trailing value used to be hardcoded to `flex: 3` /
      // `flex: 2`, which reserved 2/5 of the row for the trailing text no
      // matter how short it was — so `MDL`, a category count, and the
      // version string all floated with a gap before the right edge or the
      // chevron. Letting the trailing content size ITSELF and pushing the
      // free space between the two ends puts every value hard against the
      // right, at any label length or locale.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Still Flexible: a long label in a verbose locale must ellipsize
          // rather than overflow, and it yields space to the trailing value
          // instead of the other way round.
          Flexible(
            child: Text(
              label,
              style: textTheme.body17.copyWith(color: labelColor ?? scheme.ink),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailing != null)
                // The clamped scaler stays: without it the trailing WIDGET
                // keeps its intrinsic width and overflows at large text
                // scales (`sig:developer-derived-fixed-dp-cell-height-
                // ignores-textScaleFactor`).
                MediaQuery.withClampedTextScaling(
                  maxScaleFactor: 1.3,
                  child: trailing!,
                ),
              if (trailing == null && trailingText != null)
                // Capped so a long value cannot push the label out; short
                // values (the common case) size to their own width.
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.45,
                  ),
                  child: Text(
                    trailingText!,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: textTheme.body17.copyWith(
                      color: trailingTextColor ?? scheme.sec,
                      fontWeight: FontWeight.w500,
                    ),
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
