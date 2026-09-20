import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/product/presentation/utils/receipt_item_display_name.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';

/// REGRESSION: renaming a product changed only the `Product` row. Every
/// receipt line kept a COPY of the name stamped onto it at save time
/// (`ReceiptItem.normalizedName`), so a product renamed from
/// `SET 2 LAVEIE HF 59.98 A` to `SET 2 LAVEIE` still read as the old OCR
/// noise everywhere the receipt was shown — two names for one thing, with
/// nothing on screen explaining the difference.
///
/// A bound line now READS its product's name. One name, one entity, no copy.
void main() {
  final now = DateTime(2026, 9, 19);

  ReceiptItem item({
    String? productId,
    String normalizedName = 'SET 2 LAVEIE HF 59.98 A',
    String rawName = 'SET 2 LAVEIE HF 59.98 A',
  }) => ReceiptItem(
    id: 'item-1',
    rawName: rawName,
    normalizedName: normalizedName,
    productId: productId,
    quantity: 1.0,
    lineTotal: 59.98,
    confidence: 1.0,
    lineIndex: 0,
    updatedAt: now,
  );

  Product product({
    String id = 'p1',
    String displayName = 'SET 2 LAVEIE',
    DateTime? deletedAt,
  }) => Product(
    id: id,
    normalizedName: 'set 2 laveie',
    displayName: displayName,
    storeId: 'store-1',
    updatedAt: now,
    deletedAt: deletedAt,
  );

  test('a bound line shows the PRODUCT current name, not its own copy', () {
    final name = receiptItemDisplayName(
      item(productId: 'p1'),
      [product()],
    );

    expect(name, 'SET 2 LAVEIE');
  });

  test('renaming the product changes what the line reads', () {
    final line = item(productId: 'p1');

    expect(
      receiptItemDisplayName(line, [product(displayName: 'Laveie set')]),
      'Laveie set',
      reason: 'the line holds no copy to go stale',
    );
  });

  test('an UNBOUND line falls back to its own stored name', () {
    final name = receiptItemDisplayName(item(), const []);

    expect(name, 'SET 2 LAVEIE HF 59.98 A');
  });

  test('a line naming a missing product falls back rather than blanking', () {
    final name = receiptItemDisplayName(item(productId: 'ghost'), [product()]);

    expect(name, 'SET 2 LAVEIE HF 59.98 A');
  });

  test('a tombstoned product is not read from', () {
    final name = receiptItemDisplayName(
      item(productId: 'p1'),
      [product(deletedAt: now)],
    );

    expect(name, 'SET 2 LAVEIE HF 59.98 A');
  });

  test('a blank product name never blanks the line', () {
    final name = receiptItemDisplayName(
      item(productId: 'p1'),
      [product(displayName: '   ')],
    );

    expect(name, 'SET 2 LAVEIE HF 59.98 A');
  });

  test('rawName is the last resort when nothing else has a name', () {
    final name = receiptItemDisplayName(
      item(normalizedName: '', rawName: 'RAW PRINTED TEXT'),
      const [],
    );

    expect(name, 'RAW PRINTED TEXT');
  });

  test('rawName is never used as the name of a bound line', () {
    final name = receiptItemDisplayName(
      item(productId: 'p1', rawName: 'RAW PRINTED TEXT'),
      [product()],
    );

    expect(
      name,
      'SET 2 LAVEIE',
      reason: 'rawName is what was printed and is never a rename target',
    );
  });
}
