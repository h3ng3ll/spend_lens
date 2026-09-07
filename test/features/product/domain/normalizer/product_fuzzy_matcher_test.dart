import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/product/domain/normalizer/product_fuzzy_matcher.dart';

void main() {
  const matcher = ProductFuzzyMatcher();

  test('matches a single-character OCR-noise near-miss', () {
    final match = matcher.findClosestMatch('lapte zuzu 1l', [
      'lapte zuzu ll', // one char off (1 -> l)
      'paine alba',
    ]);
    expect(match, 'lapte zuzu ll');
  });

  test('CONSERVATIVE: a genuinely different product does not match (spec §42)', () {
    final match = matcher.findClosestMatch('paine neagra', [
      'paine alba',
      'lapte zuzu',
    ]);
    expect(match, isNull);
  });

  test('returns null when no candidate exists at all', () {
    expect(matcher.findClosestMatch('rosii', const []), isNull);
  });

  test('an exact match returns itself', () {
    expect(
      matcher.findClosestMatch('rosii', ['rosii', 'castraveti']),
      'rosii',
    );
  });
}
