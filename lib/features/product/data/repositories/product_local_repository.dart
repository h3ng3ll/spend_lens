import '../../../../core/models/e_sync_status.dart';
import '../../../../core/hive/hive_database.dart';
import '../../domain/models/product/product.dart';
import '../../domain/repositories/i_product_local_repository.dart';

/// Hive-backed [IProductLocalRepository]. Box name is plural lowercase
/// (`'products'`) per hive_rules.md §5; never cached — every operation
/// re-fetches via the shared [HiveDatabase] helper.
class ProductLocalRepository implements IProductLocalRepository {
  static const _boxName = 'products';

  final HiveDatabase _hiveDatabase;

  const ProductLocalRepository(this._hiveDatabase);

  @override
  Future<List<Product>> getAll() async {
    final box = await _hiveDatabase.getBox<Product>(_boxName);
    return box.values.where(_isVisible).toList();
  }

  @override
  Future<Product?> getById(String id) async {
    final box = await _hiveDatabase.getBox<Product>(_boxName);
    final found = box.get(id);
    return found != null && _isVisible(found) ? found : null;
  }

  @override
  Future<void> save(Product product, {bool markPending = true}) async {
    final box = await _hiveDatabase.getBox<Product>(_boxName);
    await box.put(product.id, await _stamped(box, product, markPending));
  }

  @override
  Future<void> saveAll(List<Product> items, {bool markPending = true}) async {
    final box = await _hiveDatabase.getBox<Product>(_boxName);
    final entries = <String, Product>{};
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
    final box = await _hiveDatabase.getBox<Product>(_boxName);
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

  @override
  Future<List<Product>> getAllIncludingDeleted() async {
    final box = await _hiveDatabase.getBox<Product>(_boxName);
    return box.values.toList();
  }

  @override
  Future<List<Product>> getPending() async {
    final box = await _hiveDatabase.getBox<Product>(_boxName);
    return box.values
        .where((e) => e.syncStatus != ESyncStatus.synced)
        .toList();
  }

  /// Resolves the `syncStatus` a write should carry. `pendingCreate` when the
  /// box has never seen this id, `pendingUpdate` otherwise, so the push pass
  /// can tell a first upload from an edit. When [markPending] is false the
  /// entity is stored exactly as given — that is the sync engine landing
  /// server rows, which must not be echoed straight back.
  Future<Product> _stamped(
    dynamic box,
    Product entity,
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
  Stream<List<Product>> watchAll() async* {
    final box = await _hiveDatabase.getBox<Product>(_boxName);
    yield box.values.where(_isVisible).toList();
    yield* box.watch().map(
      (_) => box.values.where(_isVisible).toList(),
    );
  }

  /// Tombstones are filtered HERE rather than at each call site: several
  /// screens (History among them) never checked `deletedAt`, so filtering
  /// per-caller would have made deleted records reappear in exactly the
  /// places that forgot.
  bool _isVisible(Product entity) => entity.deletedAt == null;
}
