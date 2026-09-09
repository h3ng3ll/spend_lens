import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/models/store_price_comparison/store_price_comparison.dart';
import 'package:spend_lens/features/analytics/domain/price_history/store_price_comparator.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';

PriceObservation _observation({
  required String id,
  required String productId,
  required String storeId,
  required double unitPrice,
  DateTime? observedAt,
  String currencyCode = 'MDL',
}) {
  final at = observedAt ?? DateTime(2026, 9, 1);
  return PriceObservation(
    id: id,
    productId: productId,
    storeId: storeId,
    receiptId: 'r-$id',
    observedAt: at,
    comparableUnitPrice: unitPrice,
    currencyCode: currencyCode,
    updatedAt: at,
  );
}

Store _store(String id, String name) {
  return Store(id: id, name: name, updatedAt: DateTime(2026));
}

void main() {
  group('compareStorePriceForProduct', () {
    final stores = [_store('kaufland', 'Kaufland'), _store('linella', 'Linella')];

    test('onlyHere when the product was bought at exactly one store', () {
      final observations = [
        _observation(
          id: '1',
          productId: 'milk',
          storeId: 'kaufland',
          unitPrice: 21.90,
        ),
      ];

      final result = compareStorePriceForProduct(
        productId: 'milk',
        atStoreId: 'kaufland',
        allObservations: observations,
        stores: stores,
      );

      expect(result!.key, EStorePriceComparisonKey.onlyHere);
      expect(result.isBetterHere, isNull);
      expect(result.params, isEmpty);
    });

    test('cheaperBy(true) when this store is cheaper than the one alternative', () {
      final observations = [
        _observation(
          id: '1',
          productId: 'milk',
          storeId: 'kaufland',
          unitPrice: 20.0,
        ),
        _observation(
          id: '2',
          productId: 'milk',
          storeId: 'linella',
          unitPrice: 22.0,
        ),
      ];

      final result = compareStorePriceForProduct(
        productId: 'milk',
        atStoreId: 'kaufland',
        allObservations: observations,
        stores: stores,
      );

      expect(result!.key, EStorePriceComparisonKey.cheaperBy);
      expect(result.isBetterHere, isTrue);
    });

    test('cheaperBy(false) when a cheaper alternative exists elsewhere', () {
      final observations = [
        _observation(
          id: '1',
          productId: 'milk',
          storeId: 'kaufland',
          unitPrice: 22.0,
        ),
        _observation(
          id: '2',
          productId: 'milk',
          storeId: 'linella',
          unitPrice: 20.0,
        ),
      ];

      final result = compareStorePriceForProduct(
        productId: 'milk',
        atStoreId: 'kaufland',
        allObservations: observations,
        stores: stores,
      );

      expect(result!.key, EStorePriceComparisonKey.cheaperBy);
      expect(result.isBetterHere, isFalse);
      expect(result.params[0], 'Linella');
    });

    test('cheapestOf when 3+ stores and this one is cheapest', () {
      final threeStores = [
        ...stores,
        _store('lidl', 'Lidl'),
      ];
      final observations = [
        _observation(
          id: '1',
          productId: 'milk',
          storeId: 'kaufland',
          unitPrice: 18.0,
        ),
        _observation(
          id: '2',
          productId: 'milk',
          storeId: 'linella',
          unitPrice: 22.0,
        ),
        _observation(
          id: '3',
          productId: 'milk',
          storeId: 'lidl',
          unitPrice: 20.0,
        ),
      ];

      final result = compareStorePriceForProduct(
        productId: 'milk',
        atStoreId: 'kaufland',
        allObservations: observations,
        stores: threeStores,
      );

      expect(result!.key, EStorePriceComparisonKey.cheapestOf);
      expect(result.isBetterHere, isTrue);
      expect(result.params, [3]);
    });

    test('a stored currency code never excludes a store from the comparison', () {
      final observations = [
        _observation(
          id: '1',
          productId: 'milk',
          storeId: 'kaufland',
          unitPrice: 20.0,
        ),
        _observation(
          id: '2',
          productId: 'milk',
          storeId: 'linella',
          unitPrice: 5.0,
          currencyCode: 'EUR',
        ),
      ];

      final result = compareStorePriceForProduct(
        productId: 'milk',
        atStoreId: 'kaufland',
        allObservations: observations,
        stores: stores,
      );

      // Currency is a display label, so Linella's observation still counts
      // and the two stores are genuinely compared. Excluding it used to
      // collapse this to `onlyHere`, hiding a real cheaper alternative.
      expect(result!.key, isNot(EStorePriceComparisonKey.onlyHere));
      expect(result.isBetterHere, isFalse);
    });

    test('returns null when there is no observation for this product at this store', () {
      final observations = [
        _observation(
          id: '1',
          productId: 'milk',
          storeId: 'linella',
          unitPrice: 20.0,
        ),
      ];

      final result = compareStorePriceForProduct(
        productId: 'milk',
        atStoreId: 'kaufland',
        allObservations: observations,
        stores: stores,
      );

      expect(result, isNull);
    });
  });
}
