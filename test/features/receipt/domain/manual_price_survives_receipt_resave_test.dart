import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation_origin_x.dart';
import 'package:spend_lens/features/analytics/domain/repositories/i_price_observation_local_repository.dart';
import 'package:spend_lens/features/product/domain/models/product/e_unit.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';
import 'package:spend_lens/features/receipt/domain/use_cases/record_price_observations_use_case.dart';

/// REGRESSION: `RecordPriceObservationsUseCase` REPLACES a receipt's
/// observations, hard-deleting every prior row it believes belongs to that
/// receipt. Once prices could also be entered BY HAND on the product page,
/// that sweep became capable of destroying user-authored data: a manual row
/// carries no receipt, so any sentinel-or-loose match would collect it and
/// correcting one receipt would silently wipe every price the user typed —
/// no error, no crash, no way to tell it had happened.
///
/// A manual price is marked ONLY by `receiptId == null`, so these tests pin
/// that the retire sweep skips null-receipt rows explicitly.
void main() {
  late _FakeRepository repository;
  late RecordPriceObservationsUseCase record;

  final now = DateTime(2026, 9, 19, 20, 0);

  ReceiptItem item({
    required String id,
    String? productId = 'product-1',
    double quantity = 1.0,
    double lineTotal = 17.98,
  }) => ReceiptItem(
    id: id,
    rawName: 'RAW',
    normalizedName: 'Normalized',
    productId: productId,
    quantity: quantity,
    unit: EUnit.piece,
    lineTotal: lineTotal,
    confidence: 1.0,
    lineIndex: 0,
    updatedAt: now,
  );

  PriceObservation manualPrice({
    String id = 'manual-1',
    String productId = 'product-1',
    String? storeId = 'store-1',
    double unitPrice = 9.99,
  }) => PriceObservation(
    id: id,
    productId: productId,
    storeId: storeId,
    receiptId: null,
    observedAt: DateTime(2026, 8, 1),
    comparableUnitPrice: unitPrice,
    currencyCode: 'MDL',
    updatedAt: now,
  );

  Future<void> resaveReceipt({
    String receiptId = 'receipt-1',
    String? storeId = 'store-1',
    required List<ReceiptItem> items,
  }) => record(
    receiptId: receiptId,
    storeId: storeId,
    items: items,
    observedAt: DateTime(2026, 9, 19),
    currencyCode: 'MDL',
    now: now,
  );

  setUp(() {
    repository = _FakeRepository();
    record = RecordPriceObservationsUseCase(
      priceObservationRepository: repository,
    );
  });

  test('a manual price survives a re-save of an unrelated receipt', () async {
    repository.rows.add(manualPrice());

    await resaveReceipt(items: [item(id: 'line-1')]);

    expect(
      repository.rows.where((row) => row.id == 'manual-1'),
      hasLength(1),
      reason: 'the hand-entered price must not be swept by a receipt save',
    );
  });

  test(
    'a manual price for the SAME product and store still survives',
    () async {
      // The dangerous case: everything about this row matches the receipt's
      // own observation except that a human wrote it.
      repository.rows.add(manualPrice(productId: 'product-1'));

      await resaveReceipt(items: [item(id: 'line-1', productId: 'product-1')]);

      final manual = repository.rows.where((row) => row.isManual).toList();
      expect(manual, hasLength(1));
      expect(manual.single.comparableUnitPrice, 9.99);
    },
  );

  test('re-saving twice still leaves exactly one manual price', () async {
    repository.rows.add(manualPrice());

    await resaveReceipt(items: [item(id: 'line-1')]);
    await resaveReceipt(items: [item(id: 'line-1', lineTotal: 21.50)]);

    expect(repository.rows.where((row) => row.isManual), hasLength(1));
  });

  test('the receipt-derived rows ARE still replaced, not appended', () async {
    repository.rows.add(manualPrice());

    await resaveReceipt(items: [item(id: 'line-1')]);
    await resaveReceipt(items: [item(id: 'line-1', lineTotal: 21.50)]);

    final derived = repository.rows.where((row) => !row.isManual).toList();
    expect(
      derived,
      hasLength(1),
      reason: 'replacement must still retire the superseded derived row',
    );
    expect(derived.single.comparableUnitPrice, 21.50);
  });

  test('a derived row is marked non-manual, a typed one manual', () async {
    repository.rows.add(manualPrice());
    await resaveReceipt(items: [item(id: 'line-1')]);

    expect(repository.rows.singleWhere((r) => r.id == 'manual-1').isManual, isTrue);
    expect(
      repository.rows.singleWhere((r) => r.receiptId == 'receipt-1').isManual,
      isFalse,
    );
  });
}

class _FakeRepository implements IPriceObservationLocalRepository {
  final List<PriceObservation> rows = [];

  @override
  Future<List<PriceObservation>> getAllIncludingDeleted() async => [...rows];

  @override
  Future<void> saveAll(
    List<PriceObservation> items, {
    bool markPending = true,
  }) async {
    rows.addAll(items);
  }

  @override
  Future<void> deleteLocalOnly(String id) async {
    rows.removeWhere((observation) => observation.id == id);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
