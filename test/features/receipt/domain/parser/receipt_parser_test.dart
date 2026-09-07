import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/product/domain/models/product/e_unit.dart';
import 'package:spend_lens/features/receipt/domain/parser/receipt_parser.dart';

import '../../../../fixtures/synthetic_receipt_fixtures.dart';

void main() {
  const parser = ReceiptParser();

  test('parses a clean single-column receipt end to end', () {
    final result = parser.parse(SyntheticReceiptFixtures.cleanSingleColumnReceipt());

    expect(result.storeName, 'KAUFLAND MOLDOVA');
    expect(result.purchasedAt, DateTime(2026, 9, 7));
    expect(result.total, 151.10);
    expect(result.items.length, 3);
    expect(result.isUnusable, isFalse);
  });

  group('the total comes from semantic keywords, never the largest number (§35)', () {
    test('a receipt whose LARGEST printed number is a barcode still resolves the right total', () {
      final result = parser.parse(
        SyntheticReceiptFixtures.barcodeLargerThanTotalReceipt(),
      );

      // The barcode (5941234567890) is vastly larger than the real total —
      // a "largest number" heuristic would return it. The correct
      // behaviour is the keyword-matched TOTAL DE PLATA line's own value.
      expect(result.total, 30.80);
      expect(result.total, isNot(5941234567890.0));
    });

    test('the barcode line itself never becomes an item candidate', () {
      final result = parser.parse(
        SyntheticReceiptFixtures.barcodeLargerThanTotalReceipt(),
      );
      expect(
        result.items.any((item) => item.lineTotal == 5941234567890.0),
        isFalse,
      );
    });
  });

  group('two-column layout (design_spendlens.md §11)', () {
    test('resolves item names and prices correctly from a two-column receipt', () {
      final result = parser.parse(SyntheticReceiptFixtures.twoColumnReceipt());

      expect(result.storeName, 'LIDL');
      expect(result.total, 47.10);
      expect(result.items.length, 3);

      final milk = result.items.firstWhere((i) => i.rawName.contains('MILK'));
      expect(milk.lineTotal, 22.90);
    });
  });

  group('weighed lines (design_spendlens.md §11)', () {
    test('recognizes both kg and g weighed lines with comparable unit prices', () {
      final result = parser.parse(SyntheticReceiptFixtures.weighedLinesReceipt());

      final tomatoes = result.items.firstWhere((i) => i.rawName.contains('ROSII'));
      expect(tomatoes.unit, EUnit.kilogram);
      expect(tomatoes.quantity, 1.2);
      expect(tomatoes.unitPrice, 104.0);

      final cucumbers = result.items.firstWhere(
        (i) => i.rawName.contains('CASTRAVETI'),
      );
      expect(cucumbers.quantity, 0.5);
      expect(cucumbers.unitPrice, 40.0);

      expect(result.total, 144.85);
    });
  });

  test('merged lines still extract a price even when a name is imperfect', () {
    final result = parser.parse(SyntheticReceiptFixtures.mergedLinesReceipt());
    expect(result.total, 33.50);
    expect(result.items, isNotEmpty);
  });

  test('a receipt with blurred/punctuation-noisy lines still resolves a total', () {
    final result = parser.parse(
      SyntheticReceiptFixtures.blurredAndPunctuationNoiseReceipt(),
    );
    expect(result.total, 30.50);
  });

  test('an unparseable OCR stream (no items, no total) is reported as unusable', () {
    final result = parser.parse(const []);
    expect(result.isUnusable, isTrue);
    expect(result.total, isNull);
    expect(result.items, isEmpty);
  });

  test('itemsTotal sums every item candidate line total', () {
    final result = parser.parse(SyntheticReceiptFixtures.cleanSingleColumnReceipt());
    expect(result.itemsTotal, closeTo(22.90 + 7.90 + 104.00, 0.001));
  });
}
