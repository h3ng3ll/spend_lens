import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/models/e_sync_status.dart';
import 'package:spend_lens/core/services/firebase/e_sync_collection.dart';
import 'package:spend_lens/features/expense/domain/models/expense/e_expense_source.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/sync/domain/adapters/sync_entity_adapter.dart';
import 'package:spend_lens/features/sync/domain/models/remote_record/remote_record.dart';
import 'package:spend_lens/features/sync/domain/repositories/i_sync_remote_repository.dart';
import 'package:spend_lens/features/sync/domain/use_cases/pull_remote_changes_use_case.dart';

class _FakeRemote implements ISyncRemoteRepository {
  final List<String> deleted = [];
  List<RemoteRecord> toReturn = const [];

  @override
  Future<List<RemoteRecord>> fetchRecords({
    required String uid,
    required ESyncCollection collection,
    String? sinceUpdatedAt,
  }) async => toReturn;

  @override
  Future<void> pushRecords({
    required String uid,
    required ESyncCollection collection,
    required List<Map<String, dynamic>> records,
  }) async {}

  @override
  Future<void> deleteRecords({
    required String uid,
    required ESyncCollection collection,
    required List<String> ids,
  }) async => deleted.addAll(ids);

  @override
  Future<bool> hasAnyRecords({required String uid}) async => false;
}

