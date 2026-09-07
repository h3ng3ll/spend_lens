import '../models/receipt/receipt.dart';

/// One repository per model (hive_rules.md §5) — owns [Receipt] only.
abstract interface class IReceiptLocalRepository {
  Future<List<Receipt>> getAll();

  Future<Receipt?> getById(String id);

  Future<void> save(Receipt receipt);

  Future<void> delete(String id);

  /// Reactive read — current values, then re-emits on every box mutation.
  Stream<List<Receipt>> watchAll();
}
