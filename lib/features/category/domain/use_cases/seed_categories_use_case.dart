import '../../../../core/resources/colors/app_colors.dart';
import '../models/category/category.dart';
import '../repositories/i_category_local_repository.dart';

/// First-launch seed of the 12 built-in categories (design_spendlens.md §3 /
/// §18, binding decision 3).
///
/// The caller (see `main.dart`) supplies whether the store is empty and
/// whether the user has deliberately cleared their data — this use case
/// never reads `AppSettings` itself, so it stays a pure, single-purpose
/// operation (SRP) and is trivially testable without a settings repository.
///
/// **THE SEED GUARD IS `isEmpty && !dataCleared`** — never `isEmpty` alone.
/// Seeding on emptiness alone would silently repopulate a catalog the user
/// deliberately emptied via "Delete all records"
/// (`~/.claude/rules/delete_all_records_rules.md`, design_spendlens.md §7).
/// Delete-all itself must set `dataCleared = true` and MUST NOT call this
/// use case again; only a restore path may set the flag back to `false`.
class SeedCategoriesUseCase {
  final ICategoryLocalRepository _repository;

  const SeedCategoriesUseCase(this._repository);

  /// Seeds all 12 built-in categories when [isEmpty] is true AND
  /// [dataCleared] is false. No-ops otherwise — in particular, a store the
  /// user deliberately cleared (`dataCleared == true`) is left empty even
  /// though it is also `isEmpty`.
  Future<void> call({required bool isEmpty, required bool dataCleared}) async {
    if (!isEmpty || dataCleared) {
      return;
    }
    await _repository.saveAll(_builtInCategories());
  }

  /// The 12 built-in categories. `name` is an i18n key resolved through
  /// `AppLocalizations` at display time — never a rendered string
  /// (design_spendlens.md §3). Hues are read directly from [AppColors] —
  /// the single source of truth already reviewed at uniform lightness
  /// 72.5% / saturation 85.7% with a minimum 30.8° hue gap; this use case
  /// never re-derives or invents a hue.
  List<Category> _builtInCategories() {
    final now = DateTime.now();

    Category builtIn(String nameKey, AppColors color) => Category(
      id: nameKey,
      name: nameKey,
      colorHex: _toHex(color.value.toARGB32()),
      isBuiltIn: true,
      updatedAt: now,
    );

    return [
      builtIn('catFood', AppColors.categoryFood),
      builtIn('catTransport', AppColors.categoryTransport),
      builtIn('catHousehold', AppColors.categoryHousehold),
      builtIn('catRestaurantsCoffee', AppColors.categoryRestaurantsCoffee),
      builtIn('catHealth', AppColors.categoryHealth),
      builtIn('catOther', AppColors.categoryOther),
      builtIn('catShopping', AppColors.categoryShopping),
      builtIn('catEntertainment', AppColors.categoryEntertainment),
      builtIn('catUtilities', AppColors.categoryUtilities),
      builtIn('catTravel', AppColors.categoryTravel),
      builtIn('catEducation', AppColors.categoryEducation),
      builtIn('catPersonalCare', AppColors.categoryPersonalCare),
    ];
  }

  /// `0xAARRGGBB` (32-bit ARGB, per `Color.toARGB32()`) → `'#RRGGBB'`,
  /// dropping the alpha byte — every category hue is fully opaque.
  String _toHex(int argb32) =>
      '#${(argb32 & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
