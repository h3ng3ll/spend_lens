import '../../../core/di/injection.dart';
import '../../../core/hive/hive_database.dart';
import '../../expense/domain/repositories/i_expense_local_repository.dart';
import '../data/repositories/receipt_item_local_repository.dart';
import '../data/repositories/receipt_local_repository.dart';
import '../domain/repositories/i_receipt_item_local_repository.dart';
import '../domain/repositories/i_receipt_local_repository.dart';
import '../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../core/services/receipt_size_calculator.dart';
import '../data/repositories/receipt_repository.dart';
import '../domain/repositories/i_receipt_repository.dart';
import '../domain/use_cases/create_expense_from_receipt_use_case.dart';

/// Registers the receipt slice's two repositories — [Receipt] and
/// [ReceiptItem] are separate models with separate boxes, per
/// hive_rules.md §5 (one repository per model), even though they share one
/// feature slice.
void initReceiptFeature() {
  getIt.registerLazySingleton<IReceiptLocalRepository>(
    () => ReceiptLocalRepository(getIt<HiveDatabase>()),
  );
  getIt.registerLazySingleton<IReceiptItemLocalRepository>(
    () => ReceiptItemLocalRepository(getIt<HiveDatabase>()),
  );

  // The domain-facing receipt repository: composes the local box, the
  // on-disk photo and the size calculator so screens ask ONE thing where
  // their data comes from. The local repository above stays the single Hive
  // owner (hive_rules.md §5) and is what the sync adapters use.
  getIt.registerLazySingleton<IReceiptRepository>(
    () => ReceiptRepository(
      receiptLocalRepository: getIt<IReceiptLocalRepository>(),
      receiptItemLocalRepository: getIt<IReceiptItemLocalRepository>(),
      imageStore: getIt<ReceiptImageStore>(),
      sizeCalculator: const ReceiptSizeCalculator(),
    ),
  );

  // Makes a saved receipt visible to Home/History/Analytics, which watch
  // the `expenses` box rather than `receipts`.
  getIt.registerLazySingleton(
    () => CreateExpenseFromReceiptUseCase(getIt<IExpenseLocalRepository>()),
  );
}
