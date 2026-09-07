import '../../../core/di/injection.dart';
import '../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../category/domain/repositories/i_category_local_repository.dart';
import '../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../product/domain/repositories/i_product_local_repository.dart';
import '../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../settings/domain/repositories/i_settings_local_repository.dart';
import '../../store/domain/repositories/i_store_local_repository.dart';
import '../domain/use_cases/export_backup_use_case.dart';
import '../domain/use_cases/export_csv_use_case.dart';
import '../domain/use_cases/import_backup_use_case.dart';
import '../presentation/bloc/backup_bloc/backup_bloc.dart';

/// Registers the backup slice's use cases (design_spendlens.md §6/§9/§10 —
/// M9). Every dependency is resolved lazily from `getIt`, all of which are
/// already registered by the earlier `init*Feature()` calls in `main()`, so
/// registration order relative to them does not matter (same pattern as
/// `DeleteAllRecordsUseCase` in `settings_injection.dart`).
void initBackupFeature() {
  getIt.registerLazySingleton(
    () => ExportBackupUseCase(
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
    () => ExportCsvUseCase(
      expenseLocalRepository: getIt<IExpenseLocalRepository>(),
      categoryLocalRepository: getIt<ICategoryLocalRepository>(),
      storeLocalRepository: getIt<IStoreLocalRepository>(),
    ),
  );

  getIt.registerLazySingleton(
    () => ImportBackupUseCase(
      receiptLocalRepository: getIt<IReceiptLocalRepository>(),
      receiptItemLocalRepository: getIt<IReceiptItemLocalRepository>(),
      productLocalRepository: getIt<IProductLocalRepository>(),
      storeLocalRepository: getIt<IStoreLocalRepository>(),
      categoryLocalRepository: getIt<ICategoryLocalRepository>(),
      expenseLocalRepository: getIt<IExpenseLocalRepository>(),
      priceObservationLocalRepository:
          getIt<IPriceObservationLocalRepository>(),
      settingsLocalRepository: getIt<ISettingsLocalRepository>(),
    ),
  );

  // Screen-scoped (BLoC rule A3.8) — built in ProfilePage.initState, closed
  // on dispose; never dispatched from main().
  getIt.registerFactory(
    () => BackupBloc(
      exportBackupUseCase: getIt<ExportBackupUseCase>(),
      exportCsvUseCase: getIt<ExportCsvUseCase>(),
      importBackupUseCase: getIt<ImportBackupUseCase>(),
    ),
  );
}
