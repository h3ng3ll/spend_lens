import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/category_dot.dart';

/// One tappable legend row beside the donut (`SpendLens Prototype.dc.html`'s
/// `mCats` `sc-for`: dot + name + right-aligned percent, with `c.pick`
/// selecting that slice and `c.rowStyle` highlighting the selected one).
///
/// Tapping is the ONLY way to change which slice the donut highlights and
/// which category its centre reports, so the row is a real control, not
/// decoration — hence a genuine [InkWell] with the row's own rounded
/// hit-target rather than a bare `GestureDetector`.
class AnalyticsDonutLegendRow extends StatelessWidget {
  final Color color;
  final String name;

  /// Already-rounded share of the period total.
  final int percent;

  final bool isSelected;
  final VoidCallback onTap;

  const AnalyticsDonutLegendRow({
    super.key,
    required this.color,
    required this.name,
    required this.percent,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: AppContainer(
        color: isSelected ? scheme.field : null,
        borderRadius: BorderRadius.circular(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Row(
          spacing: 8.0,
          children: [
            CategoryDot(color: color),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.subhead15.copyWith(
                  color: scheme.ink,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            Text(
              '$percent%',
              style: textTheme.subhead15.copyWith(
                color: scheme.sec,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
