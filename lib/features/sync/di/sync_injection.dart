import '../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../core/services/store_logo_image_store/store_logo_image_store.dart';
import '../../../core/di/injection.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/services/firebase/firebase_firestore_service.dart';
import '../../../core/services/firebase/firebase_storage_service.dart';
import '../../../core/services/subscription/i_subscription_repository.dart';
import '../../../core/services/connectivity_service.dart';
import '../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../category/domain/repositories/i_category_local_repository.dart';
import '../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../product/domain/repositories/i_product_local_repository.dart';
import '../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../settings/domain/repositories/i_settings_local_repository.dart';
import '../../store/domain/repositories/i_store_local_repository.dart';
import '../data/repositories/sync_firestore_repository.dart';
import '../data/repositories/unconfigured_sync_repository.dart';
import '../domain/adapters/sync_entity_adapters.dart';
import '../domain/repositories/i_sync_remote_repository.dart';
import '../domain/use_cases/pull_remote_changes_use_case.dart';
import '../domain/use_cases/push_pending_changes_use_case.dart';
import '../domain/use_cases/download_receipt_photos_use_case.dart';
import '../../../core/services/product_image_store/product_image_store.dart';
import '../domain/use_cases/download_product_images_use_case.dart';
import '../domain/use_cases/download_store_logos_use_case.dart';
import '../domain/use_cases/upload_receipt_photos_use_case.dart';
import '../domain/use_cases/run_full_sync_use_case.dart';
import '../presentation/bloc/sync_bloc/sync_bloc.dart';

/// Registers the sync slice.
///
/// [isFirebaseReady] comes from `initAuthFeature()`, which is the single
/// place that knows whether `Firebase.initializeApp()` succeeded. When it
/// did not, the no-op [UnconfiguredSyncRepository] is registered instead of
/// the Firestore one, so the UI settles on "disabled" rather than throwing —
/// the same contract `UnconfiguredAuthRepository` provides for auth.
///
/// Must run AFTER the seven record slices, whose repositories it resolves.
void initSyncFeature({required bool isFirebaseReady}) {
  getIt.registerLazySingleton<ISyncRemoteRepository>(
    () => isFirebaseReady
        ? SyncFirestoreRepository(getIt<FirebaseFirestoreService>())
        : const UnconfiguredSyncRepository(),
  );

  getIt.registerLazySingleton(
    () => SyncEntityAdapters(
      receiptLocalRepository: getIt<IReceiptLocalRepository>(),
      receiptItemLocalRepository: getIt<IReceiptItemLocalRepository>(),
      productLocalRepository: getIt<IProductLocalRepository>(),
      storeLocalRepository: getIt<IStoreLocalRepository>(),
      categoryLocalRepository: getIt<ICategoryLocalRepository>(),
      expenseLocalRepository: getIt<IExpenseLocalRepository>(),
      priceObservationLocalRepository:
          getIt<IPriceObservationLocalRepository>(),
    ),
  );

  getIt.registerLazySingleton(
    () => PushPendingChangesUseCase(getIt<ISyncRemoteRepository>()),
  );
  getIt.registerLazySingleton(
    () => PullRemoteChangesUseCase(getIt<ISyncRemoteRepository>()),
  );
  getIt.registerLazySingleton(
    () => UploadReceiptPhotosUseCase(
      receiptLocalRepository: getIt<IReceiptLocalRepository>(),
      imageStore: getIt<ReceiptImageStore>(),
      storageService: getIt<FirebaseStorageService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => DownloadReceiptPhotosUseCase(
      receiptLocalRepository: getIt<IReceiptLocalRepository>(),
      imageStore: getIt<ReceiptImageStore>(),
      storageService: getIt<FirebaseStorageService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => DownloadStoreLogosUseCase(
      storeLocalRepository: getIt<IStoreLocalRepository>(),
      imageStore: getIt<StoreLogoImageStore>(),
      storageService: getIt<FirebaseStorageService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => DownloadProductImagesUseCase(
      productLocalRepository: getIt<IProductLocalRepository>(),
      imageStore: getIt<ProductImageStore>(),
      storageService: getIt<FirebaseStorageService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => RunFullSyncUseCase(
      remoteRepository: getIt<ISyncRemoteRepository>(),
      pushPendingChanges: getIt<PushPendingChangesUseCase>(),
      pullRemoteChanges: getIt<PullRemoteChangesUseCase>(),
      uploadReceiptPhotos: getIt<UploadReceiptPhotosUseCase>(),
      downloadReceiptPhotos: getIt<DownloadReceiptPhotosUseCase>(),
      downloadStoreLogos: getIt<DownloadStoreLogosUseCase>(),
      downloadProductImages: getIt<DownloadProductImagesUseCase>(),
      adapters: getIt<SyncEntityAdapters>(),
      settingsLocalRepository: getIt<ISettingsLocalRepository>(),
      loggerService: getIt<LoggerService>(),
    ),
  );

  // App-lifetime: `SyncEvent.watch()` is dispatched once from `main()`.
  getIt.registerLazySingleton(
    () => SyncBloc(
      runFullSync: getIt<RunFullSyncUseCase>(),
      adapters: getIt<SyncEntityAdapters>(),
      connectivityService: getIt<ConnectivityService>(),
      firestoreService: getIt<FirebaseFirestoreService>(),
      storageService: getIt<FirebaseStorageService>(),
      subscriptionRepository: getIt<ISubscriptionRepository>(),
    ),
  );
}
