import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/models/e_sync_status.dart';
import 'package:spend_lens/core/resources/colors/app_color_scheme.dart';
import 'package:spend_lens/core/resources/localization/gen/app_localizations_en.dart';
import 'package:spend_lens/features/category/domain/models/category/category.dart';
import 'package:spend_lens/features/expense/domain/models/expense/e_expense_source.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/history/presentation/pages/record_detail_page/widgets/record_detail_view_data.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';

/// Record Detail renders one of TWO branches of the design's artboard, and
/// the choice is DATA-driven — `Expense.source`, never a flag the caller
/// passes in. These tests pin that mapping plus the two label pairs and the
/// store-name resolution that the receipt branch depends on.
void main() {
  final lo = AppLocalizationsEn();
  final scheme = AppColorScheme.dark();
  final timestamp = DateTime(2026, 9, 6, 18, 42);

  final categories = [
    Category(
      id: 'catFood',
      name: 'catFood',
      colorHex: '#C4B5FD',
      isBuiltIn: true,
      updatedAt: timestamp,
    ),
  ];

  final stores = [
    Store(id: 'store-lidl', name: 'Lidl', updatedAt: timestamp),
  ];

  Expense expense({
    EExpenseSource source = EExpenseSource.cash,
    String? storeId,
    String? note,
  }) =>
      Expense(
        id: 'record-1',
        amount: 110.10,
        currencyCode: 'MDL',
        categoryId: 'catFood',
        storeId: storeId,
        note: note,
        occurredAt: timestamp,
        source: source,
        updatedAt: timestamp,
      );

  Receipt receipt({
    String? storeId = 'store-lidl',
    ESyncStatus syncStatus = ESyncStatus.synced,
  }) =>
      Receipt(
        id: 'record-1',
        storeId: storeId,
        purchasedAt: timestamp,
        itemsTotal: 110.10,
        currencyCode: 'MDL',
        updatedAt: timestamp,
        syncStatus: syncStatus,
      );

  group('branch selection follows Expense.source', () {
    test('a cash expense is not the receipt branch', () {
      final viewData = RecordDetailViewData.resolve(
        expense: expense(),
        categories: categories,
        stores: stores,
        receipt: null,
        lo: lo,
        scheme: scheme,
      );

      expect(viewData.isReceipt, isFalse);
      expect(viewData.typeLabel, lo.cashType);
      expect(viewData.deleteLabel, lo.deleteExpense);
    });

    test('a receipt-sourced expense is the receipt branch', () {
      final viewData = RecordDetailViewData.resolve(
        expense: expense(source: EExpenseSource.receipt),
        categories: categories,
        stores: stores,
        receipt: receipt(),
        lo: lo,
        scheme: scheme,
      );

      expect(viewData.isReceipt, isTrue);
      expect(viewData.typeLabel, lo.receipt);
      expect(viewData.deleteLabel, lo.deleteReceipt);
    });
  });

  group('store name resolution', () {
    // `CreateExpenseFromReceiptUseCase` writes the mirrored Expense WITHOUT
    // a storeId (`ReviewBloc` passes none), so reading only Expense.storeId
    // would title every scanned receipt with its category name instead of
    // the shop.
    test('falls back to the receipt store when the expense has none', () {
      final viewData = RecordDetailViewData.resolve(
        expense: expense(source: EExpenseSource.receipt),
        categories: categories,
        stores: stores,
        receipt: receipt(),
        lo: lo,
        scheme: scheme,
      );

      expect(viewData.name, 'Lidl');
      expect(viewData.initial, 'L');
    });

    test('uses the category name when neither record names a store', () {
      final viewData = RecordDetailViewData.resolve(
        expense: expense(source: EExpenseSource.receipt),
        categories: categories,
        stores: stores,
        receipt: receipt(storeId: null),
        lo: lo,
        scheme: scheme,
      );

      expect(viewData.name, lo.catFood);
    });

    test('a cash expense still resolves its own storeId', () {
      final viewData = RecordDetailViewData.resolve(
        expense: expense(storeId: 'store-lidl'),
        categories: categories,
        stores: stores,
        receipt: null,
        lo: lo,
        scheme: scheme,
      );

      expect(viewData.name, 'Lidl');
    });
  });

  group('date line', () {
    // The design's `dDate` is "Sep 6, 2026 · Receipt" — the day plus the
    // record type, with no clock time.
    test('is the day followed by the type label', () {
      final viewData = RecordDetailViewData.resolve(
        expense: expense(source: EExpenseSource.receipt),
        categories: categories,
        stores: stores,
        receipt: receipt(),
        lo: lo,
        scheme: scheme,
      );

      expect(viewData.dateText, endsWith('· ${lo.receipt}'));
      expect(viewData.dateText, contains('2026'));
      expect(viewData.dateText, isNot(contains('18:42')));
      expect(viewData.dateText, isNot(contains('6:42')));
    });
  });

  group('sync badge', () {
    // The badge reports the RECEIPT's own row. A cash expense has no
    // receipt behind it, and the mirrored expense's status drifts from the
    // receipt's (they are stamped independently), so showing one on a cash
    // record would misreport it.
    test('is absent for a cash expense', () {
      final viewData = RecordDetailViewData.resolve(
        expense: expense(),
        categories: categories,
        stores: stores,
        receipt: null,
        lo: lo,
        scheme: scheme,
      );

      expect(viewData.syncLabel, isNull);
      expect(viewData.syncDotColor, isNull);
    });

    test('reads Synced from a synced receipt', () {
      final viewData = RecordDetailViewData.resolve(
        expense: expense(source: EExpenseSource.receipt),
        categories: categories,
        stores: stores,
        receipt: receipt(),
        lo: lo,
        scheme: scheme,
      );

      expect(viewData.syncLabel, lo.synced);
      expect(viewData.syncDotColor, scheme.accent2);
    });

    test('reads pending from a not-yet-uploaded receipt', () {
      final viewData = RecordDetailViewData.resolve(
        expense: expense(source: EExpenseSource.receipt),
        categories: categories,
        stores: stores,
        receipt: receipt(syncStatus: ESyncStatus.pendingCreate),
        lo: lo,
        scheme: scheme,
      );

      expect(viewData.syncLabel, lo.syncPendingUpload);
      expect(viewData.syncDotColor, scheme.warn);
    });

    test('an edited receipt reads the same pending label as a new one', () {
      RecordDetailViewData resolveWith(ESyncStatus status) =>
          RecordDetailViewData.resolve(
            expense: expense(source: EExpenseSource.receipt),
            categories: categories,
            stores: stores,
            receipt: receipt(syncStatus: status),
            lo: lo,
            scheme: scheme,
          );

      expect(
        resolveWith(ESyncStatus.pendingUpdate).syncLabel,
        resolveWith(ESyncStatus.pendingCreate).syncLabel,
      );
    });
  });

  test('the note is carried through for the cash branch', () {
    final viewData = RecordDetailViewData.resolve(
      expense: expense(note: 'Taxi to airport'),
      categories: categories,
      stores: stores,
      receipt: null,
      lo: lo,
      scheme: scheme,
    );

    expect(viewData.note, 'Taxi to airport');
  });
}
