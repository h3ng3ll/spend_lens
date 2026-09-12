import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/category/domain/models/category/category.dart';
import 'package:spend_lens/features/category/domain/repositories/i_category_local_repository.dart';
import 'package:spend_lens/features/category/domain/use_cases/seed_categories_use_case.dart';

/// In-memory fake — exercises the real seed-guard logic in
/// [SeedCategoriesUseCase] without touching Hive.
class _FakeCategoryLocalRepository implements ICategoryLocalRepository {
  List<Category>? savedCategories;

  @override
  Future<List<Category>> getAll() async => savedCategories ?? const [];

  @override
  Future<Category?> getById(String id) async => null;

  @override
  Future<void> save(Category category, {bool markPending = true}) async {}

  @override
  Future<void> saveAll(
    List<Category> categories, {
    bool markPending = true,
  }) async {
    savedCategories = categories;
  }

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> deleteLocalOnly(String id) async {}

  @override
  Future<List<Category>> getAllIncludingDeleted() async =>
      savedCategories ?? const [];

  @override
  Future<List<Category>> getPending() async => const [];

  @override
  Stream<List<Category>> watchAll() => const Stream.empty();
}

void main() {
  late _FakeCategoryLocalRepository repository;
  late SeedCategoriesUseCase useCase;

  setUp(() {
    repository = _FakeCategoryLocalRepository();
    useCase = SeedCategoriesUseCase(repository);
  });

  group('SeedCategoriesUseCase — THE SEED GUARD IS isEmpty && !dataCleared',
      () {
    test('seeds all 12 built-ins on a genuinely fresh, empty install',
        () async {
      await useCase.call(isEmpty: true, dataCleared: false);

      expect(repository.savedCategories, isNotNull);
      expect(repository.savedCategories!.length, 12);
    });

    test(
        'does NOT seed when isEmpty but dataCleared is true — the '
        'delete_all_records_rules.md contract', () async {
      await useCase.call(isEmpty: true, dataCleared: true);

      expect(
        repository.savedCategories,
        isNull,
        reason:
            'Seeding on emptiness alone would silently repopulate a store '
            'the user deliberately cleared via "Delete all records".',
      );
    });

    test('does NOT seed when the store is not empty, regardless of the flag',
        () async {
      await useCase.call(isEmpty: false, dataCleared: false);
      expect(repository.savedCategories, isNull);

      await useCase.call(isEmpty: false, dataCleared: true);
      expect(repository.savedCategories, isNull);
    });

    test('every seeded category is isBuiltIn and named by an i18n key',
        () async {
      await useCase.call(isEmpty: true, dataCleared: false);

      final seeded = repository.savedCategories!;
      for (final category in seeded) {
        expect(category.isBuiltIn, isTrue);
        expect(category.name, startsWith('cat'));
        expect(category.colorHex, matches(RegExp(r'^#[0-9A-F]{6}$')));
      }
    });

    test('seeds exactly the 12 expected built-in category keys', () async {
      await useCase.call(isEmpty: true, dataCleared: false);

      final seededNames = repository.savedCategories!.map((c) => c.name).toSet();
      expect(seededNames, {
        'catFood',
        'catTransport',
        'catHousehold',
        'catRestaurantsCoffee',
        'catHealth',
        'catOther',
        'catShopping',
        'catEntertainment',
        'catUtilities',
        'catTravel',
        'catEducation',
        'catPersonalCare',
      });
    });
  });
}
