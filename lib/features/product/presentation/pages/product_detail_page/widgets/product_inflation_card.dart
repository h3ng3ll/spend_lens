import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/section_label.dart';
import '../../../../../analytics/domain/models/price_history/price_history_summary.dart';
import '../../../../../analytics/presentation/pages/price_history_page/month_short_label.dart';
import '../../../../../analytics/presentation/pages/price_history_page/widgets/price_history_change_label.dart';
import '../../../../../analytics/presentation/pages/price_history_page/widgets/price_history_chart.dart';

/// The inflation view — how this product's price moved over time.
///
/// Embeds the analytics slice's existing chart widgets rather than redrawing
/// them: `PriceHistoryChart` and `PriceHistoryChangeLabel` take plain data,
/// so reusing them keeps one implementation of the bars and one of the
/// percent-change wording. The math is `buildPriceHistory`/`percentChange`,
/// called in the widget layer exactly as `PriceHistoryBody` calls it.
class ProductInflationCard extends StatelessWidget {
  final PriceHistorySummary summary;
  final VoidCallback onOpenFullHistory;

  const ProductInflationCard({
    super.key,
    required this.summary,
    required this.onOpenFullHistory,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    final percentChange = summary.percentChangeFirstToLast;
    final monthLabels = summary.points
        .map((point) => monthShortLabel(lo, point.periodStart.month))
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.0,
      children: [
        SectionLabel(text: lo.priceHistoryTitle),
        GestureDetector(
          onTap: onOpenFullHistory,
          behavior: HitTestBehavior.opaque,
          child: AppSectionCard(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.0,
              children: [
                if (percentChange != null)
                  PriceHistoryChangeLabel(percentChange: percentChange),
                PriceHistoryChart(
                  points: summary.points,
                  monthLabels: monthLabels,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
