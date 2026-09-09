import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/utils/selected_period.dart';
import '../../../../../../core/widgets/app_empty_state.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../category/domain/models/category/category.dart';
import '../../../../domain/calculator/analytics_calculator.dart';
import '../../../../domain/insights/analytics_insight_generator.dart';
import '../../../../domain/models/monthly_summary/monthly_summary.dart';
import '../../../bloc/analytics_bloc/analytics_bloc.dart';
import '../analytics_category_breakdown_row.dart';
import '../analytics_insight_resolver.dart';
import '../analytics_view_helpers.dart';
import 'analytics_cash_receipt_split_card.dart';
import 'analytics_category_donut_card.dart';
import 'analytics_header.dart';
import 'analytics_insights_card.dart';
import 'analytics_period_pill.dart';
import 'analytics_stat_row.dart';
import 'analytics_stat_tile.dart';
import 'analytics_total_delta.dart';
import 'analytics_total_hero.dart';

/// Populated / empty presentation for `AnalyticsPage`
/// (`SpendLens Prototype.dc.html`, `data-screen-label="Analytics"`).
///
/// M6: every figure is now produced by the deterministic engine in
/// `features/analytics/domain/` — `buildMonthlySummary` (totals,
/// previous-month comparison, % change, average, per-category share/count,
/// cash-vs-receipt split) and `generateInsights` (ARB key + params pairs,
/// resolved to strings only here via `analytics_insight_resolver.dart`).
/// `analytics_view_helpers.dart`'s remaining functions (`expensesInPeriod`,
/// `minSelectableMonth`) are still used for period-sheet plumbing that is
/// genuinely UI-local, not analytics math.
class AnalyticsBody extends StatelessWidget {
  final AnalyticsState state;
  final SelectedPeriod selectedPeriod;
  final String currencyCode;
  final VoidCallback onOpenPeriod;

  /// Which donut slice is highlighted. Owned by the page, not this widget,
  /// so it survives the rebuild each bloc emission causes.
  final int selectedCategoryIndex;
  final ValueChanged<int> onSelectCategory;

  const AnalyticsBody({
    super.key,
    required this.state,
    required this.selectedPeriod,
    required this.currencyCode,
    required this.onOpenPeriod,
    required this.selectedCategoryIndex,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    final snapshot = state.snapshot;
    final allExpenses = snapshot?.expenses ?? const [];
    final categories = snapshot?.categories ?? const [];

    final periodExpenses = expensesInPeriod(allExpenses, selectedPeriod);
    final monthLabels = _fullMonthLabels(lo);
    final periodLabel =
        '${monthLabels[selectedPeriod.month]} ${selectedPeriod.year}';

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

    final summary = buildMonthlySummary(
      allExpenses: allExpenses,
      categories: categories,
      year: selectedPeriod.year,
      month: selectedPeriod.month,
      displayCurrencyCode: currencyCode,
    );

    final isCurrentMonth = selectedPeriod == SelectedPeriod.now();
    final topShare = summary.categoryShares.isEmpty
        ? null
        : summary.categoryShares.first;

    final insights = topShare == null
        ? const <String>[]
        : generateInsights(
                summary: summary,
                isCurrentMonth: isCurrentMonth,
                topCategoryId: topShare.categoryId,
                previousMonthAverageDisplay: null,
                currentMonthAverageDisplay: summary.averagePurchase
                    .round()
                    .toString(),
              )
              .map(
                (insight) => resolveAnalyticsInsight(lo, categories, insight),
              )
              .toList();

    final rows = _resolveCategoryRows(summary, categories);
    final percentChange = summary.percentChangeVsPreviousMonth;

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
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.0,
                children: [
                  AnalyticsTotalHero(
                    totalText: summary.total.round().toString(),
                    currencyCode: currencyCode,
                  ),
                  if (percentChange != null)
                    AnalyticsTotalDelta(
                      percentChange: percentChange,
                      previousMonthLabel:
                          monthLabels[selectedPeriod.month == 0
                              ? 11
                              : selectedPeriod.month - 1],
                    ),
                ],
              ),
              AnalyticsStatRow(
                average: AnalyticsStatTile(
                  label: lo.average,
                  value: summary.averagePurchase.round().toString(),
                  caption: currencyCode,
                ),
                purchases: AnalyticsStatTile(
                  label: lo.purchases,
                  value: summary.purchaseCount.toString(),
                  caption: lo.thisMonth,
                ),
                cash: AnalyticsStatTile(
                  label: lo.cash,
                  value: '${(summary.cashShare * 100).round()}%',
                  caption: lo.ofSpending,
                ),
              ),
              if (rows.isNotEmpty)
                AnalyticsCategoryDonutCard(
                  rows: rows,
                  selectedIndex: selectedCategoryIndex,
                  onSelect: onSelectCategory,
                ),
              AnalyticsCashReceiptSplitCard(
                cashSharePercent: (summary.cashShare * 100).round(),
              ),
              AnalyticsInsightsCard(insights: insights),
            ],
          ),
        ),
      ),
    );
  }

  List<AnalyticsCategoryBreakdownRow> _resolveCategoryRows(
    MonthlySummary summary,
    List<Category> categories,
  ) {
    final rows = <AnalyticsCategoryBreakdownRow>[];
    for (final share in summary.categoryShares) {
      final category = _findCategory(categories, share.categoryId);
      if (category == null) continue;
      rows.add(
        AnalyticsCategoryBreakdownRow(
          category: category,
          amount: share.amount,
          sharePercent: share.sharePercent,
        ),
      );
    }
    return rows;
  }

  Category? _findCategory(List<Category> categories, String categoryId) {
    for (final category in categories) {
      if (category.id == categoryId) return category;
    }
    return null;
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
