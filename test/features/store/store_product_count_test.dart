import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/store/presentation/utils/store_aggregates.dart';

/// REGRESSION: the Stores list and the store-detail stat card both rendered a
/// HARDCODED `0` for "products" — `lo.storeMeta(visits, 0)` and
/// `value: '0'`. A store with a 31-item receipt attached still read
/// "1 visit · 0 products", which read as data loss but was a literal.
PriceObservation observation({
  required String id,
  required String productId,
  String? storeId,
  DateTime? deletedAt,
}) => PriceObservation(
  id: id,
  productId: productId,
  storeId: storeId,
  receiptId: 'receipt-1',
  observedAt: DateTime(2026, 9, 19),
  comparableUnitPrice: 17.98,
  currencyCode: 'MDL',
  updatedAt: DateTime(2026, 9, 19),
  deletedAt: deletedAt,
);

void main() {
  test('counts the distinct products observed at the store', () {
    final count = productCountForStore([
      observation(id: '1', productId: 'milk', storeId: 'store-1'),
      observation(id: '2', productId: 'bread', storeId: 'store-1'),
    ], 'store-1');

    expect(count, 2);
  });

  test('counts one product bought on several visits ONCE', () {
    // The same product across three receipts is one product in the store's
    // catalogue, not three — otherwise the number grows on every shop.
    final count = productCountForStore([
      observation(id: '1', productId: 'milk', storeId: 'store-1'),
      observation(id: '2', productId: 'milk', storeId: 'store-1'),
      observation(id: '3', productId: 'milk', storeId: 'store-1'),
    ], 'store-1');

    expect(count, 1);
  });

  test('ignores observations belonging to another store', () {
    final count = productCountForStore([
      observation(id: '1', productId: 'milk', storeId: 'store-1'),
      observation(id: '2', productId: 'bread', storeId: 'store-2'),
    ], 'store-1');

    expect(count, 1);
  });

  test('ignores tombstoned observations', () {
    // Same predicate `ProductsHereCard` uses, so the list's number and the
    // detail page's list can never disagree.
    final count = productCountForStore([
      observation(id: '1', productId: 'milk', storeId: 'store-1'),
      observation(
        id: '2',
        productId: 'bread',
        storeId: 'store-1',
        deletedAt: DateTime(2026, 9, 19),
      ),
    ], 'store-1');

    expect(count, 1);
  });

  test('ignores store-less observations', () {
    final count = productCountForStore([
      observation(id: '1', productId: 'milk'),
    ], 'store-1');

    expect(count, 0);
  });

  test('is zero for a store with no observations', () {
    expect(productCountForStore(const [], 'store-1'), 0);
  });
}
