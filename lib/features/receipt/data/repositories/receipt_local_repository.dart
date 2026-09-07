import '../../../../core/hive/hive_database.dart';
import '../../domain/models/receipt/receipt.dart';
import '../../domain/repositories/i_receipt_local_repository.dart';

/// Hive-backed [IReceiptLocalRepository]. Box name is plural lowercase
/// (`'receipts'`) per hive_rules.md §5; never cached — every operation
/// re-fetches via the shared [HiveDatabase] helper.
class ReceiptLocalRepository implements IReceiptLocalRepository {
  static const _boxName = 'receipts';

  final HiveDatabase _hiveDatabase;

  const ReceiptLocalRepository(this._hiveDatabase);

  @override
  Future<List<Receipt>> getAll() async {
    final box = await _hiveDatabase.getBox<Receipt>(_boxName);
    return box.values.toList();
  }

  @override
  Future<Receipt?> getById(String id) async {
    final box = await _hiveDatabase.getBox<Receipt>(_boxName);
    return box.get(id);
  }

  @override
  Future<void> save(Receipt receipt) async {
    final box = await _hiveDatabase.getBox<Receipt>(_boxName);
    await box.put(receipt.id, receipt);
  }

  @override
  Future<void> delete(String id) async {
    final box = await _hiveDatabase.getBox<Receipt>(_boxName);
    await box.delete(id);
  }

  @override
  Stream<List<Receipt>> watchAll() async* {
    final box = await _hiveDatabase.getBox<Receipt>(_boxName);
    yield box.values.toList();
    yield* box.watch().map((_) => box.values.toList());
  }
}
