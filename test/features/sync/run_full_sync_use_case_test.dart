import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/models/e_sync_status.dart';
import 'package:spend_lens/core/services/firebase/e_sync_collection.dart';
import 'package:spend_lens/core/services/logger_service.dart';
import 'package:spend_lens/features/expense/domain/models/expense/e_expense_source.dart';
import 'package:spend_lens/core/services/firebase/firebase_storage_service.dart';
import 'package:spend_lens/core/services/receipt_image_store/receipt_image_store.dart';
import 'package:spend_lens/core/services/store_logo_image_store/store_logo_image_store.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_local_repository.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/store/domain/repositories/i_store_local_repository.dart';
import 'package:spend_lens/features/sync/domain/use_cases/download_receipt_photos_use_case.dart';
import 'package:spend_lens/features/sync/domain/use_cases/download_store_logos_use_case.dart';
import 'package:spend_lens/features/sync/domain/use_cases/upload_receipt_photos_use_case.dart';
import 'package:spend_lens/features/settings/domain/models/app_settings/app_settings.dart';
import 'package:spend_lens/features/settings/domain/repositories/i_settings_local_repository.dart';
import 'package:spend_lens/features/sync/domain/adapters/sync_entity_adapter.dart';
import 'package:spend_lens/features/sync/domain/adapters/sync_entity_adapters.dart';
import 'package:spend_lens/features/sync/domain/models/remote_record/remote_record.dart';
import 'package:spend_lens/features/sync/domain/repositories/i_sync_remote_repository.dart';
import 'package:spend_lens/features/sync/domain/use_cases/pull_remote_changes_use_case.dart';
import 'package:spend_lens/features/sync/domain/use_cases/push_pending_changes_use_case.dart';
import 'package:spend_lens/features/sync/domain/use_cases/run_full_sync_use_case.dart';

