import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/repositories/i_price_observation_local_repository.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/expense/domain/repositories/i_expense_local_repository.dart';
import 'package:spend_lens/features/product/domain/models/product/e_unit.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/product/domain/repositories/i_product_local_repository.dart';
import 'package:spend_lens/features/product/domain/use_cases/rename_product_use_case.dart';
import 'package:spend_lens/features/product/presentation/utils/receipt_item_display_name.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_item_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/use_cases/create_expense_from_receipt_use_case.dart';
import 'package:spend_lens/features/receipt/domain/use_cases/record_price_observations_use_case.dart';
import 'package:spend_lens/features/receipt/presentation/bloc/edit_receipt_bloc/edit_receipt_bloc.dart';
import 'package:spend_lens/features/scanner/domain/pending_receipt_draft_store.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/store/domain/repositories/i_store_local_repository.dart';

/// Renaming a line on a SAVED receipt must change what the detail screen
/// shows.
///
/// A saved line is displayed by its PRODUCT's name
/// ([receiptItemDisplayName]), so a rename that stops at the `ReceiptItem`
/// is invisible. `_onSave` resolved the product and then dropped the edit in
/// BOTH branches:
///
/// - a PINNED line (every line loaded from a saved receipt has a
///   `productId`) was fetched by id and used as-is, with its old
///   `displayName`;
/// - an UNPINNED line went through the normalizer, which exact/fuzzy-matched
///   the edited text straight back to the product it already belonged to and
///   returned it unchanged.
///
/// `ReceiptItem.normalizedName` was then set FROM that stale `displayName`,
/// so the correction was overwritten by the value it was meant to replace.
/// The symptom: edit a title, tap `Apply corrections`, and the receipt still
/// lists the original OCR text — with no error, and unchanged on retry.
void main() {
  late _FakeReceiptRepository receipts;
  late _FakeReceiptItemRepository items;
  late _FakeProductRepository products;
  late _FakeStoreRepository stores;
  late _FakeExpenseRepository expenses;
  late _FakePriceObservationRepository priceObservations;

  final now = DateTime(2026, 9, 20, 13, 34);

  const rawName = 'SACOSA ECOTAX8,151e1 17 98 A';
  const correctedName = 'Shopping bag';

  EditReceiptBloc buildBloc() => EditReceiptBloc(
    receiptRepository: receipts,
    draftStore: PendingReceiptDraftStore(),
    receiptItemRepository: items,
    productRepository: products,
    storeRepository: stores,
    createExpenseFromReceipt: CreateExpenseFromReceiptUseCase(expenses),
    recordPriceObservations: RecordPriceObservationsUseCase(
      priceObservationRepository: priceObservations,
    ),
    renameProduct: RenameProductUseCase(
      productRepository: products,
      now: () => now,
    ),
    now: () => now,
  );

  /// A saved receipt with one line already bound to a product — exactly what
  /// the editor loads when reached from the receipt detail screen.
  Future<void> seedSavedReceipt({required String? productId}) async {
    if (productId != null) {
      await products.save(
        Product(
          id: productId,
          normalizedName: 'sacosa ecotax',
          displayName: rawName,
          defaultUnit: EUnit.piece,
          updatedAt: now,
        ),
      );
    }
    await items.save(
      ReceiptItem(
        id: 'item-1',
        rawName: rawName,
        normalizedName: rawName,
        productId: productId,
        quantity: 1.81,
        unit: EUnit.piece,
        lineTotal: 17.98,
        confidence: 0.9,
        lineIndex: 0,
        updatedAt: now,
      ),
    );
    await receipts.save(
      Receipt(
        id: 'receipt-1',
        purchasedAt: now,
        itemsTotal: 17.98,
        printedTotal: 17.98,
        currencyCode: 'MDL',
        itemIds: const ['item-1'],
        updatedAt: now,
      ),
    );
  }

  setUp(() {
    receipts = _FakeReceiptRepository();
    items = _FakeReceiptItemRepository();
    products = _FakeProductRepository();
    stores = _FakeStoreRepository();
    expenses = _FakeExpenseRepository();
    priceObservations = _FakePriceObservationRepository();
  });

  test('renaming a product-bound line renames the product it displays by',
      () async {
    await seedSavedReceipt(productId: 'product-1');

    final bloc = buildBloc()..add(const EditReceiptEvent.load('receipt-1'));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.items.single.name, rawName);

    bloc.add(EditReceiptEvent.updateItemName('item-1', correctedName));
    await Future<void>.delayed(Duration.zero);
    bloc.add(const EditReceiptEvent.save());
    await Future<void>.delayed(Duration.zero);

    final savedItem = (await items.getById('item-1'))!;
    final allProducts = await products.getAll();

    expect(
      receiptItemDisplayName(savedItem, allProducts),
      correctedName,
      reason: 'The detail screen shows the PRODUCT name, so the rename must '
          'reach the product or nothing changes on screen.',
    );
    expect(
      savedItem.rawName,
      rawName,
      reason: 'rawName must stay byte-for-byte what the receipt printed '
          '(spec §11).',
    );
    expect(
      allProducts,
      hasLength(1),
      reason: 'A rename must MOVE the existing product, not fork a duplicate.',
    );

    await bloc.close();
  });

  test('renaming an unbound line does not revert via a normalizer re-match',
      () async {
    // No productId: the save path goes through the normalizer, which
    // exact-matches the line back onto the seeded product.
    await products.save(
      Product(
        id: 'product-1',
        normalizedName: 'sacosa ecotax',
        displayName: rawName,
        defaultUnit: EUnit.piece,
        updatedAt: now,
      ),
    );
    await seedSavedReceipt(productId: null);

    final bloc = buildBloc()..add(const EditReceiptEvent.load('receipt-1'));
    await Future<void>.delayed(Duration.zero);

    bloc.add(EditReceiptEvent.updateItemName('item-1', correctedName));
    await Future<void>.delayed(Duration.zero);
    bloc.add(const EditReceiptEvent.save());
    await Future<void>.delayed(Duration.zero);

    final savedItem = (await items.getById('item-1'))!;
    expect(
      receiptItemDisplayName(savedItem, await products.getAll()),
      correctedName,
    );
    expect(savedItem.rawName, rawName);

    await bloc.close();
  });

  test('re-entering the editor shows the corrected name', () async {
    await seedSavedReceipt(productId: 'product-1');

    final first = buildBloc()..add(const EditReceiptEvent.load('receipt-1'));
    await Future<void>.delayed(Duration.zero);
    first.add(EditReceiptEvent.updateItemName('item-1', correctedName));
    await Future<void>.delayed(Duration.zero);
    first.add(const EditReceiptEvent.save());
    await Future<void>.delayed(Duration.zero);
    await first.close();

    final second = buildBloc()..add(const EditReceiptEvent.load('receipt-1'));
    await Future<void>.delayed(Duration.zero);

    expect(second.state.items.single.name, correctedName);
    expect(second.state.items.single.rawName, rawName);

    await second.close();
  });

  test('saving without renaming leaves the product name untouched', () async {
    await seedSavedReceipt(productId: 'product-1');

    final bloc = buildBloc()..add(const EditReceiptEvent.load('receipt-1'));
    await Future<void>.delayed(Duration.zero);

    bloc.add(const EditReceiptEvent.save());
    await Future<void>.delayed(Duration.zero);

    expect((await products.getById('product-1'))!.displayName, rawName);
    expect(await products.getAll(), hasLength(1));

    await bloc.close();
  });
}

