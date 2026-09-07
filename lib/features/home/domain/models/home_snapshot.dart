import '../../../category/domain/models/category/category.dart';
import '../../../expense/domain/models/expense/expense.dart';
import '../../../store/domain/models/store/store.dart';

/// Named snapshot class combining the streams [HomeBloc] reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value).
///
/// M5 extends the M4 expenses+categories pair with [stores], needed to
/// resolve a store name for the Recent list's meta line
/// (design_spendlens.md §10). Still ONE combined stream via
/// `combineLatest3` and a single `emit.forEach` — never parallel streams.
class HomeSnapshot {
  final List<Expense> expenses;
  final List<Category> categories;
  final List<Store> stores;

  const HomeSnapshot({
    required this.expenses,
    required this.categories,
    required this.stores,
  });
}
