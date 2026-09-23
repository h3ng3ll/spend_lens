import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/services/firebase/firebase_storage_service.dart';
import 'package:spend_lens/core/services/logger_service.dart';

import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/repositories/i_price_observation_local_repository.dart';
import 'package:spend_lens/features/category/domain/models/category/category.dart';
import 'package:spend_lens/features/category/domain/repositories/i_category_local_repository.dart';
import 'package:spend_lens/features/expense/domain/models/expense/e_expense_source.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/expense/domain/repositories/i_expense_local_repository.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/product/domain/repositories/i_product_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_item_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_local_repository.dart';
import 'package:spend_lens/features/settings/domain/models/app_settings/app_settings.dart';
import 'package:spend_lens/features/settings/domain/repositories/i_settings_local_repository.dart';
import 'package:spend_lens/features/settings/domain/use_cases/delete_all_records_use_case.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/store/domain/repositories/i_store_local_repository.dart';

/// REGRESSION: "Delete all data" cleared three of seven collections.
///
/// The use case was written at M5, when the app was manual-entry only and
/// receipts/receipt items/products/price observations genuinely held nothing.
/// Its own doc said M8 "must extend this use case's dependency list" once
/// scanning existed. M8 shipped; the list was never extended.
///
/// The visible symptom was the one the user reported: after "Delete all data"
/// the Profile screen still showed megabytes of cloud storage, because the
/// `Receipt` rows naming those photos were never tombstoned and the next sync
/// simply re-published them.
void main() {
  late _FakeExpenses expenses;
  late _FakeStores stores;
  late _FakeCategories categories;
  late _FakeReceipts receipts;
  late _FakeReceiptItems receiptItems;
  late _FakeProducts products;
  late _FakeObservations observations;
  late _FakeSettings settings;
  late _FakeStorage storage;

  final now = DateTime(2026, 9, 20);

  DeleteAllRecordsUseCase buildUseCase() => DeleteAllRecordsUseCase(
    expenseLocalRepository: expenses,
    storeLocalRepository: stores,
    categoryLocalRepository: categories,
    receiptLocalRepository: receipts,
    receiptItemLocalRepository: receiptItems,
    productLocalRepository: products,
    priceObservationLocalRepository: observations,
    settingsLocalRepository: settings,
    storageService: storage,
    loggerService: _FakeLogger(),
  );

  setUp(() {
    expenses = _FakeExpenses();
    stores = _FakeStores();
    categories = _FakeCategories();
    receipts = _FakeReceipts();
    receiptItems = _FakeReceiptItems();
    products = _FakeProducts();
    observations = _FakeObservations();
    settings = _FakeSettings();
    storage = _FakeStorage();

    expenses.rows.add(
      Expense(
        id: 'e1',
        amount: 10.0,
        currencyCode: 'MDL',
        categoryId: 'catOther',
        occurredAt: now,
        source: EExpenseSource.receipt,
        updatedAt: now,
      ),
    );
    stores.rows.add(Store(id: 's1', name: 'Kaufland', updatedAt: now));
    receipts.rows.add(
      Receipt(
        id: 'r1',
        purchasedAt: now,
        itemsTotal: 10.0,
        currencyCode: 'MDL',
        imagePath: 'receipt_r1.jpg',
        updatedAt: now,
      ),
    );
    receiptItems.rows.add(
      ReceiptItem(
        id: 'ri1',
        rawName: 'LAPTE',
        normalizedName: 'Lapte',
        quantity: 1.0,
        lineTotal: 10.0,
        confidence: 1.0,
        lineIndex: 0,
        updatedAt: now,
      ),
    );
    products.rows.add(
      Product(
        id: 'p1',
        normalizedName: 'lapte',
        displayName: 'Lapte',
        updatedAt: now,
      ),
    );
    observations.rows.add(
      PriceObservation(
        id: 'o1',
        productId: 'p1',
        observedAt: now,
        comparableUnitPrice: 10.0,
        currencyCode: 'MDL',
        updatedAt: now,
      ),
    );
  });

  test('clears every scanning-era collection, not just the M5 three', () async {
    await buildUseCase().call(uid: 'u1');

    expect(
      receipts.deleted,
      ['r1'],
      reason: 'A surviving Receipt row keeps its cloud photo alive — this is '
          'the storage-still-shows-MB bug.',
    );
    expect(receiptItems.deleted, ['ri1']);
    expect(products.deleted, ['p1']);
    expect(
      observations.deleted,
      ['o1'],
      reason: 'Observations must be TOMBSTONED so the removal is pushed — a '
          'hard delete left every priceObservations doc in Firestore.',
    );
    expect(observations.hardDeleted, isEmpty);
  });

  test('still clears the collections it always did', () async {
    await buildUseCase().call(uid: 'u1');

    expect(expenses.deleted, ['e1']);
    expect(stores.deleted, ['s1']);
  });

  test('built-in categories still survive by design', () async {
    categories.rows.addAll([
      Category(
        id: 'catOther',
        name: 'other',
        colorHex: '#FFFFFF',
        isBuiltIn: true,
        updatedAt: now,
      ),
      Category(
        id: 'c-mine',
        name: 'Mine',
        colorHex: '#FFFFFF',
        isBuiltIn: false,
        updatedAt: now,
      ),
    ]);

    await buildUseCase().call(uid: 'u1');

    // The design's own restore path: deleting the built-ins contradicted the
    // footer that says they cannot be deleted.
    expect(categories.deleted, ['c-mine']);
  });

  test('sets dataCleared so the seed cannot repopulate the app', () async {
    await buildUseCase().call(uid: 'u1');

    expect(settings.saved?.dataCleared, isTrue);
  });

  test('sweeps the bucket so the storage bar drops to zero', () async {
    await buildUseCase().call(uid: 'u1');

    expect(
      storage.sweptUids,
      ['u1'],
      reason: 'Tombstones remove Firestore docs only — receipt photos, logos '
          'and product photos stayed in Storage (the "still 7 MB" bug).',
    );
  });

  test('signed out: no bucket sweep, records still cleared', () async {
    await buildUseCase().call(uid: '');

    expect(storage.sweptUids, isEmpty);
    expect(expenses.deleted, ['e1']);
  });

  test('a failed bucket sweep does not abort the local wipe', () async {
    storage.fail = true;

    await buildUseCase().call(uid: 'u1');

    expect(expenses.deleted, ['e1']);
    expect(observations.deleted, ['o1']);
    expect(settings.saved?.dataCleared, isTrue);
  });
}

