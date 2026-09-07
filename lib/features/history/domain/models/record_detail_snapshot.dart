import '../../../category/domain/models/category/category.dart';
import '../../../expense/domain/models/expense/expense.dart';
import '../../../store/domain/models/store/store.dart';

/// Named snapshot class combining the streams [RecordDetailBloc] reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value; mirrors `StoreDetailSnapshot`'s shape).
///
/// [expense] is null once the record this screen was opened for no longer
/// exists (deleted by this same screen, or from elsewhere while it was
/// still mounted) — the bloc maps that to `ERecordDetailStatus.notFound`
/// rather than treating a missing record as a failure.
class RecordDetailSnapshot {
  final Expense? expense;
  final List<Category> categories;
  final List<Store> stores;

  const RecordDetailSnapshot({
    required this.expense,
    required this.categories,
    required this.stores,
  });
}
