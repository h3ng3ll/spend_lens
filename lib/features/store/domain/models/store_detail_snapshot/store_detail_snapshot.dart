import '../../../../expense/domain/models/expense/expense.dart';
import '../store/store.dart';

/// Named snapshot class combining the streams [StoreDetailBloc] reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value).
///
/// [expenses] is the FULL expense list, not pre-filtered to this store — the
/// "expenses for this store" narrowing is a plain function computed in the
/// widget layer (BLoC rule A3.1 — no `filteredX` state), so the same
/// snapshot shape stays reusable if a later milestone needs the unfiltered
/// list too.
class StoreDetailSnapshot {
  final Store? store;
  final List<Expense> expenses;

  const StoreDetailSnapshot({required this.store, required this.expenses});
}
