import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/product/domain/normalizer/product_match_result.dart';
import 'package:spend_lens/features/product/domain/normalizer/product_normalizer.dart';

/// REGRESSION: the normalizer matched every candidate product regardless of
/// store. Under per-store products that defeats the model on the very first
/// scan — a "LAPTE" bought at the second store resolves to the first store's
/// product, both stores' prices pile onto one row, and each store stops
/// owning its own price line.
///
/// Scoping also protects the other direction: a scan whose store failed to
/// resolve must NOT bind to some store's product, or prices would silently
/// be attributed to a shop the receipt never named.
void main() {
  final normalizer = ProductNormalizer(now: () => DateTime(2026, 9, 19));
  var nextId = 0;
  String generateId() => 'generated-${nextId++}';

  Product product({
    required String id,
    required String normalizedName,
    String? storeId,
    List<String> aliases = const [],
  }) => Product(
    id: id,
    normalizedName: normalizedName,
    displayName: normalizedName,
    storeId: storeId,
    aliases: aliases,
    updatedAt: DateTime(2026, 9, 1),
  );

  setUp(() => nextId = 0);

  test('a same-named product at ANOTHER store is not substituted', () {
    final result = normalizer.normalize(
      rawName: 'lapte',
      existingProducts: [
        product(id: 'other', normalizedName: 'lapte', storeId: 'store-2'),
      ],
      generateId: generateId,
      storeId: 'store-1',
    );

    expect(result.outcome, ENormalizerOutcome.created);
    expect(result.product.storeId, 'store-1');
    expect(result.product.id, 'generated-0');
  });

  test('a same-named product at THIS store is substituted', () {
    final result = normalizer.normalize(
      rawName: 'lapte',
      existingProducts: [
        product(id: 'mine', normalizedName: 'lapte', storeId: 'store-1'),
        product(id: 'other', normalizedName: 'lapte', storeId: 'store-2'),
      ],
      generateId: generateId,
      storeId: 'store-1',
    );

    expect(result.outcome, ENormalizerOutcome.exactMatch);
    expect(result.product.id, 'mine');
  });

  test('a general-purpose product is adoptable by any store', () {
    final result = normalizer.normalize(
      rawName: 'lapte',
      existingProducts: [
        product(id: 'general', normalizedName: 'lapte'),
      ],
      generateId: generateId,
      storeId: 'store-1',
    );

    expect(result.outcome, ENormalizerOutcome.exactMatch);
    expect(result.product.id, 'general');
  });

  test('a store-less scan never binds to a store-owned product', () {
    final result = normalizer.normalize(
      rawName: 'lapte',
      existingProducts: [
        product(id: 'owned', normalizedName: 'lapte', storeId: 'store-1'),
      ],
      generateId: generateId,
    );

    expect(result.outcome, ENormalizerOutcome.created);
    expect(
      result.product.storeId,
      isNull,
      reason: 'a scan with no resolved store creates a general-purpose product',
    );
  });

  test('a store-less scan DOES match a general-purpose product', () {
    final result = normalizer.normalize(
      rawName: 'lapte',
      existingProducts: [product(id: 'general', normalizedName: 'lapte')],
      generateId: generateId,
    );

    expect(result.outcome, ENormalizerOutcome.exactMatch);
    expect(result.product.id, 'general');
  });

  test('fuzzy matching is scoped to the store too', () {
    // "lapt" vs "lapte" clears the 0.86 threshold, so this WOULD match were
    // the candidate not owned by another store.
    final result = normalizer.normalize(
      rawName: 'lapte',
      existingProducts: [
        product(id: 'other', normalizedName: 'lapt', storeId: 'store-2'),
      ],
      generateId: generateId,
      storeId: 'store-1',
    );

    expect(result.outcome, ENormalizerOutcome.created);
  });

  test('alias matching is scoped to the store too', () {
    final result = normalizer.normalize(
      rawName: 'lapte',
      existingProducts: [
        product(
          id: 'other',
          normalizedName: 'milk',
          storeId: 'store-2',
          aliases: ['lapte'],
        ),
      ],
      generateId: generateId,
      storeId: 'store-1',
    );

    expect(result.outcome, ENormalizerOutcome.created);
  });

  test('two stores scanning the same name yield two distinct products', () {
    final first = normalizer.normalize(
      rawName: 'lapte',
      existingProducts: const [],
      generateId: generateId,
      storeId: 'store-1',
    );
    final second = normalizer.normalize(
      rawName: 'lapte',
      existingProducts: [first.product],
      generateId: generateId,
      storeId: 'store-2',
    );

    expect(second.outcome, ENormalizerOutcome.created);
    expect(second.product.id, isNot(first.product.id));
    expect(first.product.storeId, 'store-1');
    expect(second.product.storeId, 'store-2');
  });
}
