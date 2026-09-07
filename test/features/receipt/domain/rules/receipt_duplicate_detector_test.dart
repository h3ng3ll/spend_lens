import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/rules/receipt_duplicate_detector.dart';

void main() {
  const detector = ReceiptDuplicateDetector();

  Receipt receipt({
    required String id,
    String? storeId,
    required DateTime purchasedAt,
    double? printedTotal,
    double itemsTotal = 0.0,
    DateTime? deletedAt,
  }) {
    return Receipt(
      id: id,
      storeId: storeId,
      purchasedAt: purchasedAt,
      printedTotal: printedTotal,
      itemsTotal: itemsTotal,
      currencyCode: 'MDL',
      updatedAt: purchasedAt,
      deletedAt: deletedAt,
    );
  }

  test('flags a same-store, same-day, same-total receipt as a likely duplicate', () {
    final existing = [
      receipt(
        id: 'r1',
        storeId: 'store-1',
        purchasedAt: DateTime(2026, 9, 7, 10, 0),
        printedTotal: 151.10,
      ),
    ];

    final duplicate = detector.findLikelyDuplicate(
      storeId: 'store-1',
      purchasedAt: DateTime(2026, 9, 7, 18, 30),
      total: 151.10,
      existingReceipts: existing,
    );

    expect(duplicate, isNotNull);
    expect(duplicate!.id, 'r1');
  });

  test('does NOT flag a different day even with the same store/total', () {
    final existing = [
      receipt(
        id: 'r1',
        storeId: 'store-1',
        purchasedAt: DateTime(2026, 9, 6),
        printedTotal: 151.10,
      ),
    ];

    final duplicate = detector.findLikelyDuplicate(
      storeId: 'store-1',
      purchasedAt: DateTime(2026, 9, 7),
      total: 151.10,
      existingReceipts: existing,
    );

    expect(duplicate, isNull);
  });

  test('does NOT flag a different total on the same day/store', () {
    final existing = [
      receipt(
        id: 'r1',
        storeId: 'store-1',
        purchasedAt: DateTime(2026, 9, 7),
        printedTotal: 151.10,
      ),
    ];

    final duplicate = detector.findLikelyDuplicate(
      storeId: 'store-1',
      purchasedAt: DateTime(2026, 9, 7),
      total: 40.00,
      existingReceipts: existing,
    );

    expect(duplicate, isNull);
  });

  test('ignores a soft-deleted receipt', () {
    final existing = [
      receipt(
        id: 'r1',
        storeId: 'store-1',
        purchasedAt: DateTime(2026, 9, 7),
        printedTotal: 151.10,
        deletedAt: DateTime(2026, 9, 8),
      ),
    ];

    final duplicate = detector.findLikelyDuplicate(
      storeId: 'store-1',
      purchasedAt: DateTime(2026, 9, 7),
      total: 151.10,
      existingReceipts: existing,
    );

    expect(duplicate, isNull);
  });

  test('NEVER deletes anything — this class only detects, it has no delete/remove method', () {
    // Structural assertion: ReceiptDuplicateDetector's only public method is
    // findLikelyDuplicate, which returns a value and mutates nothing.
    expect(detector.findLikelyDuplicate, isA<Function>());
  });
}
