import '../../../category/domain/models/category/category.dart';
import '../../../expense/domain/models/expense/expense.dart';
import '../../../store/domain/models/store/store.dart';

/// Named snapshot class combining the streams [AnalyticsBloc] reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value), following the exact shape `HomeSnapshot` established.
///
/// M5 combines Expenses + Categories: enough to render the real per-category
/// breakdown, cash-vs-receipts split and simple honest insights against
/// whatever the current bloc provides. The deterministic analytics
/// calculator + parameterized insight generator are M6 — this class is not
/// where that engine lives; it only carries the raw source lists the M5
/// screen computes simple aggregates FROM via plain functions (never stored
/// as derived bloc state).
class AnalyticsSnapshot {
  final List<Expense> expenses;
  final List<Category> categories;

  /// Stores resolve each expense's `storeId` to a display name in the
  /// selected-category drill-down card. Without this third stream the card
  /// could only ever show "No store" for every row.
  final List<Store> stores;

  const AnalyticsSnapshot({
    required this.expenses,
    required this.categories,
    required this.stores,
  });
}
