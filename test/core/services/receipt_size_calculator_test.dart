import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/services/receipt_size_calculator.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';

/// The document-size estimate shown on the receipt storage page.
void main() {
  const calculator = ReceiptSizeCalculator();
  final timestamp = DateTime(2026, 9, 11);

  Receipt receipt({String? storeId}) => Receipt(
        id: 'receipt-1',
        storeId: storeId,
        purchasedAt: timestamp,
        itemsTotal: 110.10,
        currencyCode: 'MDL',
        updatedAt: timestamp,
      );

  ReceiptItem item(String id, String name) => ReceiptItem(
        id: id,
        rawName: name,
        normalizedName: name,
        quantity: 1.0,
        lineTotal: 22.90,
        confidence: 1.0,
        lineIndex: 0,
        updatedAt: timestamp,
      );

  test('a receipt with no items still has a non-zero size', () {
    final bytes = calculator.documentBytes(
      receipt: receipt(),
      items: const [],
    );

    expect(bytes, greaterThan(0));
  });

  test('size grows with each item', () {
    final none = calculator.documentBytes(
      receipt: receipt(),
      items: const [],
    );
    final one = calculator.documentBytes(
      receipt: receipt(),
      items: [item('i1', 'Milk 1L')],
    );
    final two = calculator.documentBytes(
      receipt: receipt(),
      items: [item('i1', 'Milk 1L'), item('i2', 'Bread')],
    );

    expect(one, greaterThan(none));
    expect(two, greaterThan(one));
  });

  test('identical input gives an identical figure', () {
    expect(
      calculator.documentBytes(receipt: receipt(), items: [item('i1', 'Milk')]),
      calculator.documentBytes(receipt: receipt(), items: [item('i1', 'Milk')]),
    );
  });

  test('measures UTF-8 bytes, not UTF-16 code units', () {
    // The app ships ru/uk/ro locales, so non-ASCII store and product names
    // are the norm, not an edge case. A `String.length` implementation
    // would under-count every one of them.
    final ascii = calculator.documentBytes(
      receipt: receipt(),
      items: [item('i1', 'Moloko')],
    );
    final cyrillic = calculator.documentBytes(
      receipt: receipt(),
      items: [item('i1', 'Молоко')],
    );

    expect(
      cyrillic,
      greaterThan(ascii),
      reason: 'Cyrillic is 2 bytes per character in UTF-8, ASCII is 1.',
    );
  });
}
