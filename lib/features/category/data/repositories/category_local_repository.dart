import '../../../../core/models/e_sync_status.dart';
import '../../../../core/hive/hive_database.dart';
import '../../domain/models/category/category.dart';
import '../../domain/repositories/i_category_local_repository.dart';

/// Hive-backed [ICategoryLocalRepository]. Box name is plural lowercase
/// (`'categories'`) per hive_rules.md §5; boxes are never cached — every
/// operation re-fetches via the shared [HiveDatabase] helper (recorded
/// global bug `hive-getbox-cache-breaks-watch`).
class CategoryLocalRepository implements ICategoryLocalRepository {
  static const _boxName = 'categories';

  final HiveDatabase _hiveDatabase;

  const CategoryLocalRepository(this._hiveDatabase);

  @override
  Future<List<Category>> getAll() async {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
    return box.values.where(_isVisible).toList();
  }

  @override
  Future<Category?> getById(String id) async {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
    final found = box.get(id);
    return found != null && _isVisible(found) ? found : null;
  }

  @override
  Future<void> save(Category category, {bool markPending = true}) async {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
    await box.put(category.id, await _stamped(box, category, markPending));
  }

  @override
  Future<void> saveAll(
    List<Category> categories, {
    bool markPending = true,
  }) async {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
    final entries = <String, Category>{};
    for (final category in categories) {
      entries[category.id] = await _stamped(box, category, markPending);
    }
    await box.putAll(entries);
  }

  /// SOFT delete — the row stays in the box carrying `deletedAt` plus
  /// `pendingDelete`, so the deletion can be pushed to other devices. A hard
  /// `box.delete` would leave no tombstone, and the next pull would simply
  /// re-download the row.
  @override
  Future<void> delete(String id) async {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
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

  /// HARD delete, local only — removes the row with NO tombstone.
  ///
  /// The opposite of [delete], which soft-deletes so the removal can
  /// propagate. Used to retire a tombstone once its deletion has reached the
  /// server, and to drop a local copy the server already holds. Never call
  /// it on a row carrying unpublished work — nothing else has that data.
  @override
  Future<void> deleteLocalOnly(String id) async {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
    await box.delete(id);
  }

  @override
  Future<List<Category>> getAllIncludingDeleted() async {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
    return box.values.toList();
  }

  @override
  Future<List<Category>> getPending() async {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
    return box.values.where((e) => e.syncStatus != ESyncStatus.synced).toList();
  }

  /// Resolves the `syncStatus` a write should carry. `pendingCreate` when the
  /// box has never seen this id, `pendingUpdate` otherwise, so the push pass
  /// can tell a first upload from an edit. When [markPending] is false the
  /// entity is stored exactly as given — that is the sync engine landing
  /// server rows, which must not be echoed straight back.
  Future<Category> _stamped(
    dynamic box,
    Category entity,
    bool markPending,
  ) async {
    if (!markPending) return entity;
    final isNew = box.get(entity.id) == null;
    return entity.copyWith(
      // Stamped HERE, not left to the caller. `updatedAt` is the sync
      // engine's ordering key: the pull query filters on it and
      // last-write-wins compares it, so a row that reaches the server
      // without one is invisible to every device forever. Every write
      // passes through this method, so stamping it here is the only
      // placement no call site can forget.
      updatedAt: DateTime.now(),
      syncStatus: isNew ? ESyncStatus.pendingCreate : ESyncStatus.pendingUpdate,
    );
  }

  @override
  Stream<List<Category>> watchAll() async* {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
    yield box.values.where(_isVisible).toList();
    yield* box.watch().map(
      (_) => box.values.where(_isVisible).toList(),
    );
  }

  /// Tombstones are filtered HERE rather than at each call site: several
  /// screens (History among them) never checked `deletedAt`, so filtering
  /// per-caller would have made deleted records reappear in exactly the
  /// places that forgot.
  bool _isVisible(Category entity) => entity.deletedAt == null;
}
