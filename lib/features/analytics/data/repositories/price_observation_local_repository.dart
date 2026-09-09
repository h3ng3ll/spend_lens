import '../../../../core/models/e_sync_status.dart';
import '../../../../core/hive/hive_database.dart';
import '../../domain/models/price_observation/price_observation.dart';
import '../../domain/repositories/i_price_observation_local_repository.dart';

/// Hive-backed [IPriceObservationLocalRepository]. Box name is plural
/// lowercase (`'price_observations'`) per hive_rules.md §5; never cached —
/// every operation re-fetches via the shared [HiveDatabase] helper.
class PriceObservationLocalRepository
    implements IPriceObservationLocalRepository {
  static const _boxName = 'price_observations';

  final HiveDatabase _hiveDatabase;

  const PriceObservationLocalRepository(this._hiveDatabase);

  @override
  Future<List<PriceObservation>> getAll() async {
    final box = await _hiveDatabase.getBox<PriceObservation>(_boxName);
    return box.values.where(_isVisible).toList();
  }

  @override
  Future<PriceObservation?> getById(String id) async {
    final box = await _hiveDatabase.getBox<PriceObservation>(_boxName);
    final found = box.get(id);
    return found != null && _isVisible(found) ? found : null;
  }

  @override
  Future<void> save(PriceObservation observation, {bool markPending = true}) async {
    final box = await _hiveDatabase.getBox<PriceObservation>(_boxName);
    await box.put(observation.id, await _stamped(box, observation, markPending));
  }

  @override
  Future<void> saveAll(List<PriceObservation> items, {bool markPending = true}) async {
    final box = await _hiveDatabase.getBox<PriceObservation>(_boxName);
    final entries = <String, PriceObservation>{};
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
    final box = await _hiveDatabase.getBox<PriceObservation>(_boxName);
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
  Future<List<PriceObservation>> getAllIncludingDeleted() async {
    final box = await _hiveDatabase.getBox<PriceObservation>(_boxName);
    return box.values.toList();
  }

  @override
  Future<List<PriceObservation>> getPending() async {
    final box = await _hiveDatabase.getBox<PriceObservation>(_boxName);
    return box.values
        .where((e) => e.syncStatus != ESyncStatus.synced)
        .toList();
  }

  /// Resolves the `syncStatus` a write should carry. `pendingCreate` when the
  /// box has never seen this id, `pendingUpdate` otherwise, so the push pass
  /// can tell a first upload from an edit. When [markPending] is false the
  /// entity is stored exactly as given — that is the sync engine landing
  /// server rows, which must not be echoed straight back.
  Future<PriceObservation> _stamped(
    dynamic box,
    PriceObservation entity,
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
  Stream<List<PriceObservation>> watchAll() async* {
    final box = await _hiveDatabase.getBox<PriceObservation>(_boxName);
    yield box.values.where(_isVisible).toList();
    yield* box.watch().map(
      (_) => box.values.where(_isVisible).toList(),
    );
  }

  /// Tombstones are filtered HERE rather than at each call site: several
  /// screens (History among them) never checked `deletedAt`, so filtering
  /// per-caller would have made deleted records reappear in exactly the
  /// places that forgot.
  bool _isVisible(PriceObservation entity) => entity.deletedAt == null;
}