class _FakeReceiptRepository implements IReceiptLocalRepository {
  final Map<String, Receipt> _store = {};

  @override
  Future<List<Receipt>> getAll() async => _store.values.toList();

  @override
  Future<Receipt?> getById(String id) async => _store[id];

  @override
  Future<void> save(Receipt receipt, {bool markPending = true}) async =>
      _store[receipt.id] = receipt;

  @override
  Future<void> delete(String id) async => _store.remove(id);

  @override
  Future<void> deleteLocalOnly(String id) async => _store.remove(id);

  @override
  Future<List<Receipt>> getAllIncludingDeleted() async =>
      _store.values.toList();

  @override
  Future<List<Receipt>> getPending() async => const [];

  @override
  Future<void> saveAll(List<Receipt> items, {bool markPending = true}) async {
    for (final item in items) {
      _store[item.id] = item;
    }
  }

  @override
  Stream<List<Receipt>> watchAll() => Stream.value(_store.values.toList());
}

class _FakeReceiptItemRepository implements IReceiptItemLocalRepository {
  final Map<String, ReceiptItem> _store = {};

  @override
  Future<List<ReceiptItem>> getAll() async => _store.values.toList();

  @override
  Future<ReceiptItem?> getById(String id) async => _store[id];

  @override
  Future<void> save(ReceiptItem item, {bool markPending = true}) async =>
      _store[item.id] = item;

