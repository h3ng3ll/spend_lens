import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/repositories/i_price_observation_local_repository.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/expense/domain/repositories/i_expense_local_repository.dart';
import 'package:spend_lens/features/product/domain/models/product/e_unit.dart';
import 'package:spend_lens/features/product/domain/use_cases/rename_product_use_case.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/product/domain/repositories/i_product_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_item_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/use_cases/create_expense_from_receipt_use_case.dart';
import 'package:spend_lens/features/receipt/domain/use_cases/record_price_observations_use_case.dart';
import 'package:spend_lens/features/receipt/domain/use_cases/save_scanned_receipt_use_case.dart';
import 'package:spend_lens/features/scanner/domain/pending_receipt_draft_store.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/store/domain/repositories/i_store_local_repository.dart';
import 'package:spend_lens/features/store/domain/use_cases/learn_store_alias_use_case.dart';

/// REGRESSION: a scanned receipt used to be saved with NO store.
///
/// `ReviewState` had no `storeId` field at all, so `_persist` built its
/// `Receipt(...)` without one and called `_createExpenseFromReceipt` without
/// one. Both landed null. Since every per-store screen aggregates
/// `Expense.storeId`, a scan never appeared under any store no matter which
/// store the user picked.
///
/// Both halves are asserted: the `Receipt` alone is not enough, because Home,
/// History and Analytics all read the `expenses` box and none reads `receipts`.
void main() {
  late _FakeReceipts receipts;
  late _FakeReceiptItems receiptItems;
  late _FakeProducts products;
  late _FakeStores stores;
  late _FakeExpenses expenses;
  late _FakePriceObservations priceObservations;
  late SaveScannedReceiptUseCase saveScannedReceipt;

  ScannedReceiptInput input({
    String? storeId,
    String? storeName,
    bool isStoreUserPicked = false,
  }) => ScannedReceiptInput(
    items: [
      const ScannedReceiptItemInput(
        id: 'i1',
        rawName: 'LAPTE 2.5%',
        name: 'Lapte',
        quantity: 1.0,
        unit: EUnit.piece,
        unitPrice: 17.98,
        lineTotal: 17.98,
        confidence: 1.0,
        isLowConfidence: false,
        isManuallyAdded: false,
      ),
    ],
    storeId: storeId,
    storeName: storeName,
    isStoreUserPicked: isStoreUserPicked,
    categoryId: null,
    purchasedAt: DateTime(2026, 9, 19, 17, 0),
    printedTotal: 17.98,
    itemsTotal: 17.98,
    isReconciled: true,
    imageFilename: null,
  );

  setUp(() {
    receipts = _FakeReceipts();
    receiptItems = _FakeReceiptItems();
    products = _FakeProducts();
    stores = _FakeStores();
    expenses = _FakeExpenses();
    priceObservations = _FakePriceObservations();

    saveScannedReceipt = SaveScannedReceiptUseCase(
      receiptRepository: receipts,
      receiptItemRepository: receiptItems,
      productRepository: products,
      storeRepository: stores,
      createExpenseFromReceipt: CreateExpenseFromReceiptUseCase(expenses),
      recordPriceObservations: RecordPriceObservationsUseCase(
        priceObservationRepository: priceObservations,
      ),
      learnStoreAlias: LearnStoreAliasUseCase(repository: stores),
      draftStore: PendingReceiptDraftStore(),
      renameProduct: RenameProductUseCase(productRepository: products),
    );
  });

  test('records a price observation per line, linking product to store', () async {
    // REGRESSION: nothing outside backup import ever wrote a
    // PriceObservation, and it is the ONLY entity joining a product to a
    // store. Products and the store were both saved, but the edge between
    // them never was — so every store counted 0 products and "Products
    // bought here" stayed empty no matter how much was scanned.
    await saveScannedReceipt(input(storeId: 'store-1'));

    expect(priceObservations.saved, hasLength(1));
    final observation = priceObservations.saved.single;
    expect(observation.storeId, 'store-1');
    expect(observation.productId, products.saved.single.id);
    expect(observation.comparableUnitPrice, 17.98);
  });

  test('the picked store reaches BOTH the receipt and the expense', () async {
    await saveScannedReceipt(input(storeId: 'store-1'));

    expect(receipts.saved.single.storeId, 'store-1');
    // The half that actually makes it visible on Home/History/Analytics.
    expect(expenses.saved.single.storeId, 'store-1');
  });

  test('no matched store saves cleanly with no store attached', () async {
    await saveScannedReceipt(input());

    expect(receipts.saved.single.storeId, isNull);
    expect(expenses.saved.single.storeId, isNull);
    // And critically, nothing was invented to fill the gap.
    expect(stores.saved, isEmpty);
  });

  group('alias learning', () {
    test('records the printed spelling for a USER-PICKED store', () async {
      stores.existing['store-1'] = Store(
        id: 'store-1',
        name: 'Kaufland',
        updatedAt: DateTime(2026, 9, 19),
      );

      await saveScannedReceipt(
        input(
          storeId: 'store-1',
          storeName: 'KAUFLAND SA MD-2001',
          isStoreUserPicked: true,
        ),
      );

      expect(stores.saved.single.receiptAliases, ['KAUFLAND SA MD-2001']);
    });

    test('records NOTHING for an auto-matched store', () async {
      stores.existing['store-1'] = Store(
        id: 'store-1',
        name: 'Kaufland',
        updatedAt: DateTime(2026, 9, 19),
      );

      await saveScannedReceipt(
        input(
          storeId: 'store-1',
          storeName: 'KAUFLAND SA MD-2001',
          // The matcher guessed this. A guess must never teach itself, or one
          // wrong match would repeat forever with no way to see why.
          isStoreUserPicked: false,
        ),
      );

      expect(stores.saved, isEmpty);
    });
  });
}

class _FakeReceipts implements IReceiptLocalRepository {
  final List<Receipt> saved = [];

  @override
  Future<void> save(Receipt receipt, {bool markPending = true}) async {
    saved.add(receipt);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReceiptItems implements IReceiptItemLocalRepository {
  final List<ReceiptItem> saved = [];

  @override
  Future<void> save(ReceiptItem item, {bool markPending = true}) async {
    saved.add(item);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeProducts implements IProductLocalRepository {
  final List<Product> saved = [];

  @override
  Future<List<Product>> getAll() async => const [];

  @override
  Future<void> save(Product product, {bool markPending = true}) async {
    saved.add(product);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStores implements IStoreLocalRepository {
  final Map<String, Store> existing = {};
  final List<Store> saved = [];

  @override
  Future<Store?> getById(String id) async => existing[id];

  @override
  Future<void> save(Store store, {bool markPending = true}) async {
    saved.add(store);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeExpenses implements IExpenseLocalRepository {
  final List<Expense> saved = [];

  @override
  Future<void> save(Expense expense, {bool markPending = true}) async {
    saved.add(expense);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakePriceObservations implements IPriceObservationLocalRepository {
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
