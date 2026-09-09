import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

import 'package:spend_lens/core/hive/enum_adapters.dart';
import 'package:spend_lens/core/hive/hive_database.dart';
import 'package:spend_lens/core/hive/hive_registrar.g.dart';
import 'package:spend_lens/core/models/e_sync_status.dart';
import 'package:spend_lens/features/expense/data/repositories/expense_local_repository.dart';
import 'package:spend_lens/features/expense/domain/models/expense/e_expense_source.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';

/// The soft-delete + pending-marking contract the sync engine depends on.
///
/// Runs against a real Hive box in a temp directory rather than a fake: the
/// behaviour under test IS the box interaction (tombstone filtering on read,
/// `putAll` marking, `box.watch()` re-emission), which a hand-written fake
/// would simply restate rather than verify.
void main() {
  late Directory tempDir;
  late ExpenseLocalRepository repository;

  Expense expense(String id, {DateTime? deletedAt}) => Expense(
    id: id,
    amount: 10.0,
    currencyCode: 'MDL',
    categoryId: 'catOther',
    occurredAt: DateTime(2026, 9, 1),
    source: EExpenseSource.cash,
    updatedAt: DateTime(2026, 9, 1),
    deletedAt: deletedAt,
  );

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('spend_lens_soft_delete');
    Hive.init(tempDir.path);
    // `registerAdapters()` covers the GENERATED model adapters only; the
    // hand-written enum adapters are registered explicitly, mirroring
    // `initHive()` in hive_initializer.dart.
    Hive.registerAdapters();
    Hive.registerAdapter(ESyncStatusAdapter());
    Hive.registerAdapter(EExpenseSourceAdapter());
  });

  tearDownAll(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  setUp(() async {
    await Hive.deleteBoxFromDisk('expenses');
    repository = const ExpenseLocalRepository(HiveDatabase());
  });

  group('save', () {
    test('a first write is marked pendingCreate, an edit pendingUpdate', () async {
      await repository.save(expense('e1'));
      final created = (await repository.getAll()).single;
      expect(created.syncStatus, ESyncStatus.pendingCreate);

      await repository.save(created);
      final updated = (await repository.getAll()).single;
      expect(updated.syncStatus, ESyncStatus.pendingUpdate);
    });

    test('markPending: false stores the row verbatim', () async {
      // The pull pass writes server rows through this path. Marking them
      // pending would push them straight back — an echo loop.
      await repository.save(expense('e1'), markPending: false);
      expect((await repository.getAll()).single.syncStatus, ESyncStatus.synced);
    });
  });

  group('delete', () {
    test('tombstones instead of dropping, and hides the row from reads', () async {
      await repository.save(expense('e1'));
      await repository.delete('e1');

      expect(await repository.getAll(), isEmpty);
      expect(await repository.getById('e1'), isNull);

      // The row must still EXIST, carrying the tombstone — otherwise the
      // deletion could never propagate and the next pull would restore it.
      final all = await repository.getAllIncludingDeleted();
      expect(all.single.deletedAt, isNotNull);
      expect(all.single.syncStatus, ESyncStatus.pendingDelete);
    });

    test('deleting an absent id is a no-op, not a resurrected tombstone', () async {
      await repository.delete('nope');
      expect(await repository.getAllIncludingDeleted(), isEmpty);
    });

    test('watchAll hides tombstoned rows', () async {
      await repository.save(expense('e1'));
      await repository.delete('e1');
      expect(await repository.watchAll().first, isEmpty);
    });
  });

  group('getPending', () {
    test('returns only rows awaiting sync, tombstones included', () async {
      await repository.save(expense('e1'));
      await repository.save(expense('e2'), markPending: false);
      await repository.save(expense('e3'));
      await repository.delete('e3');

      final pending = await repository.getPending();
      expect(pending.map((e) => e.id).toSet(), {'e1', 'e3'});
    });
  });

  group('saveAll', () {
    test('lands a page of server rows without marking them pending', () async {
      await repository.saveAll(
        [expense('e1'), expense('e2')],
        markPending: false,
      );
      final all = await repository.getAll();
      expect(all, hasLength(2));
      expect(all.every((e) => e.syncStatus == ESyncStatus.synced), isTrue);
    });
  });
}
