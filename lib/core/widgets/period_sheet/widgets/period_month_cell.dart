import 'package:flutter/material.dart';

import '../../../resources/colors/app_color_scheme.dart';
import '../../../resources/text/app_text_theme.dart';
import '../../app_container.dart';

/// One month cell in the Period sheet's 4-column grid.
///
/// Three visual states, each distinct: selected (gradient fill), selectable-
/// unselected (plain field fill), and not-yet-selectable (dimmed,
/// `fieldDim`, no tap) — the last covers a future month with no recorded
/// data, per design_spendlens.md's period-sheet rule.
class PeriodMonthCell extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isSelectable;
  final VoidCallback? onTap;

  const PeriodMonthCell({
    super.key,
    required this.label,
    required this.isSelected,
    required this.isSelectable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    final cell = AppContainer(
      color: isSelected
          ? null
          : isSelectable
          ? scheme.field
          : scheme.fieldDim,
      gradient: isSelected ? scheme.accentGradient : null,
      borderRadius: BorderRadius.circular(12.0),
      alignment: Alignment.center,
      child: Text(
        label,
        style: textTheme.subhead15.copyWith(
          color: isSelected
              ? scheme.onAccent
              : isSelectable
              ? scheme.ink
              : scheme.dim,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );

    if (onTap == null) return cell;

    return GestureDetector(onTap: onTap, child: cell);
  }
}
