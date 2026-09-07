import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/repositories/i_price_observation_local_repository.dart';
import 'package:spend_lens/features/backup/domain/backup_json_codec.dart';
import 'package:spend_lens/features/backup/domain/use_cases/import_backup_use_case.dart';
import 'package:spend_lens/features/category/domain/models/category/category.dart';
import 'package:spend_lens/features/category/domain/repositories/i_category_local_repository.dart';
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
import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/store/domain/repositories/i_store_local_repository.dart';

class _FakeReceiptRepository implements IReceiptLocalRepository {
  final Map<String, Receipt> store = {};

  @override
  Future<void> save(Receipt receipt) async => store[receipt.id] = receipt;

  @override
  Future<void> delete(String id) async => store.remove(id);

  @override
  Future<Receipt?> getById(String id) async => store[id];

  @override
  Future<List<Receipt>> getAll() async => store.values.toList();

  @override
  Stream<List<Receipt>> watchAll() => Stream.value(store.values.toList());
}

class _FakeReceiptItemRepository implements IReceiptItemLocalRepository {
  final Map<String, ReceiptItem> store = {};

  @override
  Future<void> save(ReceiptItem item) async => store[item.id] = item;

  @override
  Future<void> delete(String id) async => store.remove(id);

  @override
  Future<ReceiptItem?> getById(String id) async => store[id];

  @override
  Future<List<ReceiptItem>> getAll() async => store.values.toList();

  @override
  Stream<List<ReceiptItem>> watchAll() => Stream.value(store.values.toList());

  @override
  Stream<List<ReceiptItem>> watchByReceiptId(List<String> itemIds) =>
      Stream.value(
        store.values.where((e) => itemIds.contains(e.id)).toList(),
      );
}

class _FakeProductRepository implements IProductLocalRepository {
  final Map<String, Product> store = {};

  @override
  Future<void> save(Product product) async => store[product.id] = product;

  @override
  Future<void> delete(String id) async => store.remove(id);

  @override
  Future<Product?> getById(String id) async => store[id];

  @override
  Future<List<Product>> getAll() async => store.values.toList();

  @override
  Stream<List<Product>> watchAll() => Stream.value(store.values.toList());
}

class _FakeStoreRepository implements IStoreLocalRepository {
  final Map<String, Store> store = {};

  @override
  Future<void> save(Store s) async => store[s.id] = s;

  @override
  Future<void> delete(String id) async => store.remove(id);

  @override
  Future<Store?> getById(String id) async => store[id];

  @override
  Future<List<Store>> getAll() async => store.values.toList();

  @override
  Stream<List<Store>> watchAll() => Stream.value(store.values.toList());
}

class _FakeCategoryRepository implements ICategoryLocalRepository {
  final Map<String, Category> store = {};

  @override
  Future<void> save(Category category) async => store[category.id] = category;

  @override
  Future<void> saveAll(List<Category> categories) async {
    for (final c in categories) {
      store[c.id] = c;
    }
  }

  @override
  Future<void> delete(String id) async => store.remove(id);

  @override
  Future<Category?> getById(String id) async => store[id];

  @override
  Future<List<Category>> getAll() async => store.values.toList();

  @override
  Stream<List<Category>> watchAll() => Stream.value(store.values.toList());
}

class _FakeExpenseRepository implements IExpenseLocalRepository {
  final Map<String, Expense> store = {};

  @override
  Future<void> save(Expense expense) async => store[expense.id] = expense;

  @override
  Future<void> delete(String id) async => store.remove(id);

  @override
  Future<Expense?> getById(String id) async => store[id];

  @override
  Future<List<Expense>> getAll() async => store.values.toList();

  @override
  Stream<List<Expense>> watchAll() => Stream.value(store.values.toList());
}

class _FakePriceObservationRepository
    implements IPriceObservationLocalRepository {
  final Map<String, PriceObservation> store = {};

  @override
  Future<void> save(PriceObservation observation) async =>
      store[observation.id] = observation;

  @override
  Future<void> delete(String id) async => store.remove(id);

  @override
  Future<PriceObservation?> getById(String id) async => store[id];

  @override
  Future<List<PriceObservation>> getAll() async => store.values.toList();

  @override
  Stream<List<PriceObservation>> watchAll() =>
      Stream.value(store.values.toList());
}

class _FakeSettingsRepository implements ISettingsLocalRepository {
  AppSettings _settings;

  _FakeSettingsRepository(this._settings);

  @override
  Future<AppSettings> get() async => _settings;

  @override
  Stream<AppSettings> watch() => Stream.value(_settings);

  @override
  Future<void> save(AppSettings settings) async => _settings = settings;
}

