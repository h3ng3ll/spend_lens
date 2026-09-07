import '../../../category/domain/models/category/category.dart';
import '../../../expense/domain/models/expense/expense.dart';

/// Named snapshot class combining the streams [HomeBloc] reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value).
///
/// M4 combines Expenses + Categories only, enough to prove the reactive
/// wiring end-to-end. M6 (Analytics engine) extends this to Receipts +
/// PriceObservations once the calculator/insight generator land.
class HomeSnapshot {
  final List<Expense> expenses;
  final List<Category> categories;

  const HomeSnapshot({required this.expenses, required this.categories});
}
