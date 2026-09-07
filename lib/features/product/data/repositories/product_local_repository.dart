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
    return box.values.toList();
  }

  @override
  Future<Product?> getById(String id) async {
    final box = await _hiveDatabase.getBox<Product>(_boxName);
    return box.get(id);
  }

  @override
  Future<void> save(Product product) async {
    final box = await _hiveDatabase.getBox<Product>(_boxName);
    await box.put(product.id, product);
  }

  @override
  Future<void> delete(String id) async {
    final box = await _hiveDatabase.getBox<Product>(_boxName);
    await box.delete(id);
  }

  @override
  Stream<List<Product>> watchAll() async* {
    final box = await _hiveDatabase.getBox<Product>(_boxName);
    yield box.values.toList();
    yield* box.watch().map((_) => box.values.toList());
  }
}
