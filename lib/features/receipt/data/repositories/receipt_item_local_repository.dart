import '../../../../core/hive/hive_database.dart';
import '../../domain/models/receipt_item/receipt_item.dart';
import '../../domain/repositories/i_receipt_item_local_repository.dart';

/// Hive-backed [IReceiptItemLocalRepository]. Box name is plural lowercase
/// (`'receipt_items'`) per hive_rules.md §5; never cached — every operation
/// re-fetches via the shared [HiveDatabase] helper.
class ReceiptItemLocalRepository implements IReceiptItemLocalRepository {
  static const _boxName = 'receipt_items';

  final HiveDatabase _hiveDatabase;

  const ReceiptItemLocalRepository(this._hiveDatabase);

  @override
  Future<List<ReceiptItem>> getAll() async {
    final box = await _hiveDatabase.getBox<ReceiptItem>(_boxName);
    return box.values.toList();
  }

  @override
  Future<ReceiptItem?> getById(String id) async {
    final box = await _hiveDatabase.getBox<ReceiptItem>(_boxName);
    return box.get(id);
  }

  @override
  Future<void> save(ReceiptItem item) async {
    final box = await _hiveDatabase.getBox<ReceiptItem>(_boxName);
    await box.put(item.id, item);
  }

  @override
  Future<void> delete(String id) async {
    final box = await _hiveDatabase.getBox<ReceiptItem>(_boxName);
    await box.delete(id);
  }

  @override
  Stream<List<ReceiptItem>> watchAll() async* {
    final box = await _hiveDatabase.getBox<ReceiptItem>(_boxName);
    yield box.values.toList();
    yield* box.watch().map((_) => box.values.toList());
  }

  @override
  Stream<List<ReceiptItem>> watchByReceiptId(List<String> itemIds) {
    return watchAll().map(
      (all) => all.where((item) => itemIds.contains(item.id)).toList(),
    );
  }
}
