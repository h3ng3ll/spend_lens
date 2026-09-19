import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/repositories/i_price_observation_local_repository.dart';
import 'package:spend_lens/features/product/domain/models/product/e_unit.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';
import 'package:spend_lens/features/receipt/domain/use_cases/record_price_observations_use_case.dart';

/// [PriceObservation] is the only entity joining a product to a store, and
/// nothing outside backup import used to write one — so the Stores list's
/// product count, "Products bought here", price history and the cross-store
/// comparison were all structurally empty.
void main() {
  late _FakeRepository repository;
  late RecordPriceObservationsUseCase record;

  final now = DateTime(2026, 9, 19, 20, 0);

  ReceiptItem item({
    required String id,
    String? productId = 'product-1',
    double quantity = 1.0,
    double lineTotal = 17.98,
    EUnit unit = EUnit.piece,
  }) => ReceiptItem(
    id: id,
    rawName: 'RAW',
    normalizedName: 'Normalized',
    productId: productId,
    quantity: quantity,
    unit: unit,
    lineTotal: lineTotal,
    confidence: 1.0,
    lineIndex: 0,
    updatedAt: now,
  );

  Future<void> run({
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

  test('writes one observation per line, carrying the store', () async {
    await run(
      items: [
        item(id: 'a', productId: 'milk'),
        item(id: 'b', productId: 'bread'),
      ],
    );

    expect(repository.rows, hasLength(2));
    expect(repository.rows.map((o) => o.productId), ['milk', 'bread']);
    expect(repository.rows.every((o) => o.storeId == 'store-1'), isTrue);
  });

  test('REPLACES this receipt\'s previous observations', () async {
    // A correction can rename a line onto a different product or delete it.
    // Appending would leave the superseded row counting toward the store.
    await run(
      items: [item(id: 'a', productId: 'milk')],
    );
    await run(
      items: [item(id: 'a', productId: 'oat-milk')],
    );

    expect(repository.rows, hasLength(1));
    expect(repository.rows.single.productId, 'oat-milk');
  });

  test('leaves ANOTHER receipt\'s observations alone', () async {
    await run(
      receiptId: 'receipt-1',
      items: [item(id: 'a', productId: 'milk')],
    );
    await run(
      receiptId: 'receipt-2',
      items: [item(id: 'b', productId: 'bread')],
    );

    expect(repository.rows, hasLength(2));
  });

  test('skips a line the normalizer could not resolve to a product', () async {
    // A null-product observation would count toward the store's total while
    // naming no product.
    await run(items: [item(id: 'a', productId: null)]);

    expect(repository.rows, isEmpty);
  });

  test('divides a weighed line down to its comparable unit price', () async {
    await run(
      items: [
        item(id: 'a', quantity: 1.2, lineTotal: 104.0, unit: EUnit.kilogram),
      ],
    );

    // 104 / 1.2 = 86.666... -> 86.67 per kg.
    expect(repository.rows.single.comparableUnitPrice, 86.67);
  });

  test('falls back to the line total when quantity is non-positive', () async {
    // An OCR'd `0` quantity must not divide into an infinity that then
    // renders as a price.
    await run(items: [item(id: 'a', quantity: 0.0, lineTotal: 17.98)]);

    expect(repository.rows.single.comparableUnitPrice, 17.98);
  });

  test('records nothing when there are no resolvable lines', () async {
    await run(items: const []);

    expect(repository.rows, isEmpty);
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
