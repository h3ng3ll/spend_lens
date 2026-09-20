import '../../../core/di/injection.dart';
import '../../../core/hive/hive_database.dart';
import '../../../core/services/firebase/firebase_storage_service.dart';
import '../../../core/services/image_compression_service.dart';
import '../../../core/services/store_logo_image_store/store_logo_image_store.dart';
import '../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../data/repositories/store_local_repository.dart';
import '../domain/repositories/i_store_local_repository.dart';
import '../domain/use_cases/delete_store_use_case.dart';
import '../domain/use_cases/learn_store_alias_use_case.dart';
import '../domain/use_cases/remove_store_logo_use_case.dart';
import '../domain/use_cases/resolve_receipt_store_use_case.dart';
import '../domain/use_cases/save_store_logo_use_case.dart';

/// Registers the store slice's repository (design_spendlens.md §3).
///
/// `StoresBloc` is not registered here — it lands in M4/M5 as a
/// `registerLazySingleton`, dispatched from `main()` per §5.
void initStoreFeature() {
  getIt.registerLazySingleton<IStoreLocalRepository>(
    () => StoreLocalRepository(getIt<HiveDatabase>()),
  );

  // Logo bytes live on the FILESYSTEM, never in Hive and never in a bloc
  // state — see `StoreLogoImageStore` for the defects that rule prevents.
  getIt.registerLazySingleton(() => const StoreLogoImageStore());
  getIt.registerLazySingleton(
    () => SaveStoreLogoUseCase(
      compressionService: getIt<ImageCompressionService>(),
      imageStore: getIt<StoreLogoImageStore>(),
      storageService: getIt<FirebaseStorageService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => RemoveStoreLogoUseCase(
      imageStore: getIt<StoreLogoImageStore>(),
      storageService: getIt<FirebaseStorageService>(),
    ),
  );

  // Receipt -> store resolution. Registered in the STORE slice, not the
  // receipt one, because matching policy belongs to whoever owns stores; the
  // receipt blocs are only consumers of the answer.
  getIt.registerLazySingleton(
    () => ResolveReceiptStoreUseCase(
      repository: getIt<IStoreLocalRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => LearnStoreAliasUseCase(repository: getIt<IStoreLocalRepository>()),
  );

  // Deleting a store cascades to everything pointing at it, so the write
  // spans five repositories — far past what a bloc should reach into
  // directly. Same shape as `DeleteAllRecordsUseCase`.
  //
  // The repositories below are registered by LATER `init*Feature()` calls,
  // which is safe: `registerLazySingleton` defers this closure until the
  // first resolution, long after `main()` has registered every slice.
  getIt.registerLazySingleton(
    () => DeleteStoreUseCase(
      storeLocalRepository: getIt<IStoreLocalRepository>(),
      expenseLocalRepository: getIt<IExpenseLocalRepository>(),
      receiptLocalRepository: getIt<IReceiptLocalRepository>(),
      receiptItemLocalRepository: getIt<IReceiptItemLocalRepository>(),
      priceObservationLocalRepository:
          getIt<IPriceObservationLocalRepository>(),
      imageStore: getIt<StoreLogoImageStore>(),
      storageService: getIt<FirebaseStorageService>(),
    ),
  );
}
