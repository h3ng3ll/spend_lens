import '../../../../category/domain/models/category/category.dart';
import '../../../../expense/domain/models/expense/e_expense_source.dart';
import '../../../../expense/domain/models/expense/expense.dart';
import '../../../../../core/utils/selected_period.dart';

/// Pure view functions for `AnalyticsBody` and its children.
///
/// These are NOT bloc state and NEVER become one (BLoC rule A3.1 — no
/// `filteredX`/`sortedX` fields in `AnalyticsState` or as a state-extension
/// getter). The bloc streams the raw expense/category lists; every
/// period-filtered, summed, sorted or shared-percentage view is recomputed
/// here, at build time, from that raw snapshot plus the screen's local
/// [SelectedPeriod] selection.
///
/// M5 scope only: sums, counts, averages and percentage shares computed
/// directly from the raw list with plain functions. The M6 deterministic
/// calculator + parameterized insight generator are NOT built here — see
/// design_spendlens.md §10.

/// One row of the per-category breakdown, already resolved to a display
/// name/color/amount/share — a plain return value, never stored as state.
class AnalyticsCategoryBreakdownRow {
  final Category category;
  final double amount;
  final double sharePercent;

  const AnalyticsCategoryBreakdownRow({
    required this.category,
    required this.amount,
    required this.sharePercent,
  });
}

/// Expenses whose `occurredAt` falls within [period].
List<Expense> expensesInPeriod(List<Expense> expenses, SelectedPeriod period) {
  return expenses.where((e) => period.contains(e.occurredAt)).toList();
}

/// Sum of `amount` across [expenses]. Currencies are never mixed (spec §52)
/// — the caller is responsible for only passing expenses in the app's
/// single display currency, which M5 satisfies because manual entry never
/// produces a second currency yet.
double totalAmount(List<Expense> expenses) =>
    expenses.fold(0.0, (sum, e) => sum + e.amount);

/// Average purchase amount, or 0 when there are no expenses — never a
/// divide-by-zero.
double averageAmount(List<Expense> expenses) =>
    expenses.isEmpty ? 0.0 : totalAmount(expenses) / expenses.length;

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

/// Per-category breakdown for [expenses] against [categories], sorted by
/// amount descending. Categories with zero spend in the period are omitted
/// — nothing to show a share bar for.
List<AnalyticsCategoryBreakdownRow> categoryBreakdown(
  List<Expense> expenses,
  List<Category> categories,
) {
  final total = totalAmount(expenses);
  final byCategory = <String, double>{};

  for (final expense in expenses) {
    byCategory[expense.categoryId] =
        (byCategory[expense.categoryId] ?? 0.0) + expense.amount;
  }

  final rows = <AnalyticsCategoryBreakdownRow>[];
  for (final category in categories) {
    final amount = byCategory[category.id];
    if (amount == null || amount <= 0) {
      continue;
    }
    rows.add(
      AnalyticsCategoryBreakdownRow(
        category: category,
        amount: amount,
        sharePercent: total > 0 ? (amount / total) * 100 : 0.0,
      ),
    );
  }

  rows.sort((a, b) => b.amount.compareTo(a.amount));
  return rows;
}

/// Fraction (0.0–1.0) of [expenses] recorded from a cash entry rather than a
/// scanned receipt. M5 has no receipt-sourced expenses yet (scanning is
/// M7/M8), so this is expected to read 1.0 — that is correct, not faked
/// data (design_spendlens.md, Analytics design requirements).
double cashShare(List<Expense> expenses) {
  if (expenses.isEmpty) {
    return 1.0;
  }
  final cashCount = expenses
      .where((e) => e.source == EExpenseSource.cash)
      .length;
  return cashCount / expenses.length;
}

/// The single category with the largest share of [expenses], or `null` when
/// there is nothing to report — never a fabricated top category.
AnalyticsCategoryBreakdownRow? topCategory(
  List<Expense> expenses,
  List<Category> categories,
) {
  final rows = categoryBreakdown(expenses, categories);
  return rows.isEmpty ? null : rows.first;
}
