import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/product/domain/normalizer/product_name_cleaner.dart';

void main() {
  const cleaner = ProductNameCleaner();

  test('lowercases and collapses whitespace', () {
    expect(cleaner.clean('  LAPTE   ZUZU  1L  '), 'lapte zuzu 1l');
  });

  test('strips punctuation while keeping letters/digits', () {
    expect(cleaner.clean('BISCUITI, 18.50G'), 'biscuiti 18 50g');
  });

  test('handles diacritics without crashing', () {
    expect(cleaner.clean('CAFEA NATURALĂ 250G'), 'cafea naturală 250g');
  });
}
