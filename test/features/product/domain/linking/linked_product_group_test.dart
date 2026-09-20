import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/product/domain/linking/linked_product_group.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';

/// REGRESSION: products are per-store, so the same goods at two stores are
/// two rows with two ids. `compareStorePriceForProduct` groups observations
/// by product id, so without a join every store-detail row would forever
/// read "Only bought here" and the cross-store comparison — the app's
/// headline feature — would be structurally dead.
///
/// The join is the user's own manual link. These tests pin the three
/// properties the comparison depends on: symmetry, transitivity, and
/// termination on the cycles that symmetric writes create by construction.
void main() {
  final now = DateTime(2026, 9, 19);

  Product product({
    required String id,
    String? storeId,
    List<String> linked = const [],
    DateTime? deletedAt,
  }) => Product(
    id: id,
    normalizedName: 'milk',
    displayName: 'Milk',
    storeId: storeId,
    linkedProductIds: linked,
    updatedAt: now,
    deletedAt: deletedAt,
  );

  group('resolveLinkedGroup', () {
    test('an unlinked product is a group of one', () {
      final all = [product(id: 'a', storeId: 's1')];
      expect(resolveLinkedGroup('a', all), {'a'});
    });

    test('a linked pair resolves to both ids from either side', () {
      final all = [
        product(id: 'a', storeId: 's1', linked: ['b']),
        product(id: 'b', storeId: 's2', linked: ['a']),
      ];
      expect(resolveLinkedGroup('a', all), {'a', 'b'});
      expect(resolveLinkedGroup('b', all), {'a', 'b'});
    });

    test('TRANSITIVE: a-b plus b-c makes a, b and c one group', () {
      final all = [
        product(id: 'a', storeId: 's1', linked: ['b']),
        product(id: 'b', storeId: 's2', linked: ['a', 'c']),
        product(id: 'c', storeId: 's3', linked: ['b']),
      ];
      expect(resolveLinkedGroup('a', all), {'a', 'b', 'c'});
      expect(resolveLinkedGroup('c', all), {'a', 'b', 'c'});
    });

    test('a cycle terminates instead of recursing forever', () {
      final all = [
        product(id: 'a', storeId: 's1', linked: ['b']),
        product(id: 'b', storeId: 's2', linked: ['c']),
        product(id: 'c', storeId: 's3', linked: ['a']),
      ];
      expect(resolveLinkedGroup('a', all), {'a', 'b', 'c'});
    });

    test('a link to a tombstoned product is dropped', () {
      final all = [
        product(id: 'a', storeId: 's1', linked: ['b']),
        product(id: 'b', storeId: 's2', linked: ['a'], deletedAt: now),
      ];
      expect(resolveLinkedGroup('a', all), {'a'});
    });

    test('a link to a missing product id is dropped, not fatal', () {
      final all = [product(id: 'a', storeId: 's1', linked: ['ghost'])];
      expect(resolveLinkedGroup('a', all), {'a'});
    });

    test('an unknown product id resolves to just itself', () {
      expect(resolveLinkedGroup('nobody', [product(id: 'a')]), {'nobody'});
    });

    test('separate groups do not bleed into each other', () {
      final all = [
        product(id: 'a', storeId: 's1', linked: ['b']),
        product(id: 'b', storeId: 's2', linked: ['a']),
        product(id: 'x', storeId: 's1', linked: ['y']),
        product(id: 'y', storeId: 's2', linked: ['x']),
      ];
      expect(resolveLinkedGroup('a', all), {'a', 'b'});
      expect(resolveLinkedGroup('x', all), {'x', 'y'});
    });
  });

  group('linkProducts', () {
    test('writes the id onto BOTH sides', () {
      final linked = linkProducts(
        product(id: 'a', storeId: 's1'),
        product(id: 'b', storeId: 's2'),
        now,
      );
      expect(linked.a.linkedProductIds, ['b']);
      expect(linked.b.linkedProductIds, ['a']);
    });

    test('re-linking an existing pair does not duplicate', () {
      final linked = linkProducts(
        product(id: 'a', storeId: 's1', linked: ['b']),
        product(id: 'b', storeId: 's2', linked: ['a']),
        now,
      );
      expect(linked.a.linkedProductIds, ['b']);
      expect(linked.b.linkedProductIds, ['a']);
    });

    test('an existing link to a third product is preserved', () {
      final linked = linkProducts(
        product(id: 'a', storeId: 's1', linked: ['c']),
        product(id: 'b', storeId: 's2'),
        now,
      );
      expect(linked.a.linkedProductIds, ['c', 'b']);
    });
  });

  group('unlinkProducts', () {
    test('removes the id from BOTH sides', () {
      final unlinked = unlinkProducts(
        product(id: 'a', storeId: 's1', linked: ['b']),
        product(id: 'b', storeId: 's2', linked: ['a']),
        now,
      );
      expect(unlinked.a.linkedProductIds, isEmpty);
      expect(unlinked.b.linkedProductIds, isEmpty);
    });

    test('severs only the direct pair, leaving other links intact', () {
      final unlinked = unlinkProducts(
        product(id: 'a', storeId: 's1', linked: ['b', 'c']),
        product(id: 'b', storeId: 's2', linked: ['a']),
        now,
      );
      expect(unlinked.a.linkedProductIds, ['c']);
    });

    test('a-c survives unlinking a-b while b-c still holds', () {
      // The transitive-closure consequence, pinned deliberately: the group
      // is whatever is still REACHABLE, so removing one edge does not
      // partition a group that another edge still spans.
      final a = product(id: 'a', storeId: 's1', linked: ['b', 'c']);
      final b = product(id: 'b', storeId: 's2', linked: ['a', 'c']);
      final c = product(id: 'c', storeId: 's3', linked: ['a', 'b']);
      final unlinked = unlinkProducts(a, b, now);

      final all = [unlinked.a, unlinked.b, c];
      expect(resolveLinkedGroup('a', all), {'a', 'b', 'c'});
    });

    test('unlinking a pair that was never linked is a no-op', () {
      final unlinked = unlinkProducts(
        product(id: 'a', storeId: 's1'),
        product(id: 'b', storeId: 's2'),
        now,
      );
      expect(unlinked.a.linkedProductIds, isEmpty);
      expect(unlinked.b.linkedProductIds, isEmpty);
    });
  });
}