/// design_spendlens.md §6/§9/§11 — import "validates the schema and
/// migrates, never blind-overwrites" (spec §61) + `dataCleared` reset
/// (`~/.claude/rules/delete_all_records_rules.md`).
void main() {
  late _FakeReceiptRepository receiptRepo;
  late _FakeReceiptItemRepository receiptItemRepo;
  late _FakeProductRepository productRepo;
  late _FakeStoreRepository storeRepo;
  late _FakeCategoryRepository categoryRepo;
  late _FakeExpenseRepository expenseRepo;
  late _FakePriceObservationRepository priceObservationRepo;
  late _FakeSettingsRepository settingsRepo;
  late ImportBackupUseCase useCase;

  ImportBackupUseCase buildUseCase({required AppSettings initialSettings}) {
    receiptRepo = _FakeReceiptRepository();
    receiptItemRepo = _FakeReceiptItemRepository();
    productRepo = _FakeProductRepository();
    storeRepo = _FakeStoreRepository();
    categoryRepo = _FakeCategoryRepository();
    expenseRepo = _FakeExpenseRepository();
    priceObservationRepo = _FakePriceObservationRepository();
    settingsRepo = _FakeSettingsRepository(initialSettings);

    return ImportBackupUseCase(
      receiptLocalRepository: receiptRepo,
      receiptItemLocalRepository: receiptItemRepo,
      productLocalRepository: productRepo,
      storeLocalRepository: storeRepo,
      categoryLocalRepository: categoryRepo,
      expenseLocalRepository: expenseRepo,
      priceObservationLocalRepository: priceObservationRepo,
      settingsLocalRepository: settingsRepo,
    );
  }

  setUp(() {
    useCase = buildUseCase(initialSettings: const AppSettings());
  });

  group('never blind-overwrites', () {
    test('import MERGES by id — an existing record not in the backup survives', () async {
      final existingStore = Store(
        id: 'store-keep',
        name: 'Kept Store',
        updatedAt: DateTime(2026, 1, 1),
      );
      await storeRepo.save(existingStore);

      const raw = '''
      {
        "schemaVersion": 1,
        "exportedAt": "2026-01-01T00:00:00.000",
        "stores": [
          {"id": "store-new", "name": "New Store", "receiptAliases": [], "type": "other", "updatedAt": "2026-01-01T00:00:00.000", "syncStatus": "synced"}
        ]
      }
      ''';

      await useCase.call(raw);

      expect(storeRepo.store.containsKey('store-keep'), isTrue);
      expect(storeRepo.store.containsKey('store-new'), isTrue);
      expect(storeRepo.store.length, 2);
    });

    test('a record with a matching id is updated in place, not duplicated', () async {
      await storeRepo.save(
        Store(id: 'store-1', name: 'Old Name', updatedAt: DateTime(2026, 1, 1)),
      );

      final raw =
          '{"schemaVersion": 1, "exportedAt": "2026-01-02T00:00:00.000", '
          '"stores": [{"id": "store-1", "name": "New Name", "receiptAliases": [], '
          '"type": "other", "updatedAt": "2026-01-02T00:00:00.000", "syncStatus": "synced"}]}';

      await useCase.call(raw);

      expect(storeRepo.store.length, 1);
      expect(storeRepo.store['store-1']!.name, 'New Name');
    });

    test('nothing is written when the schema is too new', () async {
      await storeRepo.save(
        Store(id: 'store-1', name: 'Untouched', updatedAt: DateTime(2026, 1, 1)),
      );

      final raw =
          '{"schemaVersion": ${BackupJsonCodec.currentSchemaVersion + 1}, '
          '"exportedAt": "2026-01-01T00:00:00.000"}';

      await expectLater(
        useCase.call(raw),
        throwsA(isA<BackupSchemaTooNewException>()),
      );

      expect(storeRepo.store.length, 1);
      expect(storeRepo.store['store-1']!.name, 'Untouched');
    });
  });

  group('dataCleared reset', () {
    test('import resets dataCleared to false when it was true', () async {
      useCase = buildUseCase(
        initialSettings: const AppSettings(dataCleared: true),
      );

      const raw = '''
      {
        "schemaVersion": 1,
        "exportedAt": "2026-01-01T00:00:00.000",
        "expenses": []
      }
      ''';

      await useCase.call(raw);

      final settings = await settingsRepo.get();
      expect(settings.dataCleared, isFalse);
    });

    test('import does not touch dataCleared when it was already false', () async {
      const raw = '''
      {
        "schemaVersion": 1,
        "exportedAt": "2026-01-01T00:00:00.000"
      }
      ''';

      await useCase.call(raw);

      final settings = await settingsRepo.get();
      expect(settings.dataCleared, isFalse);
    });
  });

  test('reports the correct receipt/expense counts', () async {
    const raw = '''
    {
      "schemaVersion": 1,
      "exportedAt": "2026-01-01T00:00:00.000",
      "receipts": [
        {"id": "r1", "purchasedAt": "2026-01-01T00:00:00.000", "itemsTotal": 10.0,
         "currencyCode": "MDL", "itemIds": [], "isReconciled": false,
         "updatedAt": "2026-01-01T00:00:00.000", "syncStatus": "synced"}
      ],
      "expenses": [
        {"id": "e1", "amount": 10.0, "currencyCode": "MDL", "categoryId": "c1",
         "occurredAt": "2026-01-01T00:00:00.000", "source": "receipt",
         "updatedAt": "2026-01-01T00:00:00.000", "syncStatus": "synced"},
        {"id": "e2", "amount": 5.0, "currencyCode": "MDL", "categoryId": "c1",
         "occurredAt": "2026-01-01T00:00:00.000", "source": "cash",
         "updatedAt": "2026-01-01T00:00:00.000", "syncStatus": "synced"}
      ]
    }
    ''';

    final result = await useCase.call(raw);

    expect(result.receiptCount, 1);
    expect(result.expenseCount, 2);
  });
}
