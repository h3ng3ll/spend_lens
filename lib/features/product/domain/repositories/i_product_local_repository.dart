import '../models/product/product.dart';

/// One repository per model (hive_rules.md §5) — owns [Product] only.
abstract interface class IProductLocalRepository {
  Future<List<Product>> getAll();

  Future<Product?> getById(String id);

  /// Persists [product].
  ///
  /// [markPending] stamps `syncStatus` as `pendingCreate`/`pendingUpdate` so
  /// the sync engine picks the row up. It defaults to true so ordinary app
  /// writes are queued for sync WITHOUT every call site remembering to say
  /// so — the sync engine itself passes false when writing rows that came
  /// FROM the server, which must not be echoed back.
  Future<void> save(Product product, {bool markPending});

  /// Soft-deletes: stamps `deletedAt` and `pendingDelete` rather than
  /// dropping the row, so the deletion can propagate to other devices.
  /// Reads (`getAll`, `getById`, `watchAll`) hide tombstoned rows.
  Future<void> delete(String id);

  /// HARD delete, local only — drops the row with NO tombstone.
  ///
  /// Distinct from [delete], which soft-deletes so the removal propagates.
  /// Used to retire a published tombstone, and to discard a local copy the
  /// server already holds. Never for a row with unpublished work.
  Future<void> deleteLocalOnly(String id);

  /// Every row INCLUDING tombstones. For the sync engine only — screens must
  /// use [getAll], which hides deleted rows.
  Future<List<Product>> getAllIncludingDeleted();

  /// Rows whose `syncStatus` is not `synced`. Drives the push pass.
  Future<List<Product>> getPending();

  /// Batch persist, same [markPending] contract as [save]. Used by the sync
  /// engine's pull pass to land a page of server rows in one box write.
  Future<void> saveAll(List<Product> items, {bool markPending});

  /// Reactive read — current values, then re-emits on every box mutation.
  Stream<List<Product>> watchAll();
}