class _FakeExpenses implements IExpenseLocalRepository {
  final List<Expense> rows = [];
  final List<String> deleted = [];

  @override
  Future<List<Expense>> getAllIncludingDeleted() async => rows;

  @override
  Future<void> delete(String id) async => deleted.add(id);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStores implements IStoreLocalRepository {
  final List<Store> rows = [];
  final List<String> deleted = [];

  @override
  Future<List<Store>> getAllIncludingDeleted() async => rows;

  @override
  Future<void> delete(String id) async => deleted.add(id);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeCategories implements ICategoryLocalRepository {
  final List<Category> rows = [];
  final List<String> deleted = [];

  @override
  Future<List<Category>> getAllIncludingDeleted() async => rows;

  @override
  Future<void> delete(String id) async => deleted.add(id);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReceipts implements IReceiptLocalRepository {
  final List<Receipt> rows = [];
  final List<String> deleted = [];

  @override
  Future<List<Receipt>> getAllIncludingDeleted() async => rows;

  @override
  Future<void> delete(String id) async => deleted.add(id);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReceiptItems implements IReceiptItemLocalRepository {
  final List<ReceiptItem> rows = [];
  final List<String> deleted = [];

  @override
  Future<List<ReceiptItem>> getAllIncludingDeleted() async => rows;

  @override
  Future<void> delete(String id) async => deleted.add(id);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeProducts implements IProductLocalRepository {
  final List<Product> rows = [];
  final List<String> deleted = [];

  @override
  Future<List<Product>> getAllIncludingDeleted() async => rows;

  @override
  Future<void> delete(String id) async => deleted.add(id);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeObservations implements IPriceObservationLocalRepository {
  final List<PriceObservation> rows = [];
  final List<String> deleted = [];

  @override
  Future<List<PriceObservation>> getAllIncludingDeleted() async => rows;

  final List<String> hardDeleted = [];

  @override
  Future<void> delete(String id) async => deleted.add(id);

  @override
  Future<void> deleteLocalOnly(String id) async => hardDeleted.add(id);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSettings implements ISettingsLocalRepository {
  AppSettings? saved;

  @override
  Future<AppSettings> get() async => const AppSettings();

  @override
  Future<void> save(AppSettings settings) async => saved = settings;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStorage implements FirebaseStorageService {
  final List<String> sweptUids = [];
  bool fail = false;

  @override
  Future<void> deleteRecordFiles(String uid) async {
    if (fail) throw Exception('offline');
    sweptUids.add(uid);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeLogger implements LoggerService {
  @override
  noSuchMethod(Invocation invocation) {}
}
