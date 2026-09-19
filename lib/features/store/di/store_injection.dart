import '../../../core/di/injection.dart';
import '../../../core/hive/hive_database.dart';
import '../../../core/services/firebase/firebase_storage_service.dart';
import '../../../core/services/image_compression_service.dart';
import '../../../core/services/store_logo_image_store/store_logo_image_store.dart';
import '../data/repositories/store_local_repository.dart';
import '../domain/repositories/i_store_local_repository.dart';
import '../domain/use_cases/remove_store_logo_use_case.dart';
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
}
