import '../models/store/store.dart';

/// One repository per model (hive_rules.md §5) — owns [Store] only.
abstract interface class IStoreLocalRepository {
  Future<List<Store>> getAll();

  Future<Store?> getById(String id);

  Future<void> save(Store store);

  Future<void> delete(String id);

  /// Reactive read — current values, then re-emits on every box mutation.
  Stream<List<Store>> watchAll();
}
