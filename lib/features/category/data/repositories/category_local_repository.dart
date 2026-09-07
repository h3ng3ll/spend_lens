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
    return box.values.toList();
  }

  @override
  Future<Category?> getById(String id) async {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
    return box.get(id);
  }

  @override
  Future<void> save(Category category) async {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
    await box.put(category.id, category);
  }

  @override
  Future<void> saveAll(List<Category> categories) async {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
    await box.putAll({for (final c in categories) c.id: c});
  }

  @override
  Future<void> delete(String id) async {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
    await box.delete(id);
  }

  @override
  Stream<List<Category>> watchAll() async* {
    final box = await _hiveDatabase.getBox<Category>(_boxName);
    yield box.values.toList();
    yield* box.watch().map((_) => box.values.toList());
  }
}
