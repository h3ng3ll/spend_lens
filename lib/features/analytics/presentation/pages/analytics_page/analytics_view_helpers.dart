import '../../../../expense/domain/models/expense/expense.dart';
import '../../../../../core/utils/selected_period.dart';

/// UI-local view helpers for `AnalyticsPage` and `PeriodSheet` plumbing —
/// genuinely presentation-layer concerns, never analytics MATH.
///
/// M6 superseded the sums/averages/category-breakdown/cash-share/top-category
/// functions this file used to hold with the real deterministic engine in
/// `features/analytics/domain/` (`analytics_calculator.dart`,
/// `analytics_insight_generator.dart`) — see design_spendlens.md §10/§11.
/// What remains here is period FILTERING and the period-sheet's selectable
/// range, which are UI-local concerns the calculator has no reason to own.

/// Expenses whose `occurredAt` falls within [period].
List<Expense> expensesInPeriod(List<Expense> expenses, SelectedPeriod period) {
  return expenses.where((e) => period.contains(e.occurredAt)).toList();
}

/// Resolves the earliest calendar month with a recorded expense, expressed
/// as a 0-based month index within [SelectedPeriod.now]'s year, clamped to
/// the current month.
///
/// Falls back to the current month when there is no expense history yet —
/// never hardcoding a fixed earlier month (design_spendlens.md: "do NOT
/// hardcode Aug/Sep like the prototype's fake data").
int minSelectableMonth(List<Expense> allExpenses) {
  final now = SelectedPeriod.now();
  if (allExpenses.isEmpty) {
    return now.month;
  }

  final sameYearMonths = allExpenses
      .where((e) => e.occurredAt.year == now.year)
      .map((e) => e.occurredAt.month - 1);

  if (sameYearMonths.isEmpty) {
    return now.month;
  }

  final earliest = sameYearMonths.reduce((a, b) => a < b ? a : b);
  return earliest.clamp(0, now.month);
}
