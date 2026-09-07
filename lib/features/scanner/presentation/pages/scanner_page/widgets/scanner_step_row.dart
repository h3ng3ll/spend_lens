import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// One row of the processing checklist — done (teal check) / current
/// (highlighted, bold label) / pending (dim outline) — driven purely by
/// [isDone]/[isCurrent], which the caller derives from the REAL
/// `processingStep` count (design_spendlens.md §8), never a fake timer tick.
///
/// No fixed row height — `Row` sizes to its 20dp dot + label content, which
/// already grows safely under a larger `textScaleFactor` since neither
/// child is height-clamped (per-site sweep: this file has no fixed heights
/// besides the 20dp dot itself, which is a fixed decorative glyph size, not
/// a text-bearing cell — textScaleFactor cannot overflow a circle that
/// contains no text).
class ScannerStepRow extends StatelessWidget {
  final String label;
  final bool isDone;
  final bool isCurrent;

  const ScannerStepRow({
    super.key,
    required this.label,
    required this.isDone,
    required this.isCurrent,
  });

  static const _dotSize = 20.0;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    final labelColor = isDone || isCurrent ? scheme.ink : scheme.dim;
    final labelStyle = isCurrent
        ? textTheme.body17.copyWith(
            color: labelColor,
            fontWeight: FontWeight.w600,
          )
        : textTheme.body17.copyWith(color: labelColor);

    return Row(
      spacing: 12.0,
      children: [
        AppContainer(
          width: _dotSize,
          height: _dotSize,
          shape: BoxShape.circle,
          color: isDone ? scheme.accent : null,
          border: isDone
              ? null
              : Border.all(
                  color: isCurrent ? scheme.accent : scheme.dim,
                  width: 2.0,
                ),
          alignment: Alignment.center,
          child: isDone
              ? AppSvgIcon(
                  asset: AppIcons.check,
                  color: scheme.onAccent,
                  size: 10.0,
                )
              : isCurrent
              ? AppContainer(
                  width: 8.0,
                  height: 8.0,
                  shape: BoxShape.circle,
                  color: scheme.accent,
                )
              : null,
        ),
        Expanded(child: Text(label, style: labelStyle)),
      ],
    );
  }
}
