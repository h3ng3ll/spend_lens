import '../../../../core/models/e_sync_status.dart';
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
    return box.values.where(_isVisible).toList();
  }

  @override
  Future<Receipt?> getById(String id) async {
    final box = await _hiveDatabase.getBox<Receipt>(_boxName);
    final found = box.get(id);
    return found != null && _isVisible(found) ? found : null;
  }

  @override
  Future<void> save(Receipt receipt, {bool markPending = true}) async {
    final box = await _hiveDatabase.getBox<Receipt>(_boxName);
    await box.put(receipt.id, await _stamped(box, receipt, markPending));
  }

  @override
  Future<void> saveAll(List<Receipt> items, {bool markPending = true}) async {
    final box = await _hiveDatabase.getBox<Receipt>(_boxName);
    final entries = <String, Receipt>{};
    for (final item in items) {
      entries[item.id] = await _stamped(box, item, markPending);
    }
    await box.putAll(entries);
  }

  /// SOFT delete — the row stays in the box carrying `deletedAt` plus
  /// `pendingDelete`, so the deletion can be pushed to other devices. A hard
  /// `box.delete` would leave no tombstone, and the next pull would simply
  /// re-download the row.
  @override
  Future<void> delete(String id) async {
    final box = await _hiveDatabase.getBox<Receipt>(_boxName);
    final existing = box.get(id);
    if (existing == null) return;

    final now = DateTime.now();
    await box.put(
      id,
      existing.copyWith(
        updatedAt: now,
        deletedAt: existing.deletedAt ?? now,
        syncStatus: ESyncStatus.pendingDelete,
      ),
    );
  }


  /// HARD delete, local only — removes the row from this device WITHOUT a
  /// tombstone.
  ///
  /// The opposite of [delete] and used for exactly one thing: dropping a
  /// row this device no longer needs to keep, because the server already
  /// has it (the sign-out cleanup). Using [delete] there would stamp
  /// `pendingDelete` and push a tombstone on the next sync, DESTROYING the
  /// user's cloud copy — the precise opposite of the intent.
  ///
  /// Only ever call this for a row whose `syncStatus` is `synced`. A row
  /// with unpublished local work has no copy anywhere else, and removing it
  /// loses it for good.
  @override
  Future<void> deleteLocalOnly(String id) async {
    final box = await _hiveDatabase.getBox<Receipt>(_boxName);
    await box.delete(id);
  }

  @override
  Future<List<Receipt>> getAllIncludingDeleted() async {
    final box = await _hiveDatabase.getBox<Receipt>(_boxName);
    return box.values.toList();
  }

  @override
  Future<List<Receipt>> getPending() async {
    final box = await _hiveDatabase.getBox<Receipt>(_boxName);
    return box.values
        .where((e) => e.syncStatus != ESyncStatus.synced)
        .toList();
  }

  /// Resolves the `syncStatus` a write should carry. `pendingCreate` when the
  /// box has never seen this id, `pendingUpdate` otherwise, so the push pass
  /// can tell a first upload from an edit. When [markPending] is false the
  /// entity is stored exactly as given — that is the sync engine landing
  /// server rows, which must not be echoed straight back.
  Future<Receipt> _stamped(
    dynamic box,
    Receipt entity,
    bool markPending,
  ) async {
    if (!markPending) return entity;
    final isNew = box.get(entity.id) == null;
    return entity.copyWith(
      syncStatus:
          isNew ? ESyncStatus.pendingCreate : ESyncStatus.pendingUpdate,
    );
  }

  @override
  Stream<List<Receipt>> watchAll() async* {
    final box = await _hiveDatabase.getBox<Receipt>(_boxName);
    yield box.values.where(_isVisible).toList();
    yield* box.watch().map(
      (_) => box.values.where(_isVisible).toList(),
    );
  }

  /// Tombstones are filtered HERE rather than at each call site: several
  /// screens (History among them) never checked `deletedAt`, so filtering
  /// per-caller would have made deleted records reappear in exactly the
  /// places that forgot.
  bool _isVisible(Receipt entity) => entity.deletedAt == null;
}