/// Last-write-wins is where a sync bug silently destroys user data, so each
/// branch of the merge rule gets its own case.
void main() {
  late _FakeRemote remote;
  late PullRemoteChangesUseCase useCase;
  late List<Expense> local;
  late List<Expense> written;

  Expense expense(
    String id, {
    required DateTime updatedAt,
    ESyncStatus syncStatus = ESyncStatus.synced,
    double amount = 1.0,
  }) => Expense(
    id: id,
    amount: amount,
    currencyCode: 'MDL',
    categoryId: 'catOther',
    occurredAt: DateTime(2026, 9, 1),
    source: EExpenseSource.cash,
    updatedAt: updatedAt,
    syncStatus: syncStatus,
  );

  SyncEntityAdapter<Expense> adapter() => SyncEntityAdapter<Expense>(
    collection: ESyncCollection.expenses,
    readAllIncludingDeleted: () async => local,
    readPending: () async => const [],
    writeAllVerbatim: (items) async => written = items,
    toJson: (e) => e.toJson(),
    fromJson: Expense.fromJson,
    idOf: (e) => e.id,
    updatedAtOf: (e) => e.updatedAt,
    syncStatusOf: (e) => e.syncStatus,
    markSynced: (e) => e.copyWith(syncStatus: ESyncStatus.synced),
    deletedAtOf: (e) => e.deletedAt,
    purgeLocal: (id) async => local.removeWhere((e) => e.id == id),
    watchAll: () => const Stream<void>.empty(),
  );

  RemoteRecord record(Expense e) =>
      RemoteRecord(id: e.id, json: e.toJson());

  setUp(() {
    remote = _FakeRemote();
    useCase = PullRemoteChangesUseCase(remote);
    local = [];
    written = [];
  });

  test('a row absent locally is inserted', () async {
    remote.toReturn = [record(expense('e1', updatedAt: DateTime(2026, 9, 2)))];

    final result = await useCase(uid: 'u1', adapter: adapter());

    expect(result.applied, 1);
    expect(written.single.id, 'e1');
  });

  test('a strictly newer remote row overwrites a synced local row', () async {
    local = [expense('e1', updatedAt: DateTime(2026, 9, 1), amount: 1.0)];
    remote.toReturn = [
      record(expense('e1', updatedAt: DateTime(2026, 9, 5), amount: 99.0)),
    ];

    final result = await useCase(uid: 'u1', adapter: adapter());

    expect(result.applied, 1);
    expect(written.single.amount, 99.0);
  });

  test('an older remote row is ignored', () async {
    local = [expense('e1', updatedAt: DateTime(2026, 9, 9), amount: 7.0)];
    remote.toReturn = [
      record(expense('e1', updatedAt: DateTime(2026, 9, 1), amount: 99.0)),
    ];

    final result = await useCase(uid: 'u1', adapter: adapter());

    expect(result.applied, 0);
    expect(written, isEmpty);
  });

  test('an equal timestamp does NOT overwrite — ties lose', () async {
    // Otherwise every re-pull of an unchanged page rewrites the whole box
    // and fires box.watch() for nothing.
    final same = DateTime(2026, 9, 4);
    local = [expense('e1', updatedAt: same, amount: 5.0)];
    remote.toReturn = [record(expense('e1', updatedAt: same, amount: 99.0))];

    expect((await useCase(uid: 'u1', adapter: adapter())).applied, 0);
  });

  test('a locally PENDING row is never overwritten, even by a newer remote', () async {
    // The critical data-loss guard: this row holds an offline edit the
    // server has never seen.
    local = [
      expense(
        'e1',
        updatedAt: DateTime(2026, 9, 1),
        syncStatus: ESyncStatus.pendingUpdate,
        amount: 42.0,
      ),
    ];
    remote.toReturn = [
      record(expense('e1', updatedAt: DateTime(2026, 12, 1), amount: 99.0)),
    ];

    final result = await useCase(uid: 'u1', adapter: adapter());

    expect(result.applied, 0);
    expect(written, isEmpty);
  });

  test('a remote tombstone is applied to a synced local row', () async {
    local = [expense('e1', updatedAt: DateTime(2026, 9, 1))];
    final deleted = expense('e1', updatedAt: DateTime(2026, 9, 5))
        .copyWith(deletedAt: DateTime(2026, 9, 5));
    remote.toReturn = [record(deleted)];

    await useCase(uid: 'u1', adapter: adapter());

    expect(written.single.deletedAt, isNotNull);
  });

  test('the cursor advances to the newest updatedAt seen', () async {
    remote.toReturn = [
      record(expense('e1', updatedAt: DateTime(2026, 9, 2))),
      record(expense('e2', updatedAt: DateTime(2026, 9, 8))),
      record(expense('e3', updatedAt: DateTime(2026, 9, 5))),
    ];

    final result = await useCase(uid: 'u1', adapter: adapter());

    // From the DATA, not DateTime.now() — a wall-clock cursor could skip
    // records written during the pull.
    expect(result.newestUpdatedAt, DateTime(2026, 9, 8).toIso8601String());
  });

  test('a document with no updatedAt is skipped, never guessed at', () async {
    remote.toReturn = [
      RemoteRecord(id: 'e1', json: {
        ...expense('e1', updatedAt: DateTime(2026, 9, 2)).toJson(),
        'updatedAt': null,
      }),
    ];

    final result = await useCase(uid: 'u1', adapter: adapter());

    expect(result.applied, 0);
    expect(result.newestUpdatedAt, isNull);
  });

  test('an empty remote page leaves the cursor untouched', () async {
    final result = await useCase(
      uid: 'u1',
      adapter: adapter(),
      sinceUpdatedAt: '2026-09-01T00:00:00.000',
    );
    expect(result.applied, 0);
    expect(result.newestUpdatedAt, isNull);
  });

  group('cursor safety', () {
    // The cursor is the pull's memory of "everything up to here is handled".
    // `fetchRecords` filters SERVER-side on `updatedAt > sinceUpdatedAt`, and
    // the cursor is persisted in Hive — so a record the cursor passes without
    // being taken is stranded on the server FOREVER. No re-sync, no restart,
    // and no reinstall-free recovery. This group exists because that was a
    // live bug.
    test('does not advance past a record it declined to take', () async {
      local = [
        expense(
          'e1',
          updatedAt: DateTime(2026, 9, 1),
          syncStatus: ESyncStatus.pendingUpdate,
        ),
      ];
      remote.toReturn = [
        record(expense('e1', updatedAt: DateTime(2026, 9, 5))),
      ];

      final result = await useCase(uid: 'u1', adapter: adapter());

      expect(result.applied, 0, reason: 'local pending must win');
      expect(
        result.newestUpdatedAt,
        isNull,
        reason: 'Advancing here would strand e1: the next pull asks for '
            'updatedAt > that value and can never see it again.',
      );
    });

    test('a skipped record does not drag the cursor past its NEIGHBOURS',
        () async {
      // The damaging shape: one pending row in a page would otherwise push
      // the cursor to the newest id in that page, stranding everything older
      // that had not been fetched yet.
      local = [
        expense(
          'e2',
          updatedAt: DateTime(2026, 9, 1),
          syncStatus: ESyncStatus.pendingUpdate,
        ),
      ];
      remote.toReturn = [
        record(expense('e1', updatedAt: DateTime(2026, 9, 3))),
        record(expense('e2', updatedAt: DateTime(2026, 9, 9))),
      ];

      final result = await useCase(uid: 'u1', adapter: adapter());

      expect(result.applied, 1);
      expect(
        result.newestUpdatedAt,
        DateTime(2026, 9, 3).toIso8601String(),
        reason: 'e2 was skipped, so the cursor must stop at e1 — not jump '
            'to e2 and lose it.',
      );
    });

    test('advances for a record already held at an equal-or-newer version',
        () async {
      // Safe: we hold an equal-or-newer copy, so there is nothing to come
      // back for and the cursor SHOULD move (otherwise it never progresses).
      local = [expense('e1', updatedAt: DateTime(2026, 9, 5))];
      remote.toReturn = [
        record(expense('e1', updatedAt: DateTime(2026, 9, 5))),
      ];

      final result = await useCase(uid: 'u1', adapter: adapter());

      expect(result.applied, 0);
      expect(
        result.newestUpdatedAt,
        DateTime(2026, 9, 5).toIso8601String(),
      );
    });

    test('advances for records it takes', () async {
      remote.toReturn = [
        record(expense('e1', updatedAt: DateTime(2026, 9, 2))),
        record(expense('e2', updatedAt: DateTime(2026, 9, 4))),
      ];

      final result = await useCase(uid: 'u1', adapter: adapter());

      expect(result.applied, 2);
      expect(
        result.newestUpdatedAt,
        DateTime(2026, 9, 4).toIso8601String(),
      );
    });
  });
}