/// The cycle orchestrator. Both cases here are REGRESSIONS that shipped and
/// were reproduced on a device: a record sat in Firestore that the app could
/// never retrieve, and sign-out left data on the device because nothing was
/// ever provably uploaded.
void main() {
  late _FakeRemote remote;
  late _FakeSettings settings;
  late List<Expense> local;

  final epoch = DateTime(2026, 9, 12, 12, 28, 12);

  Expense expense(
    String id, {
    required DateTime updatedAt,
    ESyncStatus syncStatus = ESyncStatus.synced,
  }) => Expense(
    id: id,
    amount: 1.0,
    currencyCode: 'MDL',
    categoryId: 'catOther',
    occurredAt: epoch,
    source: EExpenseSource.cash,
    updatedAt: updatedAt,
    syncStatus: syncStatus,
  );

  SyncEntityAdapter<Object> adapter({
    ESyncCollection collection = ESyncCollection.expenses,
    List<Expense>? backing,
  }) => SyncEntityAdapter<Object>(
    collection: collection,
    readAllIncludingDeleted: () async => (backing ?? local).cast<Object>(),
    readPending: () async => (backing ?? local)
        .where((e) => e.syncStatus != ESyncStatus.synced)
        .toList()
        .cast<Object>(),
    writeAllVerbatim: (items) async {
      final target = backing ?? local;
      for (final item in items.cast<Expense>()) {
        target.removeWhere((e) => e.id == item.id);
        target.add(item);
      }
    },
    toJson: (e) => (e as Expense).toJson(),
    fromJson: Expense.fromJson,
    idOf: (e) => (e as Expense).id,
    updatedAtOf: (e) => (e as Expense).updatedAt,
    syncStatusOf: (e) => (e as Expense).syncStatus,
    markSynced: (e) =>
        (e as Expense).copyWith(syncStatus: ESyncStatus.synced),
    deletedAtOf: (e) => (e as Expense).deletedAt,
    purgeLocal: (id) async => local.removeWhere((e) => e.id == id),
    watchAll: () => const Stream<void>.empty(),
  );

  RunFullSyncUseCase buildUseCase() => RunFullSyncUseCase(
    remoteRepository: remote,
    pushPendingChanges: PushPendingChangesUseCase(remote),
    pullRemoteChanges: PullRemoteChangesUseCase(remote),
    // Real instances over an EMPTY receipt repository: both short-circuit
    // on `getAll()` returning nothing, so no Firebase touch is possible.
    uploadReceiptPhotos: UploadReceiptPhotosUseCase(
      receiptLocalRepository: _EmptyReceipts(),
      imageStore: ReceiptImageStore(),
      storageService: _UnusedStorage(),
    ),
    downloadReceiptPhotos: DownloadReceiptPhotosUseCase(
      receiptLocalRepository: _EmptyReceipts(),
      imageStore: ReceiptImageStore(),
      storageService: _UnusedStorage(),
    ),
    downloadStoreLogos: DownloadStoreLogosUseCase(
      storeLocalRepository: _EmptyStores(),
      imageStore: StoreLogoImageStore(),
      storageService: _UnusedStorage(),
    ),
    adapters: _FakeAdapters([adapter()]),
    settingsLocalRepository: settings,
    loggerService: LoggerService(),
  );

  setUp(() {
    remote = _FakeRemote();
    settings = _FakeSettings();
    local = [];
  });

  group('legacy recovery (a document with no updatedAt)', () {
    // Firestore EXCLUDES such a document from `where('updatedAt' > cursor)`
    // — silently, as an empty result. So once a cursor was stored, an
    // incremental pull could never retrieve it and the record was stranded
    // on the server forever, invisible to every device, while the cycle
    // still reported success.
    setUp(() {
      remote.byCollection[ESyncCollection.expenses] = [
        RemoteRecord(
          id: 'legacy1',
          json: {
            ...expense('legacy1', updatedAt: epoch).toJson(),
            'updatedAt': null,
          },
        ),
      ];
    });

    test('a stored cursor no longer hides it — it is pulled anyway', () async {
      settings.current = const AppSettings(
        lastSyncedAt: '2026-09-12T12:28:12.000',
      );

      final result = await buildUseCase()(uid: 'u1');

      expect(result.isRight(), isTrue);
      expect(local.map((e) => e.id), contains('legacy1'));
      // The unfiltered sweep must have been used, not the cursor filter.
      expect(remote.lastSince, isNull);
    });

    test('runs once, then stays filtered on later cycles', () async {
      settings.current = const AppSettings(
        lastSyncedAt: '2026-09-12T12:28:12.000',
      );

      await buildUseCase()(uid: 'u1');
      expect(settings.current.legacyPullCompleted, isTrue);

      // Second cycle: the sweep is done, so the cursor applies again —
      // otherwise every cycle would re-read every collection whole.
      await buildUseCase()(uid: 'u1');
      expect(remote.lastSince, '2026-09-12T12:28:12.000');
    });

    test('the flag is set even when the sweep finds nothing', () async {
      remote.byCollection[ESyncCollection.expenses] = [];
      settings.current = const AppSettings(lastSyncedAt: '2026-09-12T00:00:00.000');

      await buildUseCase()(uid: 'u1');

      // An empty account has no legacy rows; leaving it false would re-read
      // everything forever.
      expect(settings.current.legacyPullCompleted, isTrue);
    });
  });

  group('the shared cursor across collections', () {
    // THE REGRESSION. The cursor took the MAXIMUM mark across all seven
    // collections, so one collection that had just been written (freshly
    // re-seeded categories) dragged it forward past every OTHER
    // collection's older records. Those records stayed in Firestore,
    // permanently excluded by `updatedAt >`, while the app showed an empty
    // list and reported `upToDate`.
    test('settles on the OLDEST mark, never the newest', () async {
      final categories = <Expense>[];
      final expenses = <Expense>[];

      remote.byCollection[ESyncCollection.categories] = [
        RemoteRecord(
          id: 'c1',
          json: expense('c1', updatedAt: DateTime(2026, 9, 12, 13, 19)).toJson(),
        ),
      ];
      remote.byCollection[ESyncCollection.expenses] = [
        RemoteRecord(
          id: 'e1',
          json: expense('e1', updatedAt: DateTime(2026, 9, 12, 12, 54)).toJson(),
        ),
      ];
      settings.current = const AppSettings(legacyPullCompleted: true);

      final useCase = RunFullSyncUseCase(
        remoteRepository: remote,
        pushPendingChanges: PushPendingChangesUseCase(remote),
        pullRemoteChanges: PullRemoteChangesUseCase(remote),
        uploadReceiptPhotos: UploadReceiptPhotosUseCase(
          receiptLocalRepository: _EmptyReceipts(),
          imageStore: ReceiptImageStore(),
          storageService: _UnusedStorage(),
        ),
        downloadReceiptPhotos: DownloadReceiptPhotosUseCase(
          receiptLocalRepository: _EmptyReceipts(),
          imageStore: ReceiptImageStore(),
          storageService: _UnusedStorage(),
        ),
        downloadStoreLogos: DownloadStoreLogosUseCase(
          storeLocalRepository: _EmptyStores(),
          imageStore: StoreLogoImageStore(),
          storageService: _UnusedStorage(),
        ),
        adapters: _FakeAdapters([
          adapter(
            collection: ESyncCollection.categories,
            backing: categories,
          ),
          adapter(collection: ESyncCollection.expenses, backing: expenses),
        ]),
        settingsLocalRepository: settings,
        loggerService: LoggerService(),
      );

      await useCase(uid: 'u1');

      // 12:54, not 13:19 — otherwise the expenses collection is stranded.
      expect(
        settings.current.lastSyncedAt,
        DateTime(2026, 9, 12, 12, 54).toIso8601String(),
      );
    });
  });

  group('a collection this device holds nothing of', () {
    test('ignores the cursor, so stranded records come back', () async {
      // The state the max-cursor bug left behind: a populated account, a
      // cursor ahead of the records, and nothing local to justify it.
      settings.current = const AppSettings(
        lastSyncedAt: '2026-09-12T13:19:02.251529',
        legacyPullCompleted: true,
      );
      remote.byCollection[ESyncCollection.expenses] = [
        RemoteRecord(
          id: 'e1',
          json: expense('e1', updatedAt: DateTime(2026, 9, 12, 12, 54)).toJson(),
        ),
      ];

      await buildUseCase()(uid: 'u1');

      expect(remote.lastSince, isNull, reason: 'must ask unfiltered');
      expect(local.map((e) => e.id), contains('e1'));
    });

    test('a collection WITH local rows still uses the cursor', () async {
      local = [expense('kept', updatedAt: DateTime(2026, 9, 12, 14))];
      settings.current = const AppSettings(
        lastSyncedAt: '2026-09-12T13:19:02.251529',
        legacyPullCompleted: true,
      );
      remote.byCollection[ESyncCollection.expenses] = [
        RemoteRecord(
          id: 'e1',
          json: expense('e1', updatedAt: DateTime(2026, 9, 12, 15)).toJson(),
        ),
      ];

      await buildUseCase()(uid: 'u1');

      expect(remote.lastSince, '2026-09-12T13:19:02.251529');
    });
  });

  group('first-sync backfill', () {
    test('uploads never-published rows even when a cursor exists', () async {
      // The regression: `isFirstSync` also required `lastSyncedAt == null`,
      // so once any cursor was stored the backfill could never run again. A
      // local row marked `synced` that had never actually been uploaded then
      // stayed invisible to `readPending` forever — and the sign-out cleanup
      // correctly refused to delete it, so data remained on the device.
      local = [expense('e1', updatedAt: epoch)];
      settings.current = const AppSettings(
        lastSyncedAt: '2026-09-12T12:28:12.000',
        legacyPullCompleted: true,
      );

      final result = await buildUseCase()(uid: 'u1');

      expect(result.isRight(), isTrue);
      expect(remote.pushed.map((r) => r['id']), contains('e1'));
      expect(local.single.syncStatus, ESyncStatus.synced);
    });

    test('does NOT re-upload everything when the account has records', () async {
      local = [expense('e1', updatedAt: epoch)];
      remote.byCollection[ESyncCollection.expenses] = [
        RemoteRecord(id: 'other', json: expense('other', updatedAt: epoch).toJson()),
      ];
      settings.current = const AppSettings(legacyPullCompleted: true);

      await buildUseCase()(uid: 'u1');

      // A populated account means this device is joining, not seeding.
      expect(remote.pushed, isEmpty);
    });
  });
}

