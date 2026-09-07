import '../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../store/domain/repositories/i_store_local_repository.dart';
import '../repositories/i_settings_local_repository.dart';

/// "Delete all records" (design_spendlens.md §7 /
/// `~/.claude/rules/delete_all_records_rules.md`).
///
/// Clears every user-entered dataset this app currently has (M5: expenses,
/// custom stores, and CUSTOM categories only) then persists
/// `AppSettings.dataCleared = true` so the seed guard
/// (`isEmpty && !dataCleared`, see `SeedCategoriesUseCase`) never silently
/// repopulates the app on the next cold start. **Never re-seeds here.**
///
/// R2-9 correction: the built-in categories are **preserved**, matching the
/// design source's own `confirmDeleteAll` (`SpendLens Prototype.dc.html`
/// line 901), which clears only `customCats`, while
/// `allCats = [...defaultCats, ...customCats]` (line 808) keeps
/// `defaultCats` — a hardcoded constant — intact. The built-ins surviving
/// delete-all IS the design's own restore path; deleting them (the previous
/// behavior of this use case) produced the exact contradiction QA observed:
/// zero categories left while the destructive-action footer still states
/// "Built-in categories cannot be deleted." This does not add a new restore
/// flow — it stops removing data the design never asked this action to
/// remove.
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
      // Built-in categories survive delete-all by design (see the doc
      // comment above) — only user-created ones are cleared.
      if (category.isBuiltIn) continue;
      await _categoryLocalRepository.delete(category.id);
    }

    final settings = await _settingsLocalRepository.get();
    await _settingsLocalRepository.save(
      settings.copyWith(dataCleared: true),
    );
  }
}
