import '../models/receipt_item/receipt_item.dart';

/// One repository per model (hive_rules.md §5) — owns [ReceiptItem] only.
abstract interface class IReceiptItemLocalRepository {
  Future<List<ReceiptItem>> getAll();

  Future<ReceiptItem?> getById(String id);

  /// Persists [item].
  ///
  /// [markPending] stamps `syncStatus` as `pendingCreate`/`pendingUpdate` so
  /// the sync engine picks the row up. It defaults to true so ordinary app
  /// writes are queued for sync WITHOUT every call site remembering to say
  /// so — the sync engine itself passes false when writing rows that came
  /// FROM the server, which must not be echoed back.
  Future<void> save(ReceiptItem item, {bool markPending});

  /// Soft-deletes: stamps `deletedAt` and `pendingDelete` rather than
  /// dropping the row, so the deletion can propagate to other devices.
  /// Reads (`getAll`, `getById`, `watchAll`) hide tombstoned rows.
  Future<void> delete(String id);

/// HARD delete, local only — drops the row with NO tombstone.
  ///
  /// Distinct from [delete], which soft-deletes so the removal propagates.
  /// This is for discarding a local copy the server already holds (the
  /// sign-out cleanup); it must never be used on a row that is not
  /// `synced`, because nothing else has that data.
  Future<void> deleteLocalOnly(String id);

  /// Every row INCLUDING tombstones. For the sync engine only — screens must
  /// use [getAll], which hides deleted rows.
  Future<List<ReceiptItem>> getAllIncludingDeleted();

  /// Rows whose `syncStatus` is not `synced`. Drives the push pass.
  Future<List<ReceiptItem>> getPending();

  /// Batch persist, same [markPending] contract as [save]. Used by the sync
  /// engine's pull pass to land a page of server rows in one box write.
  Future<void> saveAll(List<ReceiptItem> items, {bool markPending});

  /// Reactive read — current values, then re-emits on every box mutation.
  Stream<List<ReceiptItem>> watchAll();

  /// Reactive read scoped to the items of one receipt.
  Stream<List<ReceiptItem>> watchByReceiptId(List<String> itemIds);
}
