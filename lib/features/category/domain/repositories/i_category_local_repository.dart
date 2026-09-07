import '../models/category/category.dart';

/// One repository per model (hive_rules.md §5) — owns [Category] only.
abstract interface class ICategoryLocalRepository {
  Future<List<Category>> getAll();

  Future<Category?> getById(String id);

  Future<void> save(Category category);

  /// Bulk insert used by the first-launch seed (design_spendlens.md §7).
  Future<void> saveAll(List<Category> categories);

  Future<void> delete(String id);

  /// Reactive read — current values, then re-emits on every box mutation.
  /// Bloc layers subscribe via `emit.forEach` (hive_rules.md §6/§9).
  Stream<List<Category>> watchAll();
}
