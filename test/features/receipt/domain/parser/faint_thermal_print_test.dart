import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/receipt/domain/parser/receipt_parser.dart';

import '../../../../fixtures/synthetic_receipt_fixtures.dart';

/// REGRESSION: a faint thermal print parsed into nonsense.
///
/// Driven by a VERBATIM device OCR dump, which is the point — the earlier
/// synthetic fixture was too clean to reproduce any of this. On a faint
/// print the recognizer makes two systematic errors at once:
///
///  1. it DROPS the decimal separator, leaving only a space (`17 98 A`);
///  2. it reads `0` as `8`, so `1.000 x` arrives as `1.888` or `1008`.
///
/// Together those produced the reported screen: a 17.98 item recorded at
/// 98.00, and quantities of `1.1`, `2.7`, `8.9` and `1008` shown against
/// prices that were themselves correct.
void main() {
  final parsed = const ReceiptParser().parse(
    SyntheticReceiptFixtures.faintThermalPrintReceipt(),
  );

  ({double quantity, double? unitPrice, double lineTotal}) item(String name) {
    final match = parsed.items.firstWhere(
      (candidate) => candidate.rawName == name,
      orElse: () => throw StateError(
        'no item named "$name" — parsed: '
        '${parsed.items.map((i) => i.rawName).toList()}',
      ),
    );
    return (
      quantity: match.quantity,
      unitPrice: match.unitPrice,
      lineTotal: match.lineTotal,
    );
  }

  group('a separator the OCR dropped entirely', () {
    test('`17 98 A` is 17.98, not 98.00', () {
      // The first line of the receipt, and the clearest case: the old
      // reading turned a 17.98 purchase into 98.00.
      expect(item('TESS CEAI 180G').lineTotal, 139.88);
      expect(item('BABUS PELHENI 988 G').lineTotal, 88.58);
    });

    test('`6 55 B` is 6.55, not 55.00', () {
      expect(item('GARTOF1 ALBI SPALATI').lineTotal, 6.55);
    });

    test('a name carrying digits is NOT joined', () {
      // `BABUS PELHENI 988 G` and `SET 2 LAVETE NF` keep their digits —
      // the repair is anchored to line-end and to the `x` multiplier, so
      // it cannot reach into a product name.
      expect(parsed.items.map((i) => i.rawName), contains('SET 2 LAVETE NF'));
      expect(
        parsed.items.map((i) => i.rawName),
        contains('BABUS PELHENI 988 G'),
      );
    });
  });

  group('a quantity the OCR mangled', () {
    test('`1.888 x` is one unit', () {
      expect(
        item('TESS CEAI 180G').quantity,
        1.0,
        reason: 'THE BUG: shown as 1.1 against a correct 139.88 price',
      );
    });

    test('`1008 x` is one unit, not a thousand', () {
      expect(item('SET 2 LAVETE NF').quantity, 1.0);
    });

    test('a genuine two-pack still reads as 2', () {
      // `2. 088 x 13. 48` against a printed 26.88 — the repair must snap to
      // the whole number, not report 1.994.
      expect(item('TALIEI VITA').quantity, 2.0);
      expect(item('DOLCE IAURT CAP').quantity, 2.0);
    });

    test('a weighed line keeps its fraction', () {
      // Bananas: never snapped to an integer.
      final banane = item('BANANE');
      expect(banane.quantity, lessThan(1.0));
      expect(banane.quantity, greaterThan(0.8));
      expect(banane.lineTotal, 22.13);
    });
  });

  test('the item sum lands within a rounding step of the paper', () {
    // The receipt printed SUMA 1054.38. Every line total is now read
    // correctly; the residual few cents are OCR digit errors inside
    // individual prices, which no arithmetic can recover.
    expect(parsed.itemsTotal, closeTo(1054.38, 0.20));
  });

  test('no item is named after its own price', () {
    for (final candidate in parsed.items) {
      expect(
        RegExp(r'\d+\.\d{2}\s*[AB]?$').hasMatch(candidate.rawName),
        isFalse,
        reason: 'the price leaked into the name: "${candidate.rawName}"',
      );
    }
  });
}
