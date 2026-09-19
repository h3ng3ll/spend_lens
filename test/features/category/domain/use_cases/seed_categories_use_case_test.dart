import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/category/domain/models/category/category.dart';
import 'package:spend_lens/features/category/domain/repositories/i_category_local_repository.dart';
import 'package:spend_lens/features/category/domain/use_cases/seed_categories_use_case.dart';

/// In-memory fake — exercises the real seed-guard logic in
/// [SeedCategoriesUseCase] without touching Hive.
class _FakeCategoryLocalRepository implements ICategoryLocalRepository {
  List<Category>? savedCategories;

  /// The exact list handed to the most recent `saveAll` — lets a test assert
  /// WHAT was written, not just the resulting store contents.
  List<Category>? lastSaved;

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
    lastSaved = categories;
    savedCategories = [...?savedCategories, ...categories];
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

  group('SeedCategoriesUseCase — built-ins are infrastructure, not user data',
      () {
    test('seeds all 12 built-ins on a genuinely fresh, empty install',
        () async {
      await useCase.call(isEmpty: true, dataCleared: false);

      expect(repository.savedCategories, isNotNull);
      expect(repository.savedCategories!.length, 12);
    });

    test(
        'RESTORES the built-ins even when dataCleared is true — they are app '
        'infrastructure, not user records', () async {
      // Recorded defect: `dataCleared` is set by "Delete all records" and is
      // only ever reset by *import backup*, so a user who cleared their data
      // and never imported a backup was left with ZERO categories forever —
      // the picker read 0, the Analytics breakdown/donut/drill-down/insights
      // all silently vanished, and every expense fell back to "Other".
      // Observed on a real device: Settings showed "Categories 0".
      await useCase.call(isEmpty: true, dataCleared: true);

      expect(repository.savedCategories, isNotNull);
      expect(repository.savedCategories!.length, 12);
      expect(
        repository.savedCategories!.every((c) => c.isBuiltIn),
        isTrue,
        reason: 'Only BUILT-INS come back. Custom categories stay cleared — '
            'that is what delete_all_records_rules.md actually protects.',
      );
    });

    test('is idempotent — a complete set is left untouched', () async {
      await useCase.call(isEmpty: true, dataCleared: false);
      final first = repository.savedCategories;
      repository.savedCategories = first;

      await useCase.call(isEmpty: false, dataCleared: false);

      expect(
        repository.savedCategories,
        same(first),
        reason: 'Nothing was missing, so saveAll must not be called again.',
      );
    });

    test('restores only the MISSING built-ins', () async {
      await useCase.call(isEmpty: true, dataCleared: false);
      // Simulate a store that lost everything except Food.
      repository.savedCategories = repository.savedCategories!
          .where((c) => c.id == 'catFood')
          .toList();
      repository.lastSaved = null;

      await useCase.call(isEmpty: false, dataCleared: false);

      final written = repository.lastSaved!;
      expect(written.length, 11);
      expect(
        written.any((c) => c.id == 'catFood'),
        isFalse,
        reason: 'A built-in the user still has is never rewritten.',
      );
    });

    test('revives a soft-deleted built-in rather than duplicating it',
        () async {
      final now = DateTime(2026, 9, 19);
      repository.savedCategories = [
        Category(
          id: 'catFood',
          name: 'catFood',
          colorHex: '#A78BFA',
          isBuiltIn: true,
          updatedAt: now,
          deletedAt: now,
        ),
      ];
      repository.lastSaved = null;

      await useCase.call(isEmpty: false, dataCleared: false);

      final written = repository.lastSaved!;
      final food = written.firstWhere((c) => c.id == 'catFood');
      expect(food.deletedAt, isNull);
      expect(
        written.where((c) => c.id == 'catFood').length,
        1,
        reason: 'Reviving must not write a second row under the same key.',
      );
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
