import '../../../core/di/injection.dart';
import '../../../core/hive/hive_database.dart';
import '../data/repositories/price_observation_local_repository.dart';
import '../domain/repositories/i_price_observation_local_repository.dart';

/// Registers the analytics slice's repository (design_spendlens.md §3). The
/// analytics calculator/insight generator (M6) are pure functions and need
/// no DI registration of their own.
void initAnalyticsFeature() {
  getIt.registerLazySingleton<IPriceObservationLocalRepository>(
    () => PriceObservationLocalRepository(getIt<HiveDatabase>()),
  );
}
