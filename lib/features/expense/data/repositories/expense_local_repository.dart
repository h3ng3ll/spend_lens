import '../../../../core/models/e_sync_status.dart';
import '../../../../core/hive/hive_database.dart';
import '../../domain/models/expense/expense.dart';
import '../../domain/repositories/i_expense_local_repository.dart';

/// Hive-backed [IExpenseLocalRepository]. Box name is plural lowercase
/// (`'expenses'`) per hive_rules.md §5; never cached — every operation
/// re-fetches via the shared [HiveDatabase] helper.
class ExpenseLocalRepository implements IExpenseLocalRepository {
  static const _boxName = 'expenses';

  final HiveDatabase _hiveDatabase;

  const ExpenseLocalRepository(this._hiveDatabase);

  @override
  Future<List<Expense>> getAll() async {
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
    return box.values.where(_isVisible).toList();
  }

  @override
  Future<Expense?> getById(String id) async {
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
    final found = box.get(id);
    return found != null && _isVisible(found) ? found : null;
  }

  @override
  Future<void> save(Expense expense, {bool markPending = true}) async {
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
    await box.put(expense.id, await _stamped(box, expense, markPending));
  }

  @override
  Future<void> saveAll(List<Expense> items, {bool markPending = true}) async {
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
    final entries = <String, Expense>{};
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
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
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
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
    await box.delete(id);
  }

  @override
  Future<List<Expense>> getAllIncludingDeleted() async {
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
    return box.values.toList();
  }

  @override
  Future<List<Expense>> getPending() async {
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
    return box.values
        .where((e) => e.syncStatus != ESyncStatus.synced)
        .toList();
  }

  /// Resolves the `syncStatus` a write should carry. `pendingCreate` when the
  /// box has never seen this id, `pendingUpdate` otherwise, so the push pass
  /// can tell a first upload from an edit. When [markPending] is false the
  /// entity is stored exactly as given — that is the sync engine landing
  /// server rows, which must not be echoed straight back.
  Future<Expense> _stamped(
    dynamic box,
    Expense entity,
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
      syncStatus:
          isNew ? ESyncStatus.pendingCreate : ESyncStatus.pendingUpdate,
    );
  }

  @override
  Stream<List<Expense>> watchAll() async* {
    final box = await _hiveDatabase.getBox<Expense>(_boxName);
    yield box.values.where(_isVisible).toList();
    yield* box.watch().map(
      (_) => box.values.where(_isVisible).toList(),
    );
  }

  /// Tombstones are filtered HERE rather than at each call site: several
  /// screens (History among them) never checked `deletedAt`, so filtering
  /// per-caller would have made deleted records reappear in exactly the
  /// places that forgot.
  bool _isVisible(Expense entity) => entity.deletedAt == null;
}
