import '../../../category/domain/models/category/category.dart';
import '../../../expense/domain/models/expense/expense.dart';
import '../../../store/domain/models/store/store.dart';

/// Named snapshot class combining the streams [HistoryBloc] reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value, following the same pattern as `HomeSnapshot`).
///
/// M5 needs Categories (to resolve a record's display name/color) and
/// Stores (for the meta line) alongside the raw Expense list. Filtering by
/// search text / record-type is a pure UI-layer computation over
/// [expenses] — never a `filteredX` field here (BLoC rule A3.1).
class HistorySnapshot {
  final List<Expense> expenses;
  final List<Category> categories;
  final List<Store> stores;

  const HistorySnapshot({
    required this.expenses,
    required this.categories,
    required this.stores,
  });
}
