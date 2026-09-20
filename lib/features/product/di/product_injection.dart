import '../../../core/di/injection.dart';
import '../../../core/hive/hive_database.dart';
import '../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../data/repositories/product_local_repository.dart';
import '../domain/repositories/i_product_local_repository.dart';
import '../domain/use_cases/rename_product_use_case.dart';
import '../domain/use_cases/split_legacy_products_use_case.dart';

/// Registers the product slice's repository (design_spendlens.md §3).
///
/// The normalizer (M8) and its use cases land later — M3 only needs the
/// repository to exist so the Hive box is reachable.
void initProductFeature() {
  getIt.registerLazySingleton<IProductLocalRepository>(
    () => ProductLocalRepository(getIt<HiveDatabase>()),
  );

  // The single owner of "apply a user-typed name to a product" — shared by
  // both receipt save paths so a rename behaves identically whichever one
  // runs. See `RenameProductUseCase`.
  getIt.registerLazySingleton<RenameProductUseCase>(
    () => RenameProductUseCase(
      productRepository: getIt<IProductLocalRepository>(),
    ),
  );

  // Resolved lazily, so the analytics/receipt repositories it depends on do
  // not have to be registered before this slice — `main()` calls it once,
  // after every record slice is wired.
  getIt.registerLazySingleton<SplitLegacyProductsUseCase>(
    () => SplitLegacyProductsUseCase(
      productRepository: getIt<IProductLocalRepository>(),
      priceObservationRepository: getIt<IPriceObservationLocalRepository>(),
      receiptRepository: getIt<IReceiptLocalRepository>(),
      receiptItemRepository: getIt<IReceiptItemLocalRepository>(),
    ),
  );
}
