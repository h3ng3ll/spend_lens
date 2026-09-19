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
/// **THE SEED GUARD IS `isEmpty && !dataCleared` for the USER'S OWN DATA** —
/// seeding a user catalog on emptiness alone would silently repopulate
/// records the user deliberately emptied via "Delete all records"
/// (`~/.claude/rules/delete_all_records_rules.md`, design_spendlens.md §7).
///
/// The 12 BUILT-IN categories are the exception, and deliberately so: they
/// are app INFRASTRUCTURE, not user records. Every expense carries a
/// `categoryId` that must resolve to one, so an app with none is broken —
/// the breakdown, donut, drill-down and insights all silently disappear and
/// every expense falls back to "Other" with no error anywhere.
///
/// Recorded defect: `dataCleared` is set by delete-all and is only ever
/// reset by *import backup*, so a user who tapped "Delete all records" and
/// never imported a backup could NEVER get the built-ins back — the
/// category picker read 0 forever. `delete_all_records_rules.md` governs
/// the user's RECORDS; it never required the app's own category taxonomy to
/// stay destroyed. Custom categories remain cleared, which is what that
/// contract actually protects.
class SeedCategoriesUseCase {
  final ICategoryLocalRepository _repository;

  const SeedCategoriesUseCase(this._repository);

  /// Restores any MISSING built-in category.
  ///
  /// [isEmpty] and [dataCleared] are still accepted so the call site reads
  /// the same, but they no longer gate the built-ins: what is re-seeded is
  /// computed from what is actually on disk, so this is idempotent and
  /// safe to run on every cold start. A built-in the user still has is left
  /// untouched (its colour/keywords are never overwritten), and CUSTOM
  /// categories are never recreated — clearing those is the user's decision
  /// and `dataCleared` still protects it.
  Future<void> call({required bool isEmpty, required bool dataCleared}) async {
    // Includes tombstoned rows: a built-in that was soft-deleted must be
    // revived rather than written a second time under the same key.
    final existing = await _repository.getAllIncludingDeleted();
    final existingIds = {for (final category in existing) category.id};

    final missing = _builtInCategories()
        .where((category) => !existingIds.contains(category.id))
        .toList();

    final revived = existing
        .where((category) => category.isBuiltIn && category.deletedAt != null)
        .map((category) => category.copyWith(deletedAt: null))
        .toList();

    if (missing.isEmpty && revived.isEmpty) {
      return;
    }

    await _repository.saveAll([...missing, ...revived]);
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
