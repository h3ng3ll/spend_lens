import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/models/e_sync_status.dart';
import 'package:spend_lens/core/services/firebase/e_sync_collection.dart';
import 'package:spend_lens/features/expense/domain/models/expense/e_expense_source.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/sync/domain/adapters/sync_entity_adapter.dart';
import 'package:spend_lens/features/sync/domain/models/remote_record/remote_record.dart';
import 'package:spend_lens/features/sync/domain/repositories/i_sync_remote_repository.dart';
import 'package:spend_lens/features/sync/domain/use_cases/push_pending_changes_use_case.dart';

class _FakeRemote implements ISyncRemoteRepository {
  final List<String> deleted = [];
  final List<Map<String, dynamic>> pushed = [];
  bool throwOnPush = false;

  @override
  Future<void> pushRecords({
    required String uid,
    required ESyncCollection collection,
    required List<Map<String, dynamic>> records,
  }) async {
    if (throwOnPush) throw StateError('network down');
    pushed.addAll(records);
  }

  @override
  Future<List<RemoteRecord>> fetchRecords({
    required String uid,
    required ESyncCollection collection,
    String? sinceUpdatedAt,
  }) async => const [];

  @override
  Future<void> deleteRecords({
    required String uid,
    required ESyncCollection collection,
    required List<String> ids,
  }) async => deleted.addAll(ids);

  @override
  Future<bool> hasAnyRecords({required String uid}) async => false;
}

void main() {
  late _FakeRemote remote;
  late PushPendingChangesUseCase useCase;
  late List<Expense> stored;
  late List<Expense> writtenBack;

  Expense expense(String id, ESyncStatus status) => Expense(
    id: id,
    amount: 1.0,
    currencyCode: 'MDL',
    categoryId: 'catOther',
    occurredAt: DateTime(2026, 9, 1),
    source: EExpenseSource.cash,
    updatedAt: DateTime(2026, 9, 1),
    syncStatus: status,
  );

  SyncEntityAdapter<Expense> adapter() => SyncEntityAdapter<Expense>(
    collection: ESyncCollection.expenses,
    readAllIncludingDeleted: () async => stored,
    readPending: () async => stored
        .where((e) => e.syncStatus != ESyncStatus.synced)
        .toList(),
    writeAllVerbatim: (items) async => writtenBack = items,
    toJson: (e) => e.toJson(),
    fromJson: Expense.fromJson,
    idOf: (e) => e.id,
    updatedAtOf: (e) => e.updatedAt,
    syncStatusOf: (e) => e.syncStatus,
    markSynced: (e) => e.copyWith(syncStatus: ESyncStatus.synced),
    deletedAtOf: (e) => e.deletedAt,
    purgeLocal: (id) async => stored.removeWhere((e) => e.id == id),
    watchAll: () => const Stream<void>.empty(),
  );

  setUp(() {
    remote = _FakeRemote();
    useCase = PushPendingChangesUseCase(remote);
    stored = [];
    writtenBack = [];
  });

  test('pushes only pending rows and marks them synced', () async {
    stored = [
      expense('e1', ESyncStatus.pendingCreate),
      expense('e2', ESyncStatus.synced),
      expense('e3', ESyncStatus.pendingDelete),
    ];

    final count = await useCase(uid: 'u1', adapter: adapter());

    expect(count, 2);
    expect(remote.pushed.map((r) => r['id']).toSet(), {'e1', 'e3'});
    expect(
      writtenBack.every((e) => e.syncStatus == ESyncStatus.synced),
      isTrue,
    );
  });

  test('nothing pending is a no-op, not an empty remote write', () async {
    stored = [expense('e1', ESyncStatus.synced)];
    expect(await useCase(uid: 'u1', adapter: adapter()), 0);
    expect(remote.pushed, isEmpty);
    expect(writtenBack, isEmpty);
  });

  test('a failed push leaves rows pending so the next cycle retries', () async {
    // Crash-safety: local status must never advance ahead of a confirmed
    // commit, or the change is silently lost.
    stored = [expense('e1', ESyncStatus.pendingCreate)];
    remote.throwOnPush = true;

    await expectLater(
      useCase(uid: 'u1', adapter: adapter()),
      throwsA(isA<StateError>()),
    );
    expect(writtenBack, isEmpty);
  });

  group('pushAll (first sync backfill)', () {
    test('uploads rows that predate sync despite being marked synced', () async {
      // The bug this guards: pre-sync rows carry the `synced` default but
      // were never uploaded, so `readPending` cannot see them and they
      // would never leave the device.
      stored = [
        expense('old1', ESyncStatus.synced),
        expense('old2', ESyncStatus.synced),
      ];

      final count = await useCase.pushAll(uid: 'u1', adapter: adapter());

      expect(count, 2);
      expect(remote.pushed.map((r) => r['id']).toSet(), {'old1', 'old2'});
    });

    test('an empty box uploads nothing', () async {
      expect(await useCase.pushAll(uid: 'u1', adapter: adapter()), 0);
      expect(remote.pushed, isEmpty);
    });
  });

  group('purgePublishedDeletions', () {
    // A tombstone tells other devices about a deletion, but nothing ever
    // removed the document afterwards — so Firestore kept the record
    // forever. It was correctly hidden in the app while the console still
    // listed it, and it went on consuming storage for deleted data.
    test('removes the remote document for a published tombstone', () async {
      stored = [
        expense('e1', ESyncStatus.synced).copyWith(
          deletedAt: DateTime(2026, 9, 10),
        ),
      ];

      final purged = await useCase.purgePublishedDeletions(
        uid: 'u1',
        adapter: adapter(),
      );

      expect(purged, 1);
      expect(remote.deleted, ['e1']);
    });

    test('retires the local tombstone once the document is gone', () async {
      stored = [
        expense('e1', ESyncStatus.synced).copyWith(
          deletedAt: DateTime(2026, 9, 10),
        ),
      ];

      await useCase.purgePublishedDeletions(uid: 'u1', adapter: adapter());

      expect(stored, isEmpty);
    });

    test('leaves a tombstone whose deletion has NOT been published',
        () async {
      // Purging now would destroy the only evidence of the deletion, and an
      // offline device would re-upload the record.
      stored = [
        expense('e1', ESyncStatus.pendingDelete).copyWith(
          deletedAt: DateTime(2026, 9, 10),
        ),
      ];

      final purged = await useCase.purgePublishedDeletions(
        uid: 'u1',
        adapter: adapter(),
      );

      expect(purged, 0);
      expect(remote.deleted, isEmpty);
      expect(stored, hasLength(1));
    });

    test('never touches a live row', () async {
      stored = [expense('e1', ESyncStatus.synced)];

      final purged = await useCase.purgePublishedDeletions(
        uid: 'u1',
        adapter: adapter(),
      );

      expect(purged, 0);
      expect(remote.deleted, isEmpty);
      expect(stored, hasLength(1));
    });

    test('nothing to purge is not an error', () async {
      stored = [];

      expect(
        await useCase.purgePublishedDeletions(uid: 'u1', adapter: adapter()),
        0,
      );
    });
  });
}
