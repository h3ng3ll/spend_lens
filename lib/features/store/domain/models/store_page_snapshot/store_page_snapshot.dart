import '../../../../expense/domain/models/expense/expense.dart';
import '../store/store.dart';

/// Named snapshot class combining the streams [StorePageBloc] reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value).
///
/// Per-store aggregates (visit count, total spent this month, product count)
/// are deliberately NOT stored here or in any bloc state — they are derived
/// as plain functions over this snapshot in the widget layer (BLoC rule A3.1
/// — no `filteredX`/derived fields in state).
class StorePageSnapshot {
  final List<Store> stores;
  final List<Expense> expenses;

  const StorePageSnapshot({required this.stores, required this.expenses});
}
