import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/product/presentation/pages/choose_product_page/widgets/choose_product_body.dart';

/// REGRESSION: the picker must offer a receipt's OWN store's products plus
/// the general-purpose ones — the same candidate rule `ProductNormalizer`
/// applies when matching. Offering another shop's products would let a line
/// be pinned to a product that belongs somewhere else, which is exactly the
/// cross-store mixing the per-store model exists to prevent.
///
/// The predicates are pure functions so they can be pinned without pumping a
/// widget (BLoC rule A3.1 also keeps them out of state).
void main() {
  final now = DateTime(2026, 9, 19);

  Product product({
    required String id,
    String? storeId,
    String displayName = 'Milk',
    List<String> aliases = const [],
    DateTime? deletedAt,
  }) => Product(
    id: id,
    normalizedName: displayName.toLowerCase(),
    displayName: displayName,
    storeId: storeId,
    aliases: aliases,
    updatedAt: now,
    deletedAt: deletedAt,
  );

  group('scopeProducts', () {
    final all = [
      product(id: 'a', storeId: 'store-1'),
      product(id: 'b', storeId: 'store-2'),
      product(id: 'general'),
      product(id: 'dead', storeId: 'store-1', deletedAt: now),
    ];

    test('scoped to a store: its own products plus general-purpose ones', () {
      final scoped = scopeProducts(all, storeId: 'store-1');
      expect(scoped.map((p) => p.id), containsAll(['a', 'general']));
      expect(scoped.map((p) => p.id), isNot(contains('b')));
    });

    test('never offers a tombstoned product', () {
      final scoped = scopeProducts(all, storeId: 'store-1');
      expect(scoped.map((p) => p.id), isNot(contains('dead')));
    });

    test('unscoped returns every live product', () {
      final scoped = scopeProducts(all);
      expect(scoped, hasLength(3));
    });
  });

  group('filterProducts', () {
    final all = [
      product(id: 'a', displayName: 'Milk 2.5%'),
      product(id: 'b', displayName: 'Bread'),
      product(id: 'c', displayName: 'Cheese', aliases: ['branza']),
    ];

    test('an empty query returns everything', () {
      expect(filterProducts(all, '   '), hasLength(3));
    });

    test('matches the display name, case-insensitively', () {
      expect(filterProducts(all, 'milk').single.id, 'a');
      expect(filterProducts(all, 'MILK').single.id, 'a');
    });

    test('matches an ALIAS — the spelling the receipt actually printed', () {
      expect(filterProducts(all, 'branza').single.id, 'c');
    });

    test('a non-match returns empty rather than everything', () {
      expect(filterProducts(all, 'zzz'), isEmpty);
    });
  });
}
