import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/models/e_sync_status.dart';
import 'package:spend_lens/features/backup/domain/backup_json_codec.dart';
import 'package:spend_lens/features/backup/domain/models/backup_bundle/backup_bundle.dart';
import 'package:spend_lens/features/category/domain/models/category/category.dart';
import 'package:spend_lens/features/expense/domain/models/expense/e_expense_source.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/store/domain/models/store/e_store_type.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';

/// design_spendlens.md §6/§9/§11 — "JSON round-trip" +
/// "schema validation rejecting or migrating missing/old/future
/// schemaVersion". Import "validates the schema and migrates, never
/// blind-overwrites" (spec §61 / `delete_all_records_rules.md`).
void main() {
  BackupBundle sampleBundle() => BackupBundle(
    schemaVersion: BackupJsonCodec.currentSchemaVersion,
    exportedAt: DateTime(2026, 1, 15, 10, 30),
    stores: [
      Store(
        id: 'store-1',
        name: 'Green Hills',
        type: EStoreType.supermarket,
        updatedAt: DateTime(2026, 1, 1),
      ),
    ],
    categories: [
      Category(
        id: 'cat-1',
        name: 'catFood',
        colorHex: '#A78BFA',
        isBuiltIn: true,
        updatedAt: DateTime(2026, 1, 1),
      ),
    ],
    expenses: [
      Expense(
        id: 'exp-1',
        amount: 42.5,
        currencyCode: 'MDL',
        categoryId: 'cat-1',
        storeId: 'store-1',
        occurredAt: DateTime(2026, 1, 10),
        source: EExpenseSource.receipt,
        updatedAt: DateTime(2026, 1, 10),
      ),
    ],
  );

  group('JSON round-trip', () {
    test('encode then decode reproduces every field', () {
      final original = sampleBundle();

      final encoded = BackupJsonCodec.encode(original);
      final decoded = BackupJsonCodec.decode(encoded);

      expect(decoded.schemaVersion, original.schemaVersion);
      expect(decoded.exportedAt, original.exportedAt);
      expect(decoded.stores, original.stores);
      expect(decoded.categories, original.categories);
      expect(decoded.expenses, original.expenses);
      expect(decoded.receipts, isEmpty);
      expect(decoded.receiptItems, isEmpty);
      expect(decoded.products, isEmpty);
      expect(decoded.priceObservations, isEmpty);
    });

    test('round-trip preserves sync-status fields on every entity', () {
      final original = sampleBundle().copyWith(
        expenses: [
          Expense(
            id: 'exp-2',
            amount: 10.0,
            currencyCode: 'MDL',
            categoryId: 'cat-1',
            occurredAt: DateTime(2026, 1, 11),
            updatedAt: DateTime(2026, 1, 11),
            deletedAt: DateTime(2026, 1, 12),
            syncStatus: ESyncStatus.pendingDelete,
          ),
        ],
      );

      final decoded = BackupJsonCodec.decode(BackupJsonCodec.encode(original));

      expect(decoded.expenses.single.deletedAt, DateTime(2026, 1, 12));
      expect(decoded.expenses.single.syncStatus, ESyncStatus.pendingDelete);
    });
  });

  group('schema validation — missing schemaVersion', () {
    test('a payload with no schemaVersion is treated as version 1 and migrated', () {
      const raw = '''
      {
        "exportedAt": "2025-06-01T00:00:00.000",
        "receipts": [],
        "receiptItems": [],
        "products": [],
        "stores": [],
        "categories": [],
        "expenses": [],
        "priceObservations": []
      }
      ''';

      final decoded = BackupJsonCodec.decode(raw);

      expect(decoded.schemaVersion, BackupJsonCodec.currentSchemaVersion);
      expect(decoded.expenses, isEmpty);
    });
  });

  group('schema validation — older schemaVersion', () {
    test('an older schemaVersion is migrated forward, never rejected', () {
      const raw = '''
      {
        "schemaVersion": 1,
        "exportedAt": "2025-01-01T00:00:00.000",
        "receipts": [],
        "receiptItems": [],
        "products": [],
        "stores": [],
        "categories": [],
        "expenses": [],
        "priceObservations": []
      }
      ''';

      final decoded = BackupJsonCodec.decode(raw);

      expect(decoded.schemaVersion, BackupJsonCodec.currentSchemaVersion);
    });

    test('missing entity-list keys default to empty rather than throwing', () {
      const raw = '''
      {
        "schemaVersion": 1,
        "exportedAt": "2025-01-01T00:00:00.000"
      }
      ''';

      final decoded = BackupJsonCodec.decode(raw);

      expect(decoded.receipts, isEmpty);
      expect(decoded.stores, isEmpty);
      expect(decoded.categories, isEmpty);
      expect(decoded.expenses, isEmpty);
    });
  });

  group('schema validation — future schemaVersion is rejected, never guessed at', () {
    test('a newer schemaVersion throws BackupSchemaTooNewException', () {
      final raw =
          '{"schemaVersion": ${BackupJsonCodec.currentSchemaVersion + 1}, '
          '"exportedAt": "2026-01-01T00:00:00.000"}';

      expect(
        () => BackupJsonCodec.decode(raw),
        throwsA(isA<BackupSchemaTooNewException>()),
      );
    });

    test('nothing is imported when the schema is too new', () {
      final raw =
          '{"schemaVersion": ${BackupJsonCodec.currentSchemaVersion + 5}, '
          '"exportedAt": "2026-01-01T00:00:00.000", '
          '"expenses": [{"id":"x"}]}';

      // decode() throws BEFORE BackupBundle.fromJson ever runs — the
      // malformed inner expense (missing required fields) would itself
      // throw if reached, proving the reject happens first.
      expect(
        () => BackupJsonCodec.decode(raw),
        throwsA(isA<BackupSchemaTooNewException>()),
      );
    });
  });

  group('schema validation — malformed payloads', () {
    test('invalid JSON throws BackupMalformedException', () {
      expect(
        () => BackupJsonCodec.decode('not json at all'),
        throwsA(isA<BackupMalformedException>()),
      );
    });

    test('a JSON array root throws BackupMalformedException', () {
      expect(
        () => BackupJsonCodec.decode('[]'),
        throwsA(isA<BackupMalformedException>()),
      );
    });
  });
}
