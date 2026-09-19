import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/repositories/i_price_observation_local_repository.dart';
import 'package:spend_lens/features/expense/domain/models/expense/e_expense_source.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/expense/domain/repositories/i_expense_local_repository.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/product/domain/repositories/i_product_local_repository.dart';
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

/// Saving on the Edit Receipt screen must mirror the receipt into the
/// `expenses` box.
///
/// Home, History and Analytics all watch `expenses` and NONE reads
/// `receipts`. `ReviewBloc` (the OCR-SUCCESS path) was the only caller of
/// `CreateExpenseFromReceiptUseCase`, so the manual-entry path — scan fails
/// → "Enter Manually" → `EditReceiptPage` → Save — persisted a `Receipt`
/// with items and products but never an `Expense`. The record saved
/// successfully and the app still showed "No expenses yet", with a restart
/// making no difference because nothing was missing from the boxes actually
/// being watched.
void main() {
  late _FakeReceiptRepository receipts;
  late _FakeReceiptItemRepository items;
  late _FakeProductRepository products;
  late _FakeStoreRepository stores;
  late _FakeExpenseRepository expenses;
  late _FakePriceObservationRepository priceObservations;

  final now = DateTime(2026, 9, 9, 14, 30);

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
        now: () => now,
      );

  /// The blank receipt `ScannerBody._onEnterManually` writes so the editor
  /// has a record to load: no items, zero total, no store, no category.
  Receipt blankReceipt() => Receipt(
        id: 'receipt-1',
        purchasedAt: now,
        itemsTotal: 0.0,
        currencyCode: 'MDL',
        updatedAt: now,
      );

  setUp(() {
    receipts = _FakeReceiptRepository();
    items = _FakeReceiptItemRepository();
    products = _FakeProductRepository();
    stores = _FakeStoreRepository();
    expenses = _FakeExpenseRepository();
    priceObservations = _FakePriceObservationRepository();
  });

  test('manual entry then save creates the mirrored expense', () async {
    await receipts.save(blankReceipt());

    final bloc = buildBloc()..add(const EditReceiptEvent.load('receipt-1'));
    await Future<void>.delayed(Duration.zero);

    bloc.add(const EditReceiptEvent.addItem());
    await Future<void>.delayed(Duration.zero);

    final itemId = bloc.state.items.single.id;
    bloc
      ..add(EditReceiptEvent.updateItemName(itemId, 'Milk 1L'))
      ..add(EditReceiptEvent.updateItemPrice(itemId, 22.90));
    await Future<void>.delayed(Duration.zero);

    bloc.add(const EditReceiptEvent.save());
    await Future<void>.delayed(Duration.zero);

    final saved = await expenses.getAll();
    expect(
      saved,
      hasLength(1),
      reason: 'Save wrote a Receipt but no Expense — Home/History/Analytics '
          'watch the expenses box, so the record stays invisible.',
    );
    expect(saved.single.id, 'receipt-1');
    expect(saved.single.amount, 22.90);
    expect(saved.single.source, EExpenseSource.receipt);
    expect(saved.single.currencyCode, 'MDL');

    await bloc.close();
  });

  test('the mirrored expense shares the receipt id, so re-saving updates '
      'rather than duplicating', () async {
    await receipts.save(blankReceipt());

    final bloc = buildBloc()..add(const EditReceiptEvent.load('receipt-1'));
    await Future<void>.delayed(Duration.zero);

    bloc.add(const EditReceiptEvent.addItem());
    await Future<void>.delayed(Duration.zero);
    final itemId = bloc.state.items.single.id;
    bloc
      ..add(EditReceiptEvent.updateItemName(itemId, 'Milk 1L'))
      ..add(EditReceiptEvent.updateItemPrice(itemId, 22.90))
      ..add(const EditReceiptEvent.save());
    await Future<void>.delayed(Duration.zero);

    // Edit the amount and save again — the stale-expense half of the bug.
    bloc
      ..add(EditReceiptEvent.updateItemPrice(itemId, 30.00))
      ..add(const EditReceiptEvent.save());
    await Future<void>.delayed(Duration.zero);

    final saved = await expenses.getAll();
    expect(saved, hasLength(1), reason: 'id identity must overwrite');
    expect(saved.single.amount, 30.00);

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
  Future<void> deleteLocalOnly(String id) async =>
      _store.remove(id);

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
  Future<void> deleteLocalOnly(String id) async =>
      _store.remove(id);

  @override
  Stream<List<ReceiptItem>> watchAll() =>
      Stream.value(_store.values.toList());

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
  Future<void> deleteLocalOnly(String id) async =>
      _store.remove(id);

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
  Future<void> deleteLocalOnly(String id) async =>
      _store.remove(id);

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
  Future<void> deleteLocalOnly(String id) async =>
      _store.remove(id);

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
