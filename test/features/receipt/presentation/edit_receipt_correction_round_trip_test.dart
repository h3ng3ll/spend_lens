import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/routes/init_router/init_router.dart';
import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/repositories/i_price_observation_local_repository.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/expense/domain/repositories/i_expense_local_repository.dart';
import 'package:spend_lens/features/product/domain/models/product/e_unit.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/product/domain/repositories/i_product_local_repository.dart';
import 'package:spend_lens/features/product/domain/use_cases/rename_product_use_case.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';
import 'package:spend_lens/features/receipt/domain/parser/parsed_receipt.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_item_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/use_cases/create_expense_from_receipt_use_case.dart';
import 'package:spend_lens/features/receipt/domain/use_cases/record_price_observations_use_case.dart';
import 'package:spend_lens/features/receipt/presentation/bloc/edit_receipt_bloc/edit_receipt_bloc.dart';
import 'package:spend_lens/features/scanner/domain/pending_receipt_draft_store.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/store/domain/repositories/i_store_local_repository.dart';

/// An item renamed on the UNSAVED scan must SURVIVE `Apply corrections`.
///
/// The Review <-> Edit loop is pure navigation, so the only thing carrying
/// state between the two screens is the draft's [ParsedReceipt]. Its line
/// candidates held ONLY `rawName` — which spec §11 forbids altering — so a
/// rename had nowhere to live: `_applyCorrectionsToDraft` wrote the OCR text
/// back out, and re-loading read that same text in as the name. The symptom
/// was that editing an item title, tapping `Apply corrections` and returning
/// showed the ORIGINAL OCR string again, with no error and no crash — the
/// edit looked accepted and was discarded a frame later.
void main() {
  late PendingReceiptDraftStore draftStore;
  late _FakeReceiptRepository receipts;
  late _FakeReceiptItemRepository items;
  late _FakeProductRepository products;
  late _FakeStoreRepository stores;
  late _FakeExpenseRepository expenses;
  late _FakePriceObservationRepository priceObservations;

  final now = DateTime(2026, 9, 20, 13, 26);

  const rawName = 'SACOSA ECOTAX8,151e1 17 98 A';
  const correctedName = 'Shopping bag';

  EditReceiptBloc buildBloc() => EditReceiptBloc(
    receiptRepository: receipts,
    draftStore: draftStore,
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

  setUp(() {
    draftStore = PendingReceiptDraftStore();
    receipts = _FakeReceiptRepository();
    items = _FakeReceiptItemRepository();
    products = _FakeProductRepository();
    stores = _FakeStoreRepository();
    expenses = _FakeExpenseRepository();
    priceObservations = _FakePriceObservationRepository();

    draftStore.set(
      PendingReceiptDraft(
        parsedReceipt: const ParsedReceipt(
          storeName: 'Kaufland',
          total: 17.98,
          items: [
            ParsedLineCandidate(
              rawName: rawName,
              quantity: 1.0,
              unit: EUnit.piece,
              lineTotal: 17.98,
              confidence: 0.9,
              lineIndex: 0,
            ),
          ],
        ),
      ),
    );
  });

  test('a rename survives Apply corrections on the draft', () async {
    final bloc = buildBloc()
      ..add(const EditReceiptEvent.load(kPendingDraftReceiptId));
    await Future<void>.delayed(Duration.zero);

    final itemId = bloc.state.items.single.id;
    bloc.add(EditReceiptEvent.updateItemName(itemId, correctedName));
    await Future<void>.delayed(Duration.zero);

    bloc.add(const EditReceiptEvent.save());
    await Future<void>.delayed(Duration.zero);

    final candidate = draftStore.current!.parsedReceipt.items.single;
    expect(
      candidate.name,
      correctedName,
      reason: 'Apply corrections dropped the edited name, so Review re-read '
          'rawName as the name and the rename was silently reverted.',
    );
    expect(
      candidate.rawName,
      rawName,
      reason: 'rawName must stay byte-for-byte what the receipt printed '
          '(spec §11).',
    );

    await bloc.close();
  });

  test('re-entering the editor shows the corrected name, not the OCR text',
      () async {
    final first = buildBloc()
      ..add(const EditReceiptEvent.load(kPendingDraftReceiptId));
    await Future<void>.delayed(Duration.zero);

    first.add(
      EditReceiptEvent.updateItemName(
        first.state.items.single.id,
        correctedName,
      ),
    );
    await Future<void>.delayed(Duration.zero);
    first.add(const EditReceiptEvent.save());
    await Future<void>.delayed(Duration.zero);
    await first.close();

    // The second trip is where the user "tries again and it hasn't changed":
    // the editor re-seeds from the draft it just wrote.
    final second = buildBloc()
      ..add(const EditReceiptEvent.load(kPendingDraftReceiptId));
    await Future<void>.delayed(Duration.zero);

    final reloaded = second.state.items.single;
    expect(reloaded.name, correctedName);
    expect(reloaded.rawName, rawName);

    await second.close();
  });

  test('an untouched line still shows the OCR text as its name', () async {
    final bloc = buildBloc()
      ..add(const EditReceiptEvent.load(kPendingDraftReceiptId));
    await Future<void>.delayed(Duration.zero);

    expect(
      bloc.state.items.single.name,
      rawName,
      reason: 'With no correction yet, rawName is still what should show.',
    );

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