  @override
  Future<void> delete(String id) async => _store.remove(id);

  @override
  Future<void> deleteLocalOnly(String id) async => _store.remove(id);

  @override
  Stream<List<ReceiptItem>> watchAll() => Stream.value(_store.values.toList());

  @override
  Stream<List<ReceiptItem>> watchByReceiptId(List<String> itemIds) =>
      Stream.value(
        _store.values.where((item) => itemIds.contains(item.id)).toList(),
      );

  @override
  Future<List<ReceiptItem>> getAllIncludingDeleted() async =>
      _store.values.toList();

  @override
  Future<List<ReceiptItem>> getPending() async => const [];

  @override
  Future<void> saveAll(
    List<ReceiptItem> items, {
    bool markPending = true,
  }) async {
    for (final item in items) {
      _store[item.id] = item;
    }
  }
}

class _FakeProductRepository implements IProductLocalRepository {
  final Map<String, Product> _store = {};

  @override
  Future<List<Product>> getAll() async => _store.values.toList();

  @override
  Future<Product?> getById(String id) async => _store[id];

  @override
  Future<void> save(Product product, {bool markPending = true}) async =>
      _store[product.id] = product;

  @override
  Future<void> delete(String id) async => _store.remove(id);

  @override
  Future<void> deleteLocalOnly(String id) async => _store.remove(id);

  @override
  Future<List<Product>> getAllIncludingDeleted() async =>
      _store.values.toList();

  @override
  Future<List<Product>> getPending() async => const [];

  @override
  Future<void> saveAll(List<Product> items, {bool markPending = true}) async {
    for (final item in items) {
      _store[item.id] = item;
    }
  }

  @override
  Stream<List<Product>> watchAll() => Stream.value(_store.values.toList());
}

class _FakeStoreRepository implements IStoreLocalRepository {
  final Map<String, Store> _store = {};

  @override
  Future<List<Store>> getAll() async => _store.values.toList();

  @override
  Future<Store?> getById(String id) async => _store[id];

  @override
  Future<void> save(Store store, {bool markPending = true}) async =>
      _store[store.id] = store;

  @override
  Future<void> delete(String id) async => _store.remove(id);

  @override
  Future<void> deleteLocalOnly(String id) async => _store.remove(id);

  @override
  Future<List<Store>> getAllIncludingDeleted() async => _store.values.toList();

  @override
  Future<List<Store>> getPending() async => const [];

  @override
  Future<void> saveAll(List<Store> items, {bool markPending = true}) async {
    for (final item in items) {
      _store[item.id] = item;
    }
  }

  @override
  Stream<List<Store>> watchAll() => Stream.value(_store.values.toList());
}

class _FakeExpenseRepository implements IExpenseLocalRepository {
  final Map<String, Expense> _store = {};

  @override
  Future<List<Expense>> getAll() async => _store.values.toList();

  @override
  Future<Expense?> getById(String id) async => _store[id];

  @override
  Future<void> save(Expense expense, {bool markPending = true}) async =>
      _store[expense.id] = expense;

  @override
  Future<void> delete(String id) async => _store.remove(id);

  @override
  Future<void> deleteLocalOnly(String id) async => _store.remove(id);

  @override
  Future<List<Expense>> getAllIncludingDeleted() async =>
      _store.values.toList();

  @override
  Future<List<Expense>> getPending() async => const [];

  @override
  Future<void> saveAll(List<Expense> items, {bool markPending = true}) async {
    for (final item in items) {
      _store[item.id] = item;
    }
  }

  @override
  Stream<List<Expense>> watchAll() => Stream.value(_store.values.toList());
}

class _FakePriceObservationRepository
    implements IPriceObservationLocalRepository {
  final List<PriceObservation> saved = [];

  @override
  Future<List<PriceObservation>> getAllIncludingDeleted() async => saved;

  @override
  Future<void> saveAll(
    List<PriceObservation> items, {
    bool markPending = true,
  }) async {
    saved.addAll(items);
  }

  @override
  Future<void> deleteLocalOnly(String id) async {
    saved.removeWhere((observation) => observation.id == id);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
