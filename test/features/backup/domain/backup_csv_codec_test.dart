import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/backup/domain/backup_csv_codec.dart';
import 'package:spend_lens/features/category/domain/models/category/category.dart';
import 'package:spend_lens/features/expense/domain/models/expense/e_expense_source.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/store/domain/models/store/e_store_type.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';

/// design_spendlens.md §6/§9/§11 — "CSV escaping and row count".
void main() {
  final category = Category(
    id: 'cat-1',
    name: 'catFood',
    colorHex: '#A78BFA',
    isBuiltIn: true,
    updatedAt: DateTime(2026, 1, 1),
  );

  final store = Store(
    id: 'store-1',
    name: 'Green Hills',
    type: EStoreType.supermarket,
    updatedAt: DateTime(2026, 1, 1),
  );

  group('row count', () {
    test('rowCount is the DATA row count, excluding the header', () {
      final expenses = [
        Expense(
          id: 'exp-1',
          amount: 10.0,
          currencyCode: 'MDL',
          categoryId: category.id,
          occurredAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
        Expense(
          id: 'exp-2',
          amount: 20.0,
          currencyCode: 'MDL',
          categoryId: category.id,
          occurredAt: DateTime(2026, 1, 2),
          updatedAt: DateTime(2026, 1, 2),
        ),
        Expense(
          id: 'exp-3',
          amount: 30.0,
          currencyCode: 'MDL',
          categoryId: category.id,
          occurredAt: DateTime(2026, 1, 3),
          updatedAt: DateTime(2026, 1, 3),
        ),
      ];

      final result = BackupCsvCodec.encode(
        expenses: expenses,
        categories: [category],
        stores: [store],
      );

      expect(result.rowCount, 3);
      // Header + 3 data rows = 4 lines (plus a possible trailing newline).
      final lines = result.content.trim().split('\r\n');
      expect(lines.length, 4);
    });

    test('an empty expense list produces rowCount 0 and only the header', () {
      final result = BackupCsvCodec.encode(
        expenses: const [],
        categories: [category],
        stores: [store],
      );

      expect(result.rowCount, 0);
      final lines = result.content.trim().split('\r\n');
      expect(lines.length, 1);
      expect(lines.single, 'date,amount,currency,category,store,note,source');
    });
  });

  group('CSV escaping', () {
    test('a note containing a comma is quoted', () {
      final expense = Expense(
        id: 'exp-1',
        amount: 15.5,
        currencyCode: 'MDL',
        categoryId: category.id,
        note: 'Milk, bread, eggs',
        occurredAt: DateTime(2026, 1, 5),
        updatedAt: DateTime(2026, 1, 5),
      );

      final result = BackupCsvCodec.encode(
        expenses: [expense],
        categories: [category],
        stores: [store],
      );

      expect(result.content, contains('"Milk, bread, eggs"'));
    });

    test('a note containing double quotes is escaped by doubling them', () {
      final expense = Expense(
        id: 'exp-1',
        amount: 15.5,
        currencyCode: 'MDL',
        categoryId: category.id,
        note: 'Said "fresh" produce',
        occurredAt: DateTime(2026, 1, 5),
        updatedAt: DateTime(2026, 1, 5),
      );

      final result = BackupCsvCodec.encode(
        expenses: [expense],
        categories: [category],
        stores: [store],
      );

      expect(result.content, contains('"Said ""fresh"" produce"'));
    });

    test('a note containing a newline is quoted rather than splitting the row', () {
      final expense = Expense(
        id: 'exp-1',
        amount: 15.5,
        currencyCode: 'MDL',
        categoryId: category.id,
        note: 'Line one\nLine two',
        occurredAt: DateTime(2026, 1, 5),
        updatedAt: DateTime(2026, 1, 5),
      );

      final result = BackupCsvCodec.encode(
        expenses: [expense],
        categories: [category],
        stores: [store],
      );

      // Still exactly one DATA row despite the embedded newline.
      expect(result.rowCount, 1);
      expect(result.content, contains('"Line one\nLine two"'));
    });

    test('an unresolvable category/store id falls back to the raw id', () {
      final expense = Expense(
        id: 'exp-1',
        amount: 15.5,
        currencyCode: 'MDL',
        categoryId: 'unknown-cat',
        storeId: 'unknown-store',
        occurredAt: DateTime(2026, 1, 5),
        updatedAt: DateTime(2026, 1, 5),
        source: EExpenseSource.cash,
      );

      final result = BackupCsvCodec.encode(
        expenses: [expense],
        categories: [category],
        stores: [store],
      );

      expect(result.content, contains('unknown-cat'));
    });
  });
}
