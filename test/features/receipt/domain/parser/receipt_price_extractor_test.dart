import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/receipt/domain/parser/stages/receipt_price_extractor.dart';

void main() {
  const extractor = ReceiptPriceExtractor();

  group('the 5 price formats (design_spendlens.md §11)', () {
    test('dot decimal', () {
      expect(extractor.parse('104.00'), 104.00);
    });

    test('comma decimal (Romanian/Moldovan convention)', () {
      expect(extractor.parse('104,00'), 104.00);
    });

    test('bare integer', () {
      expect(extractor.parse('104'), 104.0);
    });

    test('dot thousands + comma decimal', () {
      expect(extractor.parse('1.234,56'), 1234.56);
    });

    test('comma thousands + dot decimal', () {
      expect(extractor.parse('1,234.56'), 1234.56);
    });
  });

  test('extractLastPrice picks the LAST numeric token on the line', () {
    expect(extractor.extractLastPrice('LAPTE ZUZU 1L 22.90'), 22.90);
  });

  test('extractLastPrice returns null when the line has no numbers', () {
    expect(extractor.extractLastPrice('TOTAL DE PLATA'), isNull);
  });

  test('extractAll returns every price-shaped token in order', () {
    expect(
      extractor.extractAll('1 x 22.90 = 22.90'),
      [1.0, 22.90, 22.90],
    );
  });

  test('a barcode-length digit string still parses as A number, but is not treated specially here', () {
    // ReceiptPriceExtractor is a pure formatter — deciding a barcode line
    // is NOT the total is the keyword detector's job, exercised in
    // receipt_parser_test.dart's "barcode larger than total" case.
    expect(extractor.parse('5941234567890'), 5941234567890.0);
  });
}
