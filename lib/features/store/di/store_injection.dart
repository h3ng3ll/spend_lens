import '../../../core/di/injection.dart';
import '../../../core/hive/hive_database.dart';
import '../data/repositories/store_local_repository.dart';
import '../domain/repositories/i_store_local_repository.dart';

/// Registers the store slice's repository (design_spendlens.md §3).
///
/// `StoresBloc` is not registered here — it lands in M4/M5 as a
/// `registerLazySingleton`, dispatched from `main()` per §5.
void initStoreFeature() {
  getIt.registerLazySingleton<IStoreLocalRepository>(
    () => StoreLocalRepository(getIt<HiveDatabase>()),
  );
}
