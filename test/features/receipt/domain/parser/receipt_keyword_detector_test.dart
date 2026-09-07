import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/receipt/domain/parser/stages/receipt_keyword_detector.dart';

void main() {
  const detector = ReceiptKeywordDetector();

  group('all 5 total keywords (design_spendlens.md §11)', () {
    for (final keyword in ReceiptKeywordDetector.totalKeywords) {
      test('"$keyword" classifies as total', () {
        expect(
          detector.classify('$keyword 151.10'),
          EReceiptLineKind.total,
        );
      });
    }
  });

  test('discount keyword classifies as discount', () {
    expect(detector.classify('REDUCERE 5.00'), EReceiptLineKind.discount);
  });

  test('a product line classifies as itemCandidate', () {
    expect(detector.classify('LAPTE ZUZU 1L 22.90'), EReceiptLineKind.itemCandidate);
  });

  test('classification is case-insensitive', () {
    expect(detector.classify('total de plata 151.10'), EReceiptLineKind.total);
  });

  test('a barcode-only line (no keyword) classifies as itemCandidate, not total', () {
    expect(detector.classify('5941234567890'), EReceiptLineKind.itemCandidate);
  });
}
