import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/utils/selected_period.dart';
import '../../../../../../core/widgets/app_empty_state.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../category/domain/models/category/category_display_x.dart';
import '../../../bloc/analytics_bloc/analytics_bloc.dart';
import '../analytics_view_helpers.dart';
import 'analytics_cash_receipt_split_card.dart';
import 'analytics_category_breakdown_card.dart';
import 'analytics_header.dart';
import 'analytics_insights_card.dart';
import 'analytics_period_pill.dart';
import 'analytics_stat_row.dart';
import 'analytics_stat_tile.dart';
import 'analytics_total_hero.dart';

/// Populated / empty presentation for `AnalyticsPage`
/// (`SpendLens Prototype.dc.html`, `data-screen-label="Analytics"`).
///
/// Renders the FULL visual layout against whatever `AnalyticsBloc` streams
/// today (Expenses + Categories); the M6 deterministic calculator and
/// parameterized insight generator are NOT built here — every value on this
/// screen is a simple, honest aggregate (sum/count/average/share) computed
/// directly from the raw list via the pure functions in
/// `analytics_view_helpers.dart` (design_spendlens.md §10).
class AnalyticsBody extends StatelessWidget {
  final AnalyticsState state;
  final SelectedPeriod selectedPeriod;
  final String currencyCode;
  final VoidCallback onOpenPeriod;

  const AnalyticsBody({
    super.key,
    required this.state,
    required this.selectedPeriod,
    required this.currencyCode,
    required this.onOpenPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    final snapshot = state.snapshot;
    final allExpenses = snapshot?.expenses ?? const [];
    final categories = snapshot?.categories ?? const [];

    final periodExpenses = expensesInPeriod(allExpenses, selectedPeriod);
    final periodLabel =
        '${_fullMonthLabels(lo)[selectedPeriod.month]} ${selectedPeriod.year}';

    if (periodExpenses.isEmpty) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0,
          children: [
            HorizontalPadding(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16.0,
                children: [
                  const AnalyticsHeader(),
                  AnalyticsPeriodPill(label: periodLabel, onTap: onOpenPeriod),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: HorizontalPadding(
                child: AppEmptyState(
                  icon: AppIcons.emptyReceipt,
                  title: lo.homeNoExpensesTitle,
                  body: lo.homeNoExpensesBody,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final total = totalAmount(periodExpenses);
    final average = averageAmount(periodExpenses);
    final cashPercent = (cashShare(periodExpenses) * 100).round();
    final rows = categoryBreakdown(periodExpenses, categories);
    final top = topCategory(periodExpenses, categories);

    final insights = <String>[
      if (top != null && top.sharePercent > 0)
        lo.insA1(top.category.displayName(lo), top.sharePercent.round()),
    ];

    return SingleChildScrollView(
      child: HorizontalPadding(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              const AnalyticsHeader(),
              AnalyticsPeriodPill(label: periodLabel, onTap: onOpenPeriod),
              AnalyticsTotalHero(
                totalText: total.round().toString(),
                currencyCode: currencyCode,
              ),
              AnalyticsStatRow(
                average: AnalyticsStatTile(
                  label: lo.average,
                  value: average.round().toString(),
                  caption: currencyCode,
                ),
                purchases: AnalyticsStatTile(
                  label: lo.purchases,
                  value: periodExpenses.length.toString(),
                  caption: lo.thisMonth,
                ),
                cash: AnalyticsStatTile(
                  label: lo.cash,
                  value: '$cashPercent%',
                  caption: lo.ofSpending,
                ),
              ),
              AnalyticsCategoryBreakdownCard(
                rows: rows,
                currencyCode: currencyCode,
              ),
              AnalyticsCashReceiptSplitCard(cashSharePercent: cashPercent),
              AnalyticsInsightsCard(insights: insights),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _fullMonthLabels(AppLocalizations lo) => [
    lo.months0,
    lo.months1,
    lo.months2,
    lo.months3,
    lo.months4,
    lo.months5,
    lo.months6,
    lo.months7,
    lo.months8,
    lo.months9,
    lo.months10,
    lo.months11,
  ];
}
