import '../../../core/di/injection.dart';
import '../../../core/hive/hive_database.dart';
import '../data/repositories/category_local_repository.dart';
import '../domain/repositories/i_category_local_repository.dart';
import '../domain/use_cases/seed_categories_use_case.dart';

/// Registers the category slice's repository and its first-launch seed use
/// case (design_spendlens.md §3 / §7).
///
/// `CategoriesBloc` is not registered here — it lands in M4/M5 as a
/// `registerLazySingleton`, dispatched from `main()` per §5. M3 only needs
/// the repository to exist and the seed to run once, synchronously, before
/// the first frame — mirroring how `initSettingsFeature()` resolves
/// `AppSettings` for `main()` to consume.
Future<void> initCategoryFeature() async {
  getIt.registerLazySingleton<ICategoryLocalRepository>(
    () => CategoryLocalRepository(getIt<HiveDatabase>()),
  );

  getIt.registerLazySingleton(
    () => SeedCategoriesUseCase(getIt<ICategoryLocalRepository>()),
  );
}
