import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/models/e_sync_status.dart';
import 'package:spend_lens/features/product/domain/models/product/e_unit.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/product/domain/normalizer/product_match_result.dart';
import 'package:spend_lens/features/product/domain/normalizer/product_normalizer.dart';

void main() {
  final normalizer = ProductNormalizer(now: () => DateTime(2026, 9, 7));

  Product product(String normalizedName, {List<String> aliases = const []}) {
    return Product(
      id: 'p-$normalizedName',
      normalizedName: normalizedName,
      displayName: normalizedName,
      aliases: aliases,
      updatedAt: DateTime(2026, 1, 1),
    );
  }

  test('exact match resolves to the existing product', () {
    final existing = [product('lapte zuzu 1l')];
    final result = normalizer.normalize(
      rawName: 'LAPTE ZUZU 1L',
      existingProducts: existing,
      generateId: () => 'new-id',
    );

    expect(result.outcome, ENormalizerOutcome.exactMatch);
    expect(result.product.id, existing.first.id);
  });

  test('an alias also counts as an exact match', () {
    final existing = [
      product('lapte zuzu 1l', aliases: const ['lgm zuzu 1l']),
    ];
    final result = normalizer.normalize(
      rawName: 'LGM ZUZU 1L',
      existingProducts: existing,
      generateId: () => 'new-id',
    );

    expect(result.outcome, ENormalizerOutcome.exactMatch);
  });

  test('a close OCR-noise near-miss fuzzy-matches to the existing product', () {
    final existing = [product('lapte zuzu 1l')];
    // A SINGLE-CHARACTER substitution (the '1'/'l' OCR confusion swaps ONE
    // character, edit distance 1) — the exact "single-character OCR noise"
    // case the conservative fuzzy threshold is tuned to still catch. A
    // TRANSPOSITION ('l1' vs '1l') is edit distance 2 under Levenshtein and
    // is deliberately NOT close enough — see the sibling test below, which
    // asserts that genuinely different names create rather than merge.
    final result = normalizer.normalize(
      rawName: 'LAPTE ZUZU ll', // '1' misread as 'l'
      existingProducts: existing,
      generateId: () => 'new-id',
    );

    expect(result.outcome, ENormalizerOutcome.fuzzyMatch);
    expect(result.product.id, existing.first.id);
  });

  group('CONSERVATIVE: a genuine near-miss CREATES rather than merges (spec §42)', () {
    test('a different product entirely creates a new one', () {
      final existing = [product('paine alba')];
      final result = normalizer.normalize(
        rawName: 'LAPTE ZUZU 1L',
        existingProducts: existing,
        generateId: () => 'created-id',
      );

      expect(result.outcome, ENormalizerOutcome.created);
      expect(result.isNewProduct, isTrue);
      expect(result.product.id, 'created-id');
      // The created product must NOT silently become an alias of the
      // unrelated existing product.
      expect(result.product.id, isNot(existing.first.id));
    });

    test('a moderately-similar but genuinely different product also creates new', () {
      final existing = [product('paine neagra')];
      final result = normalizer.normalize(
        rawName: 'PAINE ALBA',
        existingProducts: existing,
        generateId: () => 'created-id-2',
      );

      // 'paine alba' vs 'paine neagra' is similar enough to LOOK related to
      // a human, but not close enough to clear the conservative fuzzy
      // threshold — this is exactly the false-merge risk spec §42 guards
      // against.
      expect(result.outcome, ENormalizerOutcome.created);
    });
  });

  test('an empty product list always creates a new product', () {
    final result = normalizer.normalize(
      rawName: 'ROSII',
      existingProducts: const [],
      generateId: () => 'first-id',
    );
    expect(result.outcome, ENormalizerOutcome.created);
    expect(result.product.displayName, 'ROSII');
  });

  test('a created product carries the requested default unit and pendingCreate sync status', () {
    final result = normalizer.normalize(
      rawName: 'ROSII',
      existingProducts: const [],
      generateId: () => 'id',
      defaultUnit: EUnit.kilogram,
    );
    expect(result.product.defaultUnit, EUnit.kilogram);
    expect(result.product.syncStatus, ESyncStatus.pendingCreate);
  });
}
