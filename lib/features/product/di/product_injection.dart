import '../../../core/di/injection.dart';
import '../../../core/hive/hive_database.dart';
import '../data/repositories/product_local_repository.dart';
import '../domain/repositories/i_product_local_repository.dart';

/// Registers the product slice's repository (design_spendlens.md §3).
///
/// The normalizer (M8) and its use cases land later — M3 only needs the
/// repository to exist so the Hive box is reachable.
void initProductFeature() {
  getIt.registerLazySingleton<IProductLocalRepository>(
    () => ProductLocalRepository(getIt<HiveDatabase>()),
  );
}