class _FakeRemote implements ISyncRemoteRepository {
  final Map<ESyncCollection, List<RemoteRecord>> byCollection = {};
  final List<Map<String, dynamic>> pushed = [];
  String? lastSince;

  @override
  Future<List<RemoteRecord>> fetchRecords({
    required String uid,
    required ESyncCollection collection,
    String? sinceUpdatedAt,
  }) async {
    lastSince = sinceUpdatedAt;
    final all = byCollection[collection] ?? const [];
    if (sinceUpdatedAt == null || sinceUpdatedAt.isEmpty) return all;
    // Mirrors Firestore: a document without the field is EXCLUDED by an
    // inequality filter on it, rather than treated as older.
    return all.where((r) {
      final raw = r.updatedAtRaw;
      return raw != null && raw.compareTo(sinceUpdatedAt) > 0;
    }).toList();
  }

  @override
  Future<void> pushRecords({
    required String uid,
    required ESyncCollection collection,
    required List<Map<String, dynamic>> records,
  }) async => pushed.addAll(records);

  @override
  Future<void> deleteRecords({
    required String uid,
    required ESyncCollection collection,
    required List<String> ids,
  }) async {}

  @override
  Future<bool> hasAnyRecords({required String uid}) async =>
      byCollection.values.any((v) => v.isNotEmpty);
}

class _FakeSettings implements ISettingsLocalRepository {
  AppSettings current = const AppSettings();

  @override
  Future<AppSettings> get() async => current;

  @override
  Stream<AppSettings> watch() => Stream.value(current);

  @override
  Future<void> save(AppSettings settings) async => current = settings;
}

/// Narrows the cycle to ONE collection, so each case reasons about a single
/// adapter rather than all seven.
class _FakeAdapters implements SyncEntityAdapters {
  final List<SyncEntityAdapter<Object>> _adapters;

  _FakeAdapters(this._adapters);

  @override
  List<SyncEntityAdapter<Object>> all() => _adapters;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// No receipts, so the photo passes short-circuit before any Firebase call.
class _EmptyReceipts implements IReceiptLocalRepository {
  @override
  Future<List<Receipt>> getAll() async => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Empty, for the same reason as [_EmptyReceipts]: `DownloadStoreLogosUseCase`
/// short-circuits on `getAll()` returning nothing, so no Firebase touch is
/// possible from these cases.
class _EmptyStores implements IStoreLocalRepository {
  @override
  Future<List<Store>> getAll() async => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedStorage implements FirebaseStorageService {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
