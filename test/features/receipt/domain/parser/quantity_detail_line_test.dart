import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/receipt/domain/parser/receipt_parser.dart';

import '../../../../fixtures/synthetic_receipt_fixtures.dart';

/// REGRESSION: the Kaufland two-row layout parsed badly in four ways.
///
/// The receipt prints each item as `NAME ........ TOTAL A`, then an
/// INDENTED `qty x unitPrice` line beneath it. Every defect below was
/// visible in one scan:
///
///  1. the price stayed IN the name — `TESS CEAI 188G 139.88 A`;
///  2. the detail line was discarded, so a two-pack reported quantity 1;
///  3. `SUMA 1054.38` was read as **38.00**;
///  4. 38.00 then failed the plausibility floor, so the receipt reported
///     no printed total at all.
void main() {
  final parsed = const ReceiptParser().parse(
    SyntheticReceiptFixtures.quantityDetailLineReceipt(),
  );

  test('the price is not part of the product name', () {
    expect(
      parsed.items.map((item) => item.rawName),
      ['TESS CEAI 180G', 'TAITEI VITA 85G', 'BANANE'],
      reason: 'THE BUG: names came out as `TESS CEAI 188G 139.88 A` — the '
          'trailing VAT class letter defeated a `\$`-anchored price strip',
    );
  });

  test('the detail line supplies the quantity', () {
    final taitei = parsed.items.firstWhere(
      (item) => item.rawName == 'TAITEI VITA 85G',
    );

    expect(
      taitei.quantity,
      2.0,
      reason: 'THE BUG: the `2.000 x 13.40` line was dropped and the '
          'two-pack was recorded as a single unit',
    );
    expect(taitei.unitPrice, 13.40);
  });

  test('a weighed quantity survives too', () {
    final banane = parsed.items.firstWhere(
      (item) => item.rawName == 'BANANE',
    );

    expect(banane.quantity, closeTo(0.868, 0.0001));
    expect(banane.unitPrice, closeTo(25.50, 0.001));
  });

  test('the PRINTED total wins over qty x unitPrice', () {
    final banane = parsed.items.firstWhere(
      (item) => item.rawName == 'BANANE',
    );

    // 0.868 x 25.50 = 22.134. The receipt printed 22.13, and the paper is
    // what the user reconciles against.
    expect(banane.lineTotal, 22.13);
  });

  test('a four-digit total with no thousands separator reads whole', () {
    expect(
      parsed.total,
      1054.38,
      reason: 'THE BUG: the token pattern required 1-3 digits before the '
          'separator, so `1054.38` matched as `1054` and `38` and the LAST '
          'token — 38.00 — became the total',
    );
  });

  test('every item is emitted exactly once', () {
    // The detail line must be CONSUMED, never counted as its own item —
    // that is what doubled subtotals on earlier receipts.
    expect(parsed.items.length, 3);
    expect(
      parsed.items.map((item) => item.lineIndex),
      [0, 1, 2],
      reason: 'lineIndex must stay contiguous when a line is consumed',
    );
  });

  test('the item sum stays honest', () {
    expect(parsed.itemsTotal, closeTo(139.80 + 26.80 + 22.13, 0.001));
  });
}
