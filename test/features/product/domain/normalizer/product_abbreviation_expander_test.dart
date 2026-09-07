import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/product/domain/normalizer/product_abbreviation_expander.dart';

void main() {
  const expander = ProductAbbreviationExpander();

  test('expands a known abbreviation word', () {
    expect(expander.expand('franz griu'), 'franzela griu');
  });

  test('leaves an unrecognized word unchanged', () {
    expect(expander.expand('rosii'), 'rosii');
  });

  test('expands only the abbreviated word, leaving the rest of the phrase intact', () {
    expect(expander.expand('lgm zuzu 1l'), 'lapte zuzu 1l');
  });
}
