import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/utils/extensions/color_ext.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../category/domain/models/category/category_display_x.dart';
import '../analytics_category_breakdown_row.dart';
import 'analytics_category_donut.dart';
import 'analytics_donut_legend_row.dart';

/// The donut + legend card (`SpendLens Prototype.dc.html`: a 112px donut
/// and a tappable legend in one `display:flex;gap:20px` row).
///
/// The design shows at most FIVE legend entries — the top four categories
/// by spend plus an "Other" bucket holding every remaining category
/// (`catTotals.slice(0, 4)` then `other = 100 - sum(pcts)`). That rollup is
/// what keeps the ring readable: a user with fifteen categories would
/// otherwise get fifteen unreadable slivers and a legend taller than the
/// screen.
///
/// Selection is owned by the parent, so this widget stays stateless and the
/// selected index survives the rebuild that a bloc emission triggers.
class AnalyticsCategoryDonutCard extends StatelessWidget {
  /// Every category with spend this period, already sorted by amount
  /// descending.
  final List<AnalyticsCategoryBreakdownRow> rows;

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const AnalyticsCategoryDonutCard({
    super.key,
    required this.rows,
    required this.selectedIndex,
    required this.onSelect,
  });

  /// The design's `catTotals.slice(0, 4)` — four named slices, then
  /// everything else rolls into "Other".
  static const int kNamedSliceCount = 4;

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);
    final scheme = AppColorScheme.of(context);

    final named = rows.take(kNamedSliceCount).toList();
    final remainder = rows.skip(kNamedSliceCount).toList();

    final names = [for (final row in named) row.category.displayName(lo)];
    final colors = [
      for (final row in named) ColorExtension.fromHex(row.category.colorHex),
    ];
    final shares = [for (final row in named) row.sharePercent / 100.0];

    if (remainder.isNotEmpty) {
      // "Other" is summed from the real remaining rows rather than taken as
      // `100 - sum(named)`: the named shares are each rounded for display,
      // so the subtraction drifts by a point or two and the ring stops
      // closing exactly.
      final otherShare = remainder.fold<double>(
        0.0,
        (sum, row) => sum + row.sharePercent / 100.0,
      );
      names.add(lo.catOther);
      colors.add(scheme.dim);
      shares.add(otherShare);
    }

    final safeIndex = selectedIndex.clamp(0, names.length - 1);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      child: Row(
        spacing: 20.0,
        children: [
          AnalyticsCategoryDonut(
            shares: shares,
            colors: colors,
            selectedIndex: safeIndex,
            selectedPercent: (shares[safeIndex] * 100).round(),
            selectedName: names[safeIndex],
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 4.0,
              children: [
                for (var i = 0; i < names.length; i++)
                  AnalyticsDonutLegendRow(
                    color: colors[i],
                    name: names[i],
                    percent: (shares[i] * 100).round(),
                    isSelected: i == safeIndex,
                    onTap: () => onSelect(i),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
