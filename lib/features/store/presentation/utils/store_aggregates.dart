/// Pure per-store aggregate functions computed over a
/// `StorePageSnapshot`/`StoreDetailSnapshot` combined stream value.
///
/// Deliberately NOT bloc state (BLoC rule A3.1 — no `filteredX`/derived
/// fields in state or state-extension getters): every number here is
/// recomputed from the snapshot on every build, never stored.
library;

import '../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../expense/domain/models/expense/expense.dart';

/// All expenses linked to [storeId] via `expense.storeId`.
List<Expense> expensesForStore(List<Expense> expenses, String storeId) {
  return expenses.where((expense) => expense.storeId == storeId).toList();
}

/// The number of DISTINCT products ever recorded at [storeId].
///
/// [PriceObservation] is the only entity joining a product to a store, so it
/// is the only thing this can be counted from. Distinct by `productId`
/// because one product bought on five visits is one product, not five, and
/// tombstoned rows are excluded — the same predicate `ProductsHereCard` uses,
/// so the list's number and the detail page's list can never disagree.
int productCountForStore(
  List<PriceObservation> observations,
  String storeId,
) {
  final productIds = <String>{};
  for (final observation in observations) {
    if (observation.storeId != storeId) continue;
    if (observation.deletedAt != null) continue;
    productIds.add(observation.productId);
  }
  return productIds.length;
}

/// The number of distinct calendar days [storeExpenses] were incurred on —
/// a "visit" is one shopping trip, not one line item.
int visitCount(List<Expense> storeExpenses) {
  final days = <String>{};
  for (final expense in storeExpenses) {
    final occurredAt = expense.occurredAt;
    days.add('${occurredAt.year}-${occurredAt.month}-${occurredAt.day}');
  }
  return days.length;
}

/// Total spent at this store during the CURRENT calendar month, in the
/// store's own dominant currency (design_spendlens.md "Conflicts resolved" →
/// Currency: never silently combine currencies). Returns null when there is
/// nothing to sum this month.
({double amount, String currencyCode})? totalSpentThisMonth(
  List<Expense> storeExpenses,
  DateTime now,
) {
  final thisMonth = storeExpenses.where(
    (expense) =>
        expense.occurredAt.year == now.year &&
        expense.occurredAt.month == now.month,
  );

  if (thisMonth.isEmpty) return null;

  final currencyCode = _dominantCurrency(thisMonth.toList());
  final total = thisMonth
      .where((expense) => expense.currencyCode == currencyCode)
      .fold<double>(0.0, (sum, expense) => sum + expense.amount);

  return (amount: total, currencyCode: currencyCode);
}

/// All-time total spent at this store, in the store's dominant currency.
({double amount, String currencyCode})? totalSpentAllTime(
  List<Expense> storeExpenses,
) {
  if (storeExpenses.isEmpty) return null;

  final currencyCode = _dominantCurrency(storeExpenses);
  final total = storeExpenses
      .where((expense) => expense.currencyCode == currencyCode)
      .fold<double>(0.0, (sum, expense) => sum + expense.amount);

  return (amount: total, currencyCode: currencyCode);
}

/// The most-frequently-occurring currency code among [storeExpenses] — the
/// currency this store's totals are displayed in, per the "never silently
/// combine currencies" rule.
String _dominantCurrency(List<Expense> storeExpenses) {
  final counts = <String, int>{};
  for (final expense in storeExpenses) {
    counts[expense.currencyCode] = (counts[expense.currencyCode] ?? 0) + 1;
  }

  var bestCurrency = storeExpenses.first.currencyCode;
  var bestCount = 0;
  for (final entry in counts.entries) {
    if (entry.value > bestCount) {
      bestCount = entry.value;
      bestCurrency = entry.key;
    }
  }
  return bestCurrency;
}

/// Formats an amount with 2 decimal places — display-only, no locale
/// grouping (amounts here are small manual-entry figures, not large sums
/// that would need thousands separators).
String formatAmount(double amount) => amount.toStringAsFixed(2);
