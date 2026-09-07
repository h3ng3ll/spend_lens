import '../../../../core/hive/hive_database.dart';
import '../../domain/models/expense/expense.dart';
import '../../domain/repositories/i_expense_local_repository.dart';

/// Hive-backed [IExpenseLocalRepository]. Box name is plural lowercase
/// (`'expenses'`) per hive_rules.md §5; never cached — every operation
/// re-fetches via the shared [HiveDatabase] helper.
class ExpenseLocalRepository implements IExpenseLocalRepository {
  static const _boxName = 'expenses';

  final HiveDatabase _hiveDatabase;

  const ExpenseLocalRepository(this._hiveDatabase);

  @override
  Future<List<Expense>> getAll() async {
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
    return box.values.toList();
  }

  @override
  Future<Expense?> getById(String id) async {
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
    return box.get(id);
  }

  @override
  Future<void> save(Expense expense) async {
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
    await box.put(expense.id, expense);
  }

  @override
  Future<void> delete(String id) async {
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
    await box.delete(id);
  }

  @override
  Stream<List<Expense>> watchAll() async* {
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
    yield box.values.toList();
    yield* box.watch().map((_) => box.values.toList());
  }
}
