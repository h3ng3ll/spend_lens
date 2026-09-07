import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/receipt/domain/parser/stages/receipt_text_normalizer.dart';

void main() {
  const normalizer = ReceiptTextNormalizer();

  group('normalizeLine', () {
    test('collapses repeated whitespace', () {
      expect(
        normalizer.normalizeLine('LAPTE    ZUZU   1L'),
        'LAPTE ZUZU 1L',
      );
    });

    test('strips stray punctuation noise (_, ~, `)', () {
      expect(normalizer.normalizeLine('BISCUITI_ 18.50'), 'BISCUITI 18.50');
    });

    test('trims leading/trailing whitespace', () {
      expect(normalizer.normalizeLine('  TOTAL 30.50  '), 'TOTAL 30.50');
    });
  });

  group('fixNumericConfusions (character confusions, design_spendlens.md §10)', () {
    test('O and o become 0 in a numeric-context token', () {
      expect(normalizer.fixNumericConfusions('1O4,OO'), '104,00');
    });

    test('l, I and | become 1 in a numeric-context token', () {
      expect(normalizer.fixNumericConfusions('l04,00'), '104,00');
      expect(normalizer.fixNumericConfusions('I04,00'), '104,00');
    });

    test('S becomes 5 in a numeric-context token', () {
      expect(normalizer.fixNumericConfusions('S941234567890'), '5941234567890');
    });

    test('does NOT mangle a real word with no digits at all', () {
      expect(normalizer.fixNumericConfusions('TOTAL'), 'TOTAL');
      expect(normalizer.fixNumericConfusions('SUMA'), 'SUMA');
    });

    test('does not touch a mixed alnum token that is mostly letters', () {
      // A real product code/name like "COLA" must never become "C0LA".
      expect(normalizer.fixNumericConfusions('COLA'), 'COLA');
    });
  });
}
