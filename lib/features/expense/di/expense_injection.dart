import '../../../core/di/injection.dart';
import '../../../core/hive/hive_database.dart';
import '../data/repositories/expense_local_repository.dart';
import '../domain/repositories/i_expense_local_repository.dart';

/// Registers the expense slice's repository (design_spendlens.md §3).
void initExpenseFeature() {
  getIt.registerLazySingleton<IExpenseLocalRepository>(
    () => ExpenseLocalRepository(getIt<HiveDatabase>()),
  );
}
