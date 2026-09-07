import '../models/expense/expense.dart';

/// One repository per model (hive_rules.md §5) — owns [Expense] only.
abstract interface class IExpenseLocalRepository {
  Future<List<Expense>> getAll();

  Future<Expense?> getById(String id);

  Future<void> save(Expense expense);

  Future<void> delete(String id);

  /// Reactive read — current values, then re-emits on every box mutation.
  Stream<List<Expense>> watchAll();
}
