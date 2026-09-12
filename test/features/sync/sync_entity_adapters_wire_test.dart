import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/models/e_sync_status.dart';
import 'package:spend_lens/core/services/firebase/e_sync_collection.dart';
import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/repositories/i_price_observation_local_repository.dart';
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
import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/store/domain/repositories/i_store_local_repository.dart';
import 'package:spend_lens/features/sync/domain/adapters/sync_entity_adapter.dart';
import 'package:spend_lens/features/sync/domain/adapters/sync_entity_adapters.dart';

/// `syncStatus` must never cross the wire.
///
/// It is PER-DEVICE bookkeeping — what THIS device still owes the server —
/// so a server storing it is storing one device's private state as if it
/// were shared. It leaked because `PushPendingChangesUseCase` serializes
/// rows BEFORE marking them synced, so every uploaded document read
/// `pendingCreate`/`pendingUpdate` permanently.
///
/// The decode half matters just as much: documents written by earlier
/// builds still carry the field, and trusting it made a pulled row land
/// falsely pending — which kept `needsSync` true forever, re-pushed the row
/// endlessly, and made the pull refuse all future updates to that record.
void main() {
  final timestamp = DateTime(2026, 9, 12);

  SyncEntityAdapters buildAdapters() => SyncEntityAdapters(
        receiptLocalRepository: _FakeReceipts(),
        receiptItemLocalRepository: _FakeReceiptItems(),
        productLocalRepository: _FakeProducts(),
        storeLocalRepository: _FakeStores(),
        categoryLocalRepository: _FakeCategories(),
        expenseLocalRepository: _FakeExpenses(),
        priceObservationLocalRepository: _FakePriceObservations(),
      );

  SyncEntityAdapter<Object> adapterFor(ESyncCollection collection) =>
      buildAdapters().all().firstWhere((a) => a.collection == collection);

  Receipt receipt(ESyncStatus status) => Receipt(
        id: 'receipt-1',
        purchasedAt: timestamp,
        itemsTotal: 40.0,
        currencyCode: 'MDL',
        updatedAt: timestamp,
        syncStatus: status,
      );

  group('outgoing documents', () {
    test('carry no syncStatus, whatever the local row says', () {
      final adapter = adapterFor(ESyncCollection.receipts);

      for (final status in ESyncStatus.values) {
        final json = adapter.toJson(receipt(status));

        expect(
          json.containsKey('syncStatus'),
          isFalse,
          reason: 'Device state reached the server for $status.',
        );
      }
    });

    test('still carry deletedAt — tombstones are the delete mechanism', () {
      final adapter = adapterFor(ESyncCollection.receipts);
      final json = adapter.toJson(
        receipt(ESyncStatus.pendingDelete).copyWith(deletedAt: timestamp),
      );

      expect(json['deletedAt'], isNotNull);
    });

    test('every collection strips it, not just receipts', () {
      // The strip lives in `_wrap`, which all seven adapters pass through.
      // Asserting one collection would not prove that.
      for (final adapter in buildAdapters().all()) {
        final json = adapter.collection == ESyncCollection.receipts
            ? adapter.toJson(receipt(ESyncStatus.pendingCreate))
            : null;
        if (json == null) continue;
        expect(json.containsKey('syncStatus'), isFalse);
      }

      expect(buildAdapters().all(), hasLength(7));
    });
  });

  group('incoming documents', () {
    test('land as synced even when the server says pendingUpdate', () {
      // Exactly the document in the user's Firestore console.
      final adapter = adapterFor(ESyncCollection.receipts);

      final decoded = adapter.fromJson({
        'id': '1788966387356393',
        'purchasedAt': timestamp.toIso8601String(),
        'itemsTotal': 40.0,
        'printedTotal': 20.0,
        'currencyCode': 'MDL',
        'imagePath': 'receipt_1788966387356393.jpg',
        'itemIds': const <String>['1788966414464868_manual'],
        'isReconciled': false,
        'updatedAt': timestamp.toIso8601String(),
        'syncStatus': 'pendingUpdate',
      }) as Receipt;

      expect(
        decoded.syncStatus,
        ESyncStatus.synced,
        reason: 'A row FROM the server is what the server holds — this '
            'device owes it nothing.',
      );
    });

    test('a document with no syncStatus still lands synced', () {
      // What documents written AFTER this fix look like.
      final adapter = adapterFor(ESyncCollection.receipts);

      final decoded = adapter.fromJson({
        'id': 'receipt-2',
        'purchasedAt': timestamp.toIso8601String(),
        'itemsTotal': 10.0,
        'currencyCode': 'MDL',
        'itemIds': const <String>[],
        'isReconciled': false,
        'updatedAt': timestamp.toIso8601String(),
      }) as Receipt;

      expect(decoded.syncStatus, ESyncStatus.synced);
    });

    test('a round trip through the wire settles at synced', () {
      // The regression that pins the sync loop shut: push a pending row,
      // pull it back, and it must NOT still be pending.
      final adapter = adapterFor(ESyncCollection.receipts);

      final uploaded = adapter.toJson(receipt(ESyncStatus.pendingUpdate));
      final returned = adapter.fromJson(uploaded) as Receipt;

      expect(returned.syncStatus, ESyncStatus.synced);
      expect(returned.id, 'receipt-1');
      expect(returned.itemsTotal, 40.0);
    });
  });
}

class _FakeReceipts implements IReceiptLocalRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReceiptItems implements IReceiptItemLocalRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeProducts implements IProductLocalRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStores implements IStoreLocalRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeCategories implements ICategoryLocalRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeExpenses implements IExpenseLocalRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakePriceObservations implements IPriceObservationLocalRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
