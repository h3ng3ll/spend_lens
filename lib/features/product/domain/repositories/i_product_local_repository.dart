import '../models/product/product.dart';

/// One repository per model (hive_rules.md §5) — owns [Product] only.
abstract interface class IProductLocalRepository {
  Future<List<Product>> getAll();

  Future<Product?> getById(String id);

  Future<void> save(Product product);

  Future<void> delete(String id);

  /// Reactive read — current values, then re-emits on every box mutation.
  Stream<List<Product>> watchAll();
}
