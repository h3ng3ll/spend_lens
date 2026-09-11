import 'package:get_it/get_it.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../hive/hive_database.dart';
import '../services/connectivity_service.dart';
import '../services/firebase/firebase_firestore_service.dart';
import '../services/firebase/firebase_storage_service.dart';
import '../services/image_compression_service.dart';
import '../services/logger_service.dart';
import '../services/ocr/i_receipt_detector.dart';
import '../services/ocr/method_channel_ocr_service.dart';
import '../services/ocr/method_channel_receipt_detector.dart';
import '../services/ocr/ocr_service.dart';
import '../services/permission_requester.dart';
import '../services/receipt_image_store/receipt_image_store.dart';
import '../services/scan_capability/i_scan_capability_service.dart';
import '../services/scan_capability/scan_capability_service.dart';
import '../services/subscription/apphud_subscription_repository.dart';
import '../services/subscription/i_subscription_repository.dart';
import '../services/subscription/revenue_cat_subscription_repository.dart';
import '../utils/env/env.dart';

final getIt = GetIt.instance;

/// App-wide DI registrations.
///
/// Firebase surface: Crashlytics, auth, **Firestore record sync** and
/// **Storage** for receipt photos. Still stripped of the Functions /
/// Realtime-Database / Messaging registrations the sinergy_hub template
/// carried — this app has no server-side functions, no Realtime Database and
/// no push messaging, and those exclusions still hold.
///
/// Firestore sync was added after M9. It is a REPLICA, not the read path:
/// every screen still reads Hive through `watchAll()`, so the app is
/// unchanged offline and no screen bloc knows sync exists. See
/// `lib/features/sync/`.
///
/// M1 registered only what compiled then (`LoggerService`, the single
/// concrete `Env`). M2 adds the settings slice's own `initSettingsFeature()`
/// call (see `main.dart` — it runs separately because it returns the
/// resolved `AppSettings` value `main()` needs to seed `SettingsBloc` before
/// `runApp`). Later milestones add: `CategoriesBloc` / `StoresBloc` /
/// `AuthBloc` / `SubscriptionBloc` (registerLazySingleton, dispatched from
/// `main()`), repositories (M3+), and the remaining feature slices' own
/// `init*Feature(getIt)` calls (M4+, per design_spendlens.md §5).
Future<void> initDependencies() async {
  getIt.registerLazySingleton(() => LoggerService());

  getIt.registerLazySingleton<Env>(() => ConcreteEnv());

  // M3: shared, stateless box-access helper — every feature repository
  // below resolves this one instance via constructor injection rather than
  // opening boxes ad hoc (hive_rules.md §7).
  getIt.registerLazySingleton(() => const HiveDatabase());

  // Raw SDK singletons are registered separately from the wrapper services
  // that consume them, so those wrappers stay unit-testable against fakes.
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseStorage.instance);

  getIt.registerLazySingleton(
    () => FirebaseFirestoreService(
      firebaseFirestore: getIt<FirebaseFirestore>(),
      firebaseAuth: getIt<FirebaseAuth>(),
      loggerService: getIt<LoggerService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => FirebaseStorageService(
      firebaseStorage: getIt<FirebaseStorage>(),
    ),
  );

  // Proactive online/offline signal for the sync UI, and the reconnect
  // trigger. Its `init()` is awaited in `main()` before `runApp`.
  getIt.registerLazySingleton(
    () => ConnectivityService(),
  );

  getIt.registerLazySingleton(
    () => const ImageCompressionService(),
  );

  // M7: the single channel contract (design_spendlens.md §6), identical on
  // both platforms — no `Platform.isX` branch anywhere above this line.
  getIt.registerLazySingleton<OcrService>(
    () => MethodChannelOcrService(
      loggerService: getIt<LoggerService>(),
    ),
  );
  getIt.registerLazySingleton<IReceiptDetector>(
    () => MethodChannelReceiptDetector(
      loggerService: getIt<LoggerService>(),
    ),
  );

  // M7: lives in core because two unrelated consumers read it — the Home
  // screen's Scan Receipt button AND the Settings capability row
  // (design_spendlens.md §6).
  getIt.registerLazySingleton<IScanCapabilityService>(
    () => ScanCapabilityService(
      getIt<OcrService>(),
    ),
  );

  // Stateless filesystem helper for receipt photos. Registered so the
  // gallery-pick path and `ReviewBloc` share ONE instance instead of each
  // default-constructing its own.
  getIt.registerLazySingleton(
    () => const ReceiptImageStore(),
  );

  // registerLazySingleton, never a factory: `isPicking` is a process-wide
  // re-entrancy guard, and a factory would hand each call site a fresh
  // `false` — silently deleting the double-pick protection.
  getIt.registerLazySingleton(
    () => PermissionRequester(
      getIt<IScanCapabilityService>(),
    ),
  );

  // M9: Apphud-only subscription repository (design_spendlens.md §6/§9).
  // `init()` is called separately from `main()` (after this registration),
  // mirroring `GoogleSignInService`'s pattern — a missing API key degrades
  // to `isConfigured == false` rather than throwing.
  getIt.registerLazySingleton<ISubscriptionRepository>(
    () => ApphudSubscriptionRepository(
      loggerService: getIt<LoggerService>(),
    ),
  );
}
