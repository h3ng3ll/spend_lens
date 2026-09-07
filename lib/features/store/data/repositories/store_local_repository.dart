import '../../../../core/hive/hive_database.dart';
import '../../domain/models/store/store.dart';
import '../../domain/repositories/i_store_local_repository.dart';

/// Hive-backed [IStoreLocalRepository]. Box name is plural lowercase
/// (`'stores'`) per hive_rules.md §5; never cached — every operation
/// re-fetches via the shared [HiveDatabase] helper.
class StoreLocalRepository implements IStoreLocalRepository {
  static const _boxName = 'stores';

  final HiveDatabase _hiveDatabase;

  const StoreLocalRepository(this._hiveDatabase);

  @override
  Future<List<Store>> getAll() async {
    final box = await _hiveDatabase.getBox<Store>(_boxName);
    return box.values.toList();
  }

  @override
  Future<Store?> getById(String id) async {
    final box = await _hiveDatabase.getBox<Store>(_boxName);
    return box.get(id);
  }

  @override
  Future<void> save(Store store) async {
    final box = await _hiveDatabase.getBox<Store>(_boxName);
    await box.put(store.id, store);
  }

  @override
  Future<void> delete(String id) async {
    final box = await _hiveDatabase.getBox<Store>(_boxName);
    await box.delete(id);
  }

  @override
  Stream<List<Store>> watchAll() async* {
    final box = await _hiveDatabase.getBox<Store>(_boxName);
    yield box.values.toList();
    yield* box.watch().map((_) => box.values.toList());
  }
}
