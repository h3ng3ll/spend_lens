import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/price_history/price_history_calculator.dart';

PriceObservation _observation({
  required String id,
  required String productId,
  required double unitPrice,
  required DateTime observedAt,
  String currencyCode = 'MDL',
  String? storeId,
}) {
  return PriceObservation(
    id: id,
    productId: productId,
    storeId: storeId,
    receiptId: 'r-$id',
    observedAt: observedAt,
    comparableUnitPrice: unitPrice,
    currencyCode: currencyCode,
    updatedAt: observedAt,
  );
}

void main() {
  group('percentChange', () {
    test('reproduces the design worked example exactly: 18.50 -> 22.90 = +23.8%', () {
      // (22.90 - 18.50) / 18.50 * 100 = 23.7837...% -> rounds to +23.8%
      expect(percentChange(18.50, 22.90), 23.8);
    });

    test('returns null when there is no baseline to compare against', () {
      expect(percentChange(0.0, 22.90), isNull);
    });

    test('negative change when price fell', () {
      expect(percentChange(22.90, 18.50), closeTo(-19.2, 0.001));
    });
  });

  group('buildPriceHistory', () {
    test('reproduces the worked example end-to-end via two observations', () {
      final observations = [
        _observation(
          id: '1',
          productId: 'p1',
          unitPrice: 18.50,
          observedAt: DateTime(2026, 7, 1),
        ),
        _observation(
          id: '2',
          productId: 'p1',
          unitPrice: 22.90,
          observedAt: DateTime(2026, 9, 1),
        ),
      ];

      final summary = buildPriceHistory(
        productId: 'p1',
        allObservations: observations,
        displayCurrencyCode: 'MDL',
      );

      expect(summary.percentChangeFirstToLast, 23.8);
    });

    test('a month with no observation is a muted stub — hasData is false, never fabricated', () {
      final observations = [
        _observation(
          id: '1',
          productId: 'p1',
          unitPrice: 18.50,
          observedAt: DateTime(2026, 7, 1),
        ),
        _observation(
          id: '2',
          productId: 'p1',
          unitPrice: 22.90,
          observedAt: DateTime(2026, 9, 1),
        ),
      ];

      final summary = buildPriceHistory(
        productId: 'p1',
        allObservations: observations,
        displayCurrencyCode: 'MDL',
      );

      // July, August, September -> 3 points; August has no observation.
      expect(summary.points.length, 3);
      expect(summary.points[0].hasData, isTrue);
      expect(summary.points[1].hasData, isFalse);
      expect(summary.points[1].unitPrice, 0.0);
      expect(summary.points[2].hasData, isTrue);
    });

    test('mixed currencies never combine — an observation in another currency is excluded', () {
      final observations = [
        _observation(
          id: '1',
          productId: 'p1',
          unitPrice: 18.50,
          observedAt: DateTime(2026, 7, 1),
        ),
        _observation(
          id: '2',
          productId: 'p1',
          unitPrice: 5.0,
          observedAt: DateTime(2026, 8, 1),
          currencyCode: 'EUR',
        ),
        _observation(
          id: '3',
          productId: 'p1',
          unitPrice: 22.90,
          observedAt: DateTime(2026, 9, 1),
        ),
      ];

      final summary = buildPriceHistory(
        productId: 'p1',
        allObservations: observations,
        displayCurrencyCode: 'MDL',
      );

      // The EUR observation must be excluded, so August is a NO-DATA month,
      // not the 5.0 EUR price masquerading as an MDL one.
      expect(summary.points[1].hasData, isFalse);
      expect(summary.percentChangeFirstToLast, 23.8);
    });

    test('no observations for the product returns an empty summary, not a fabricated one', () {
      final summary = buildPriceHistory(
        productId: 'unknown',
        allObservations: const [],
        displayCurrencyCode: 'MDL',
      );

      expect(summary.points, isEmpty);
      expect(summary.percentChangeFirstToLast, isNull);
    });

    test('multiple observations in the same month keep the LATEST one', () {
      final observations = [
        _observation(
          id: '1',
          productId: 'p1',
          unitPrice: 18.50,
          observedAt: DateTime(2026, 9, 1),
        ),
        _observation(
          id: '2',
          productId: 'p1',
          unitPrice: 20.0,
          observedAt: DateTime(2026, 9, 20),
        ),
      ];

      final summary = buildPriceHistory(
        productId: 'p1',
        allObservations: observations,
        displayCurrencyCode: 'MDL',
      );

      expect(summary.points.length, 1);
      expect(summary.points.first.unitPrice, 20.0);
    });
  });
}
