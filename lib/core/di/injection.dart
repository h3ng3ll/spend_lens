import 'package:get_it/get_it.dart';

import '../services/logger_service.dart';
import '../utils/env/env.dart';

final getIt = GetIt.instance;

/// App-wide DI registrations.
///
/// design_spendlens.md §1 Step 2: stripped of every Firestore/Functions/
/// Database/Messaging registration the sinergy_hub template carried — this
/// app has no Firestore sync, no Realtime Database, no push messaging.
/// Firebase here (M9) is Crashlytics + optional auth only.
///
/// M1 registers only what compiles today (`LoggerService`, the single
/// concrete `Env`). Later milestones add: `SettingsBloc` / `CategoriesBloc` /
/// `StoresBloc` / `AuthBloc` / `SubscriptionBloc` (registerLazySingleton,
/// dispatched from `main()`), repositories (M3+), and the 13 feature slices'
/// own `init*Feature(getIt)` calls (M4+, per design_spendlens.md §5).
Future<void> initDependencies() async {
  getIt.registerLazySingleton(() => LoggerService());

  getIt.registerLazySingleton<Env>(() => ConcreteEnv());
}
