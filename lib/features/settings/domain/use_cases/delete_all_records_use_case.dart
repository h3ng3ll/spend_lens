import '../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../store/domain/repositories/i_store_local_repository.dart';
import '../repositories/i_settings_local_repository.dart';

/// "Delete all records" (design_spendlens.md §7 /
/// `~/.claude/rules/delete_all_records_rules.md`).
///
/// Clears every user-entered dataset this app currently has (M5: expenses,
/// custom stores, custom categories — the built-in categories are also
/// cleared, matching the design's `confirmDeleteAll`, which "empties
/// transactions, clears custom stores and categories" and never re-seeds),
/// then persists `AppSettings.dataCleared = true` so the seed guard
/// (`isEmpty && !dataCleared`, see `SeedCategoriesUseCase`) never silently
/// repopulates the app on the next cold start. **Never re-seeds here.**
///
/// Receipts/receipt items/price observations are intentionally not yet
/// dependencies — M5 is manual-entry only (zero native code, no scanning),
/// so those repositories carry no data for delete-all to clear. M8 (when
/// receipts exist) must extend this use case's dependency list rather than
/// re-implement delete-all elsewhere.
class DeleteAllRecordsUseCase {
  final IExpenseLocalRepository _expenseLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;
  final ICategoryLocalRepository _categoryLocalRepository;
  final ISettingsLocalRepository _settingsLocalRepository;

  const DeleteAllRecordsUseCase({
    required IExpenseLocalRepository expenseLocalRepository,
    required IStoreLocalRepository storeLocalRepository,
    required ICategoryLocalRepository categoryLocalRepository,
    required ISettingsLocalRepository settingsLocalRepository,
  }) : this._(
         expenseLocalRepository,
         storeLocalRepository,
         categoryLocalRepository,
         settingsLocalRepository,
       );

  const DeleteAllRecordsUseCase._(
    this._expenseLocalRepository,
    this._storeLocalRepository,
    this._categoryLocalRepository,
    this._settingsLocalRepository,
  );

  Future<void> call() async {
    final expenses = await _expenseLocalRepository.getAll();
    for (final expense in expenses) {
      await _expenseLocalRepository.delete(expense.id);
    }

    final stores = await _storeLocalRepository.getAll();
    for (final store in stores) {
      await _storeLocalRepository.delete(store.id);
    }

    final categories = await _categoryLocalRepository.getAll();
    for (final category in categories) {
      await _categoryLocalRepository.delete(category.id);
    }

    final settings = await _settingsLocalRepository.get();
    await _settingsLocalRepository.save(
      settings.copyWith(dataCleared: true),
    );
  }
}
