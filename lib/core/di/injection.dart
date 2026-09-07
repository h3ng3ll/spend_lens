import 'package:get_it/get_it.dart';

import '../hive/hive_database.dart';
import '../services/logger_service.dart';
import '../services/ocr/i_receipt_detector.dart';
import '../services/ocr/method_channel_ocr_service.dart';
import '../services/ocr/method_channel_receipt_detector.dart';
import '../services/ocr/ocr_service.dart';
import '../services/scan_capability/i_scan_capability_service.dart';
import '../services/scan_capability/scan_capability_service.dart';
import '../services/subscription/apphud_subscription_repository.dart';
import '../services/subscription/i_subscription_repository.dart';
import '../utils/env/env.dart';

final getIt = GetIt.instance;

/// App-wide DI registrations.
///
/// design_spendlens.md §1 Step 2: stripped of every Firestore/Functions/
/// Database/Messaging registration the sinergy_hub template carried — this
/// app has no Firestore sync, no Realtime Database, no push messaging.
/// Firebase here (M9) is Crashlytics + optional auth only.
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

  // M7: the single channel contract (design_spendlens.md §6), identical on
  // both platforms — no `Platform.isX` branch anywhere above this line.
  getIt.registerLazySingleton<OcrService>(
    () => MethodChannelOcrService(loggerService: getIt<LoggerService>()),
  );
  getIt.registerLazySingleton<IReceiptDetector>(
    () =>
        MethodChannelReceiptDetector(loggerService: getIt<LoggerService>()),
  );

  // M7: lives in core because two unrelated consumers read it — the Home
  // screen's Scan Receipt button AND the Settings capability row
  // (design_spendlens.md §6).
  getIt.registerLazySingleton<IScanCapabilityService>(
    () => ScanCapabilityService(getIt<OcrService>()),
  );

  // M9: Apphud-only subscription repository (design_spendlens.md §6/§9).
  // `init()` is called separately from `main()` (after this registration),
  // mirroring `GoogleSignInService`'s pattern — a missing API key degrades
  // to `isConfigured == false` rather than throwing.
  getIt.registerLazySingleton<ISubscriptionRepository>(
    () => ApphudSubscriptionRepository(loggerService: getIt<LoggerService>()),
  );
}
