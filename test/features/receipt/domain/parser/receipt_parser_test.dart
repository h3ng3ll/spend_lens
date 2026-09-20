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

  group('a VAT/percentage rate line never becomes a product', () {
    // A receipt's VAT block prints a bare rate row. When the line grouper
    // splits the `TVA` label away (or OCR loses it), the row has no keyword
    // to veto it, no letters for `isNameOnlyLine` to park it, and the
    // candidate builder's trailing-digit strip is blocked by the `%` — so
    // `1.008 %` passed every guard and became a Product priced at 19.95.
    test('the rate row is not emitted as an item', () {
      final result = parser.parse(
        SyntheticReceiptFixtures.vatRateLineAboveTotalReceipt(),
      );

      expect(
        result.items.any((item) => item.rawName.contains('%')),
        isFalse,
        reason: 'A letterless rate row names no product.',
      );
      expect(result.items.length, 3);
      expect(
        result.items.map((item) => item.rawName),
        ['LAPTE ZUZU 1L', 'FRANZELA GRIU', 'ROSII'],
      );
    });

    test('the rate amount is excluded from itemsTotal', () {
      final result = parser.parse(
        SyntheticReceiptFixtures.vatRateLineAboveTotalReceipt(),
      );

      // 22.90 + 7.90 + 120.30 — the phantom 19.95 would make it 171.05.
      expect(result.itemsTotal, closeTo(151.10, 0.01));
    });

    test('the printed total SURVIVES — the money bug', () {
      final result = parser.parse(
        SyntheticReceiptFixtures.vatRateLineAboveTotalReceipt(),
      );

      // This is the assertion that pins the real damage. VAT is already
      // inside the printed total, so itemizing it pushed `itemsTotal`
      // (171.05) above the printed 151.10; `_plausibleTotal` then judged
      // the CORRECT total arithmetically impossible and returned null, and
      // `CreateExpenseFromReceiptUseCase` recorded the inflated item sum
      // instead — with no mismatch warning, because a null printed total
      // reconciles as "nothing to compare against".
      expect(
        result.total,
        151.10,
        reason: 'A phantom VAT item must not make the real total implausible.',
      );
      expect(result.total, isNotNull);
    });

    test('no item carries an empty rawName', () {
      final result = parser.parse(
        SyntheticReceiptFixtures.vatRateLineAboveTotalReceipt(),
      );

      // An empty `rawName` is the app's sentinel for "manually added by the
      // user" (`EditReceiptBloc`, `UpdateSavedReceiptUseCase`), so a
      // parser-emitted one is indistinguishable from a typed row.
      expect(
        result.items.every((item) => item.rawName.trim().isNotEmpty),
        isTrue,
      );
    });

    test('lineIndex stays contiguous — a dropped line shifts nothing', () {
      final result = parser.parse(
        SyntheticReceiptFixtures.vatRateLineAboveTotalReceipt(),
      );

      // `itemLineIndex` counts EMITTED items, not loop position, so
      // skipping a line leaves no gap and renumbers nothing.
      expect(result.items.map((item) => item.lineIndex).toList(), [0, 1, 2]);
    });
  });

  group('a percentage inside a REAL product name is kept (regression)', () {
    test('the 45% cheese survives as one item at its real price', () {
      final result = parser.parse(
        SyntheticReceiptFixtures.percentageInProductNameReceipt(),
      );

      // The false-positive guard. Keying the rejection on `%` rather than
      // on the absence of letters dropped this line once already, which
      // then stranded its price line as a bogus item of its own.
      expect(result.items.length, 1);
      expect(result.items.single.rawName, 'Branza Maasdam 45% 130g BREST');
      expect(result.items.single.lineTotal, 47.50);
      expect(result.total, 47.50);
    });
  });

  group('an unpaired continuation line never becomes a blank product', () {
    // `ReceiptCandidateBuilder` deliberately allows an empty `rawName` on
    // the expression path, trusting the parser to pair it with the held name
    // fragments. With nothing pending there is nothing to pair — and the
    // parser emitted that empty-named candidate anyway.
    test('the unpaired line is dropped rather than emitted nameless', () {
      final result = parser.parse(
        SyntheticReceiptFixtures.unpairedContinuationLineReceipt(),
      );

      expect(
        result.items.any((item) => item.rawName.trim().isEmpty),
        isFalse,
        reason: 'An empty rawName is the "manually added" sentinel, so a '
            'parser-emitted one is indistinguishable from a typed row.',
      );
      expect(result.items.length, 1);
      expect(result.items.single.rawName, 'LAPTE ZUZU 1L');
    });

    test('its amount is excluded from itemsTotal', () {
      final result = parser.parse(
        SyntheticReceiptFixtures.unpairedContinuationLineReceipt(),
      );

      expect(result.itemsTotal, closeTo(22.90, 0.01));
    });

    test('lineIndex stays contiguous after the drop', () {
      final result = parser.parse(
        SyntheticReceiptFixtures.unpairedContinuationLineReceipt(),
      );

      expect(result.items.map((item) => item.lineIndex).toList(), [0]);
    });
  });

  group('wrapped items still pair correctly (no regression)', () {
    test('a name line plus its price line make ONE item', () {
      // The intentional empty-name allowance must keep working: when a
      // fragment IS pending, the pairing runs exactly as before.
      final result = parser.parse(
        SyntheticReceiptFixtures.percentageInProductNameReceipt(),
      );

      expect(result.items.length, 1);
      expect(result.items.single.rawName, 'Branza Maasdam 45% 130g BREST');
      expect(result.items.single.lineTotal, 47.50);
    });
  });

  group('an amount plus a VAT class code never becomes a product', () {
    test('the stranded amount row is not emitted as an item', () {
      final result = parser.parse(
        SyntheticReceiptFixtures.amountWithVatClassCodeReceipt(),
      );

      // `99.88 A` became a product named after its own price — one trailing
      // tax letter was enough to pass a "has any letter" test.
      expect(
        result.items.any((item) => item.rawName.contains('99.88')),
        isFalse,
      );
      expect(result.items.length, 1);
      expect(result.items.single.rawName, 'LAPTE ZUZU 1L');
    });

    test('its amount is excluded and the printed total survives', () {
      final result = parser.parse(
        SyntheticReceiptFixtures.amountWithVatClassCodeReceipt(),
      );

      expect(result.itemsTotal, closeTo(22.90, 0.01));
      expect(result.total, 22.90);
    });
  });
}
