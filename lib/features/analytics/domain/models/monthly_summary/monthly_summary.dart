import 'category_share.dart';

/// The analytics calculator's full output for one calendar month
/// (design_spendlens.md §10/§11 — "monthly totals, previous-month
/// comparison, % change, average, per-category share and count,
/// cash-vs-receipt split"). Plain value class computed fresh from Expenses
/// on every call — never stored as the source of truth (spec §49) and never
/// bloc state.
class MonthlySummary {
  final int year;

  /// 0-based month (0 = January … 11 = December), matching
  /// [SelectedPeriod.month]'s numbering.
  final int month;

  final String currencyCode;

  /// Total spent this month, in [currencyCode] only (currency guard —
  /// mismatched-currency expenses are excluded, never combined).
  final double total;

  final int purchaseCount;

  final double averagePurchase;

  /// Fraction (0.0–1.0) of [purchaseCount] recorded as a cash entry.
  final double cashShare;

  final List<CategoryShare> categoryShares;

  /// Previous month's total in the SAME currency, or null when there is no
  /// prior-month data to compare against (never fabricated as zero).
  final double? previousMonthTotal;

  const MonthlySummary({
    required this.year,
    required this.month,
    required this.currencyCode,
    required this.total,
    required this.purchaseCount,
    required this.averagePurchase,
    required this.cashShare,
    required this.categoryShares,
    required this.previousMonthTotal,
  });

  /// Percent change vs [previousMonthTotal], or null when there is nothing
  /// to compare against. Positive means spending ROSE; negative means it
  /// FELL — callers map the sign to `trendUp`/`trendDown`, never `error`
  /// (design_spendlens.md §4.2).
  double? get percentChangeVsPreviousMonth {
    final previous = previousMonthTotal;
    if (previous == null || previous == 0) {
      return null;
    }
    return ((total - previous) / previous) * 100;
  }
}
