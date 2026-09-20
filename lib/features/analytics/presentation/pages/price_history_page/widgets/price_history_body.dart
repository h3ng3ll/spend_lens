import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../domain/models/price_history/price_history_summary.dart';
import '../month_short_label.dart';
import 'price_history_change_label.dart';
import 'price_history_chart.dart';

/// Populated presentation for `PriceHistoryPage` — product name, the overall
/// first-to-last change line, and the v1 bar chart
/// (design_spendlens.md §10/§11, spec §54–57).
class PriceHistoryBody extends StatelessWidget {
  final String productDisplayName;
  final PriceHistorySummary summary;

  const PriceHistoryBody({
    super.key,
    required this.productDisplayName,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final percentChange = summary.percentChangeFirstToLast;
    final monthLabels = summary.points
        .map((point) => monthShortLabel(lo, point.periodStart.month))
        .toList();

    return SingleChildScrollView(
      child: HorizontalPadding(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              Text(
                productDisplayName,
                style: textTheme.screenTitle28.copyWith(color: scheme.ink),
              ),
              AppSectionCard(
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
            ],
          ),
        ),
      ),
    );
  }
}
