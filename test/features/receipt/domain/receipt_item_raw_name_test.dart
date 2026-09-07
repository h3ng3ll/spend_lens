import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/product/domain/models/product/e_unit.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';

/// The hardest invariant this milestone must protect (design_spendlens.md
/// §11 / §3): `ReceiptItem.rawName` is the literal OCR/manual-entry text
/// captured at creation time and MUST survive normalization, rename, and
/// edit — forever. `normalizedName`, `productId`, and every other field are
/// free to change as the item gets matched/renormalized/renamed; `rawName`
/// never is.
///
/// The full normalizer (cleanup → abbreviation expansion → exact match →
/// fuzzy match → create new) is M8. This test asserts the invariant against
/// the entity NOW, at M3, precisely so the guarantee exists from the start
/// rather than being retrofitted once the normalizer is written and it is
/// too late to catch a design that already violates it.
void main() {
  ReceiptItem baseItem({String rawName = 'LAPTE ZUZU 1L'}) => ReceiptItem(
        id: 'item-1',
        rawName: rawName,
        normalizedName: 'lapte zuzu 1l',
        quantity: 1.0,
        lineTotal: 24.5,
        confidence: 0.92,
        lineIndex: 0,
        updatedAt: DateTime(2026, 1, 1),
      );

  group('rawName survives copyWith on every other field', () {
    test('copyWith(normalizedName:) — simulated normalization pass', () {
      final item = baseItem();
      final normalized = item.copyWith(normalizedName: 'Lapte Zuzu');

      expect(normalized.rawName, item.rawName);
      expect(normalized.rawName, 'LAPTE ZUZU 1L');
    });

    test('copyWith(productId:) — matched to a Product during normalization',
        () {
      final item = baseItem();
      final matched = item.copyWith(productId: 'product-42');

      expect(matched.rawName, item.rawName);
    });

    test('copyWith(normalizedName:, productId:) — full normalization pass',
        () {
      final item = baseItem();
      final normalized = item.copyWith(
        normalizedName: 'Lapte Zuzu 1L',
        productId: 'product-42',
      );

      expect(normalized.rawName, item.rawName);
    });

    test('copyWith(unit:, unitPrice:, quantity:) — user edits quantity/unit',
        () {
      final item = baseItem();
      final edited = item.copyWith(
        unit: EUnit.liter,
        unitPrice: 24.5,
        quantity: 2.0,
      );

      expect(edited.rawName, item.rawName);
    });

    test(
        'copyWith(lineTotal:, confidence:, isLowConfidence:) — reconciliation edit',
        () {
      final item = baseItem();
      final edited = item.copyWith(
        lineTotal: 49.0,
        confidence: 0.4,
        isLowConfidence: true,
      );

      expect(edited.rawName, item.rawName);
    });

    test('copyWith(isManuallyAdded:, lineIndex:) — reordering / manual flag',
        () {
      final item = baseItem();
      final edited = item.copyWith(
        isManuallyAdded: true,
        lineIndex: 3,
      );

      expect(edited.rawName, item.rawName);
    });

    test('copyWith(updatedAt:, deletedAt:, syncStatus:) — lifecycle edit',
        () {
      final item = baseItem();
      final edited = item.copyWith(
        updatedAt: DateTime(2026, 2, 1),
        deletedAt: DateTime(2026, 2, 2),
      );

      expect(edited.rawName, item.rawName);
    });

    test('a chain of successive copyWith calls never mutates rawName', () {
      final item = baseItem();

      final afterNormalization = item.copyWith(normalizedName: 'Lapte Zuzu');
      final afterMatch = afterNormalization.copyWith(productId: 'product-42');
      final afterRename = afterMatch.copyWith(
        productId: 'product-99',
        normalizedName: 'Zuzu Milk 1L',
      );
      final afterEdit = afterRename.copyWith(quantity: 3.0, lineTotal: 73.5);

      expect(afterEdit.rawName, item.rawName);
      expect(afterEdit.rawName, 'LAPTE ZUZU 1L');
    });
  });

  group('rawName is preserved byte-identically across JSON round-trip', () {
    test('toJson/fromJson never alters rawName', () {
      final item = baseItem(rawName: 'CAFEA  NATURALĂ 250G  ');
      final roundTripped = ReceiptItem.fromJson(item.toJson());

      expect(roundTripped.rawName, item.rawName);
    });
  });

  group('rawName is exempt from equality-based deduplication assumptions',
      () {
    test('two items with the same rawName but different ids are distinct',
        () {
      final first = baseItem();
      final second = baseItem().copyWith(id: 'item-2');

      expect(first.rawName, second.rawName);
      expect(first.id, isNot(second.id));
    });
  });
}
