import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/repositories/i_price_observation_local_repository.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/product/domain/repositories/i_product_local_repository.dart';
import 'package:spend_lens/features/product/domain/use_cases/split_legacy_products_use_case.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_item_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_local_repository.dart';

/// REGRESSION: `Product.storeId` is stamped only when the normalizer CREATES
/// a product, so every product predating that field stayed null — "general
/// purpose". The Stores screen lists products by where their PRICES were
/// observed, not by ownership, so ONE such product appeared under every store
/// it was ever bought at, and its page showed every store's prices in one
/// list and one inflation curve. A "+23%" rise could be nothing but a switch
/// from a cheap shop to an expensive one.
///
/// These tests pin the one-shot repair: split per store, keep the original id
/// on the oldest store, repoint observations AND the receipt items that
/// regenerate them, and stay a no-op on every later run.
void main() {
  late _FakeProducts products;
  late _FakeObservations observations;
  late _FakeReceipts receipts;
  late _FakeReceiptItems receiptItems;
  late SplitLegacyProductsUseCase split;

  final now = DateTime(2026, 9, 19, 12);

  Product product({
    String id = 'product-1',
    String? storeId,
    String displayName = 'Milk',
    List<String> aliases = const [],
  }) => Product(
    id: id,
    normalizedName: 'milk',
    displayName: displayName,
    aliases: aliases,
    storeId: storeId,
    updatedAt: DateTime(2026, 1, 1),
  );

  PriceObservation observation({
    required String id,
    required String? storeId,
    String productId = 'product-1',
    String? receiptId,
    DateTime? observedAt,
    double price = 10.0,
  }) => PriceObservation(
    id: id,
    productId: productId,
    storeId: storeId,
    receiptId: receiptId,
    observedAt: observedAt ?? now,
    comparableUnitPrice: price,
    currencyCode: 'MDL',
    updatedAt: now,
  );

  setUp(() {
    products = _FakeProducts();
    observations = _FakeObservations();
    receipts = _FakeReceipts();
    receiptItems = _FakeReceiptItems();
    split = SplitLegacyProductsUseCase(
      productRepository: products,
      priceObservationRepository: observations,
      receiptRepository: receipts,
      receiptItemRepository: receiptItems,
      now: () => now,
    );
  });

  test('a product with NO observations stays general purpose', () async {
    products.rows['product-1'] = product();

    final created = await split();

    expect(created, 0);
    expect(products.rows['product-1']!.storeId, isNull);
  });

  test('a product bought at ONE store adopts it, with no new row', () async {
    products.rows['product-1'] = product();
    observations.rows['o1'] = observation(id: 'o1', storeId: 'store-1');

    final created = await split();

    expect(created, 0, reason: 'adoption needs no copy');
    expect(products.rows, hasLength(1));
    expect(products.rows['product-1']!.storeId, 'store-1');
  });

  test('a product bought at TWO stores becomes two products', () async {
    products.rows['product-1'] = product();
    observations.rows['o1'] = observation(
      id: 'o1',
      storeId: 'store-1',
      observedAt: DateTime(2026, 1, 5),
      price: 8.0,
    );
    observations.rows['o2'] = observation(
      id: 'o2',
      storeId: 'store-2',
      observedAt: DateTime(2026, 5, 5),
      price: 23.45,
    );

    final created = await split();

    expect(created, 1);
    expect(products.rows, hasLength(2));
    // The ORIGINAL id stays with the store bought at first.
    expect(products.rows['product-1']!.storeId, 'store-1');
    expect(products.rows['product-1_split_store-2']!.storeId, 'store-2');
  });

  test('each split product keeps ONLY its own store prices', () async {
    products.rows['product-1'] = product();
    observations.rows['o1'] = observation(
      id: 'o1',
      storeId: 'store-1',
      observedAt: DateTime(2026, 1, 5),
    );
    observations.rows['o2'] = observation(
      id: 'o2',
      storeId: 'store-2',
      observedAt: DateTime(2026, 5, 5),
    );

    await split();

    expect(observations.rows['o1']!.productId, 'product-1');
    expect(observations.rows['o2']!.productId, 'product-1_split_store-2');
  });

  test('the split copy carries the identity of the original', () async {
    products.rows['product-1'] = product(
      displayName: 'CASUTA MEA',
      aliases: const ['casuta'],
    );
    observations.rows['o1'] = observation(
      id: 'o1',
      storeId: 'store-1',
      observedAt: DateTime(2026, 1, 5),
    );
    observations.rows['o2'] = observation(
      id: 'o2',
      storeId: 'store-2',
      observedAt: DateTime(2026, 5, 5),
    );

    await split();

    final copy = products.rows['product-1_split_store-2']!;
    expect(copy.displayName, 'CASUTA MEA');
    expect(copy.normalizedName, 'milk');
    expect(copy.aliases, const ['casuta']);
  });

  test('split products are linked to each other', () async {
    products.rows['product-1'] = product();
    observations.rows['o1'] = observation(
      id: 'o1',
      storeId: 'store-1',
      observedAt: DateTime(2026, 1, 5),
    );
    observations.rows['o2'] = observation(
      id: 'o2',
      storeId: 'store-2',
      observedAt: DateTime(2026, 5, 5),
    );

    await split();

    expect(
      products.rows['product-1']!.linkedProductIds,
      contains('product-1_split_store-2'),
    );
    expect(
      products.rows['product-1_split_store-2']!.linkedProductIds,
      contains('product-1'),
    );
  });

  test('a store-less price stays on the original product', () async {
    products.rows['product-1'] = product();
    observations.rows['o1'] = observation(
      id: 'o1',
      storeId: 'store-1',
      observedAt: DateTime(2026, 1, 5),
    );
    observations.rows['o2'] = observation(
      id: 'o2',
      storeId: 'store-2',
      observedAt: DateTime(2026, 5, 5),
    );
    // Hand-entered, no store: belongs nowhere in particular.
    observations.rows['manual'] = observation(id: 'manual', storeId: null);

    await split();

    expect(observations.rows['manual']!.productId, 'product-1');
  });

  test('a product with ONLY store-less prices is left alone', () async {
    products.rows['product-1'] = product();
    observations.rows['manual'] = observation(id: 'manual', storeId: null);

    final created = await split();

    expect(created, 0);
    expect(products.rows['product-1']!.storeId, isNull);
  });

  test('a tombstoned observation never drives a split', () async {
    products.rows['product-1'] = product();
    observations.rows['o1'] = observation(
      id: 'o1',
      storeId: 'store-1',
      observedAt: DateTime(2026, 1, 5),
    );
    observations.rows['dead'] = observation(
      id: 'dead',
      storeId: 'store-2',
    ).copyWith(deletedAt: now);

    final created = await split();

    expect(created, 0, reason: 'only one LIVE store, so no copy');
    expect(products.rows['product-1']!.storeId, 'store-1');
  });

  test('a product that already owns a store is skipped', () async {
    products.rows['owned'] = product(id: 'owned', storeId: 'store-9');
    observations.rows['o1'] = observation(
      id: 'o1',
      productId: 'owned',
      storeId: 'store-1',
    );

    final created = await split();

    expect(created, 0);
    expect(products.rows['owned']!.storeId, 'store-9');
    expect(products.rows, hasLength(1));
  });

  test('a SECOND run is a no-op — the guarantee against double-splitting',
      () async {
    products.rows['product-1'] = product();
    observations.rows['o1'] = observation(
      id: 'o1',
      storeId: 'store-1',
      observedAt: DateTime(2026, 1, 5),
    );
    observations.rows['o2'] = observation(
      id: 'o2',
      storeId: 'store-2',
      observedAt: DateTime(2026, 5, 5),
    );

    await split();
    final afterFirst = Map<String, Product>.from(products.rows);

    final createdAgain = await split();

    expect(createdAgain, 0);
    expect(products.rows.keys.toSet(), afterFirst.keys.toSet());
  });

  test('three stores produce three products', () async {
    products.rows['product-1'] = product();
    for (var i = 1; i <= 3; i++) {
      observations.rows['o$i'] = observation(
        id: 'o$i',
        storeId: 'store-$i',
        observedAt: DateTime(2026, i, 1),
      );
    }

    final created = await split();

    expect(created, 2);
    expect(products.rows, hasLength(3));
    expect(products.rows['product-1']!.storeId, 'store-1');
    expect(products.rows['product-1_split_store-2']!.storeId, 'store-2');
    expect(products.rows['product-1_split_store-3']!.storeId, 'store-3');
  });

  group('receipt item repointing', () {
    setUp(() {
      products.rows['product-1'] = product();
      observations.rows['o1'] = observation(
        id: 'o1',
        storeId: 'store-1',
        receiptId: 'receipt-1',
        observedAt: DateTime(2026, 1, 5),
      );
      observations.rows['o2'] = observation(
        id: 'o2',
        storeId: 'store-2',
        receiptId: 'receipt-2',
        observedAt: DateTime(2026, 5, 5),
      );
      receipts.rows['receipt-1'] = Receipt(
        id: 'receipt-1',
        storeId: 'store-1',
        purchasedAt: DateTime(2026, 1, 5),
        itemsTotal: 8.0,
        currencyCode: 'MDL',
        itemIds: const ['item-1'],
        updatedAt: now,
      );
      receipts.rows['receipt-2'] = Receipt(
        id: 'receipt-2',
        storeId: 'store-2',
        purchasedAt: DateTime(2026, 5, 5),
        itemsTotal: 23.45,
        currencyCode: 'MDL',
        itemIds: const ['item-2'],
        updatedAt: now,
      );
      receiptItems.rows['item-1'] = ReceiptItem(
        id: 'item-1',
        rawName: 'RAW A',
        normalizedName: 'Milk',
        productId: 'product-1',
        quantity: 1.0,
        lineTotal: 8.0,
        confidence: 1.0,
        lineIndex: 0,
        updatedAt: now,
      );
      receiptItems.rows['item-2'] = ReceiptItem(
        id: 'item-2',
        rawName: 'RAW B',
        normalizedName: 'Milk',
        productId: 'product-1',
        quantity: 1.0,
        lineTotal: 23.45,
        confidence: 1.0,
        lineIndex: 0,
        updatedAt: now,
      );
    });

    test('the moved receipt line is repointed at the split copy', () async {
      await split();

      expect(
        receiptItems.rows['item-2']!.productId,
        'product-1_split_store-2',
        reason: 'else re-saving receipt-2 would drag the price back and '
            'silently undo the migration',
      );
    });

    test('the line that did NOT move keeps the original product', () async {
      await split();

      expect(receiptItems.rows['item-1']!.productId, 'product-1');
    });

    test('rawName is never rewritten by the migration', () async {
      await split();

      expect(receiptItems.rows['item-1']!.rawName, 'RAW A');
      expect(receiptItems.rows['item-2']!.rawName, 'RAW B');
    });
  });
}

class _FakeProducts implements IProductLocalRepository {
  final Map<String, Product> rows = {};

  @override
  Future<List<Product>> getAll() async =>
      rows.values.where((p) => p.deletedAt == null).toList();

  @override
  Future<Product?> getById(String id) async => rows[id];

  @override
  Future<void> save(Product product, {bool markPending = true}) async {
    rows[product.id] = product;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeObservations implements IPriceObservationLocalRepository {
  final Map<String, PriceObservation> rows = {};

  @override
  Future<List<PriceObservation>> getAll() async =>
      rows.values.where((o) => o.deletedAt == null).toList();

  @override
  Future<void> save(
    PriceObservation observation, {
    bool markPending = true,
  }) async {
    rows[observation.id] = observation;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReceipts implements IReceiptLocalRepository {
  final Map<String, Receipt> rows = {};

  @override
  Future<Receipt?> getById(String id) async => rows[id];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReceiptItems implements IReceiptItemLocalRepository {
  final Map<String, ReceiptItem> rows = {};

  @override
  Future<ReceiptItem?> getById(String id) async => rows[id];

  @override
  Future<void> save(ReceiptItem item, {bool markPending = true}) async {
    rows[item.id] = item;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
