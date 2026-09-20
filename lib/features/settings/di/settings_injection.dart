import '../../../core/di/injection.dart';
import '../../category/domain/repositories/i_category_local_repository.dart';
import '../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../product/domain/repositories/i_product_local_repository.dart';
import '../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../store/domain/repositories/i_store_local_repository.dart';
import '../data/repositories/settings_local_repository.dart';
import '../domain/models/app_settings/app_settings.dart';
import '../domain/repositories/i_settings_local_repository.dart';
import '../domain/use_cases/delete_all_records_use_case.dart';
import '../domain/use_cases/get_settings_use_case.dart';
import '../domain/use_cases/save_settings_use_case.dart';
import '../domain/use_cases/watch_settings_use_case.dart';
import '../presentation/bloc/settings_bloc/settings_bloc.dart';

/// Registers the settings slice's repository and use cases, and resolves
/// the persisted [AppSettings] SYNCHRONOUSLY (relative to `runApp`) so
/// `main()` can seed [SettingsBloc]'s initial state before the first frame —
/// see `settings_bloc.dart`'s doc comment for why this ordering matters.
///
/// `SettingsBloc` itself is registered by `main()` directly (not here),
/// because its constructor needs the already-resolved [AppSettings] value
/// that only `main()` has at that point.
Future<AppSettings> initSettingsFeature() async {
  getIt.registerLazySingleton<ISettingsLocalRepository>(
    () => SettingsLocalRepository(),
  );

  getIt.registerLazySingleton(
    () => GetSettingsUseCase(getIt<ISettingsLocalRepository>()),
  );
  getIt.registerLazySingleton(
    () => WatchSettingsUseCase(getIt<ISettingsLocalRepository>()),
  );
  getIt.registerLazySingleton(
    () => SaveSettingsUseCase(getIt<ISettingsLocalRepository>()),
  );

  // Resolved lazily: `getIt<T>()` inside the factory below only runs when
  // `DeleteAllRecordsUseCase` is actually requested (Settings screen, well
  // after `main()` has registered the expense/store/category repositories),
  // never at registration time here — so registration order relative to
  // those `init*Feature()` calls in `main()` does not matter.
  getIt.registerLazySingleton(
    () => DeleteAllRecordsUseCase(
      expenseLocalRepository: getIt<IExpenseLocalRepository>(),
      storeLocalRepository: getIt<IStoreLocalRepository>(),
      categoryLocalRepository: getIt<ICategoryLocalRepository>(),
      receiptLocalRepository: getIt<IReceiptLocalRepository>(),
      receiptItemLocalRepository: getIt<IReceiptItemLocalRepository>(),
      productLocalRepository: getIt<IProductLocalRepository>(),
      priceObservationLocalRepository:
          getIt<IPriceObservationLocalRepository>(),
      settingsLocalRepository: getIt<ISettingsLocalRepository>(),
    ),
  );

  return getIt<GetSettingsUseCase>().call();
}
