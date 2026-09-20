import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/models/store_price_comparison/store_price_comparison.dart';
import 'package:spend_lens/features/analytics/domain/price_history/store_price_comparator.dart';
import 'package:spend_lens/features/store/domain/models/store/e_store_type.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';

/// REGRESSION: products became per-store, so the same goods at two stores
/// are two product rows with two ids. The comparator grouped observations by
/// a SINGLE productId, which meant the cross-store "cheaper by" line — the
/// most visible thing on the store-detail screen — would report
/// "Only bought here" for every product, forever, with no error to notice.
///
/// The user's manual link is the join. These tests pin both halves: that an
/// UNLINKED product still honestly reports "only here", and that linking
/// restores the real comparison.
void main() {
  final now = DateTime(2026, 9, 19);

  PriceObservation observation({
    required String id,
    required String productId,
    required String storeId,
    required double price,
    DateTime? observedAt,
  }) => PriceObservation(
    id: id,
    productId: productId,
    storeId: storeId,
    receiptId: 'receipt-$id',
    observedAt: observedAt ?? now,
    comparableUnitPrice: price,
    currencyCode: 'MDL',
    updatedAt: now,
  );

  Store store(String id, String name) => Store(
    id: id,
    name: name,
    type: EStoreType.supermarket,
    updatedAt: now,
  );

  final stores = [
    store('store-1', 'Fidesco'),
    store('store-2', 'Nr.1'),
    store('store-3', 'Linella'),
  ];

  test('UNLINKED per-store products report onlyHere — the trade-off', () {
    final result = compareStorePriceForProduct(
      productId: 'milk-at-1',
      atStoreId: 'store-1',
      allObservations: [
        observation(id: '1', productId: 'milk-at-1', storeId: 'store-1', price: 14.58),
        observation(id: '2', productId: 'milk-at-2', storeId: 'store-2', price: 12.10),
      ],
      stores: stores,
    );

    expect(result, isNotNull);
    expect(result!.key, EStorePriceComparisonKey.onlyHere);
    expect(result.isBetterHere, isNull);
  });

  test('LINKING restores the cross-store comparison', () {
    final result = compareStorePriceForProduct(
      productId: 'milk-at-1',
      atStoreId: 'store-1',
      allObservations: [
        observation(id: '1', productId: 'milk-at-1', storeId: 'store-1', price: 14.58),
        observation(id: '2', productId: 'milk-at-2', storeId: 'store-2', price: 12.10),
      ],
      stores: stores,
      comparableProductIds: {'milk-at-1', 'milk-at-2'},
    );

    expect(result!.key, EStorePriceComparisonKey.cheaperBy);
    expect(result.isBetterHere, isFalse, reason: 'costlier at store-1');
    expect(result.params[0], 'Nr.1');
    expect(result.params[2], '2.48');
  });

  test('the result still reports the ROW own product id', () {
    final result = compareStorePriceForProduct(
      productId: 'milk-at-1',
      atStoreId: 'store-1',
      allObservations: [
        observation(id: '1', productId: 'milk-at-1', storeId: 'store-1', price: 10.00),
        observation(id: '2', productId: 'milk-at-2', storeId: 'store-2', price: 12.10),
      ],
      stores: stores,
      comparableProductIds: {'milk-at-1', 'milk-at-2'},
    );

    expect(result!.productId, 'milk-at-1');
    expect(result.isBetterHere, isTrue, reason: 'cheaper at store-1');
  });

  test('a three-store link group yields cheapestOf(3)', () {
    final result = compareStorePriceForProduct(
      productId: 'milk-at-1',
      atStoreId: 'store-1',
      allObservations: [
        observation(id: '1', productId: 'milk-at-1', storeId: 'store-1', price: 9.00),
        observation(id: '2', productId: 'milk-at-2', storeId: 'store-2', price: 12.10),
        observation(id: '3', productId: 'milk-at-3', storeId: 'store-3', price: 11.00),
      ],
      stores: stores,
      comparableProductIds: {'milk-at-1', 'milk-at-2', 'milk-at-3'},
    );

    expect(result!.key, EStorePriceComparisonKey.cheapestOf);
    expect(result.isBetterHere, isTrue);
    expect(result.params[0], 3);
  });

  test('a linked id with no observations changes nothing', () {
    final result = compareStorePriceForProduct(
      productId: 'milk-at-1',
      atStoreId: 'store-1',
      allObservations: [
        observation(id: '1', productId: 'milk-at-1', storeId: 'store-1', price: 14.58),
      ],
      stores: stores,
      comparableProductIds: {'milk-at-1', 'ghost'},
    );

    expect(result!.key, EStorePriceComparisonKey.onlyHere);
  });

  test('a link whose partner sells only at THIS store is still onlyHere', () {
    final result = compareStorePriceForProduct(
      productId: 'milk-at-1',
      atStoreId: 'store-1',
      allObservations: [
        observation(id: '1', productId: 'milk-at-1', storeId: 'store-1', price: 14.58),
        observation(id: '2', productId: 'milk-alt', storeId: 'store-1', price: 13.00),
      ],
      stores: stores,
      comparableProductIds: {'milk-at-1', 'milk-alt'},
    );

    expect(result!.key, EStorePriceComparisonKey.onlyHere);
  });

  test('across a link group, the LATEST price at this store wins', () {
    final result = compareStorePriceForProduct(
      productId: 'milk-at-1',
      atStoreId: 'store-1',
      allObservations: [
        observation(
          id: '1',
          productId: 'milk-at-1',
          storeId: 'store-1',
          price: 20.00,
          observedAt: DateTime(2026, 1, 1),
        ),
        // A linked product also observed at store-1, more recently.
        observation(
          id: '2',
          productId: 'milk-alt',
          storeId: 'store-1',
          price: 11.00,
          observedAt: DateTime(2026, 9, 1),
        ),
        observation(id: '3', productId: 'milk-at-2', storeId: 'store-2', price: 12.10),
      ],
      stores: stores,
      comparableProductIds: {'milk-at-1', 'milk-alt', 'milk-at-2'},
    );

    expect(
      result!.isBetterHere,
      isTrue,
      reason: 'the 11.00 from September is the current price here, not the 20.00',
    );
  });

  test('a tombstoned observation never enters a linked comparison', () {
    final result = compareStorePriceForProduct(
      productId: 'milk-at-1',
      atStoreId: 'store-1',
      allObservations: [
        observation(id: '1', productId: 'milk-at-1', storeId: 'store-1', price: 14.58),
        observation(
          id: '2',
          productId: 'milk-at-2',
          storeId: 'store-2',
          price: 12.10,
        ).copyWith(deletedAt: now),
      ],
      stores: stores,
      comparableProductIds: {'milk-at-1', 'milk-at-2'},
    );

    expect(result!.key, EStorePriceComparisonKey.onlyHere);
  });
}
