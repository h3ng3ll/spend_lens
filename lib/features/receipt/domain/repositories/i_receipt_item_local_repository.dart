import '../models/receipt_item/receipt_item.dart';

/// One repository per model (hive_rules.md §5) — owns [ReceiptItem] only.
abstract interface class IReceiptItemLocalRepository {
  Future<List<ReceiptItem>> getAll();

  Future<ReceiptItem?> getById(String id);

  Future<void> save(ReceiptItem item);

  Future<void> delete(String id);

  /// Reactive read — current values, then re-emits on every box mutation.
  Stream<List<ReceiptItem>> watchAll();

  /// Reactive read scoped to the items of one receipt.
  Stream<List<ReceiptItem>> watchByReceiptId(List<String> itemIds);
}
