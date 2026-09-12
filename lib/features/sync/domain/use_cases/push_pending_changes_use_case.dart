import '../../../../core/models/e_sync_status.dart';
import '../adapters/sync_entity_adapter.dart';
import '../repositories/i_sync_remote_repository.dart';

/// Uploads every locally-pending row, then marks it synced.
///
/// Ordering is load-bearing: local status advances ONLY after the remote
/// commit returns. If the commit throws, the rows stay pending and the next
/// cycle retries them — so a crash or a dropped connection mid-push can lose
/// an upload but never lose the knowledge that one is owed.
class PushPendingChangesUseCase {
  final ISyncRemoteRepository _remoteRepository;

  const PushPendingChangesUseCase(this._remoteRepository);

  /// Returns how many rows were pushed for this adapter.
  Future<int> call<T>({
    required String uid,
    required SyncEntityAdapter<T> adapter,
  }) async {
    final pending = await adapter.readPending();
    if (pending.isEmpty) return 0;

    await _remoteRepository.pushRecords(
      uid: uid,
      collection: adapter.collection,
      records: pending.map(adapter.toJson).toList(),
    );

    // Verbatim, so the write-back cannot re-mark these rows pending and
    // strand them in a loop that uploads the same page forever.
    await adapter.writeAllVerbatim(
      pending.map(adapter.markSynced).toList(),
    );

    return pending.length;
  }

  /// Removes remote documents for deletions that have already been
  /// published, and retires the local tombstones behind them.
  ///
  /// **Why a tombstone is not the end of the story.** Deleting a record
  /// soft-deletes it: the row keeps `deletedAt` and is pushed so other
  /// devices learn about the deletion. But nothing ever removed the
  /// document afterwards, so Firestore kept it forever — the record was
  /// correctly hidden in the app while the console still listed it, and it
  /// went on consuming the user's storage for data they had deleted.
  ///
  /// **Why it is safe to purge now.** This runs on the cycle AFTER the
  /// tombstone was pushed — it only considers rows already marked `synced`,
  /// which means their `deletedAt` has reached the server and any other
  /// device has had a chance to pull it. Purging before that would remove
  /// the only evidence of the deletion and let an offline device re-upload
  /// the record.
  ///
  /// Returns how many documents were purged.
  Future<int> purgePublishedDeletions<T>({
    required String uid,
    required SyncEntityAdapter<T> adapter,
  }) async {
    final all = await adapter.readAllIncludingDeleted();

    final ids = <String>[
      for (final entity in all)
        if (adapter.deletedAtOf(entity) != null &&
            adapter.syncStatusOf(entity) == ESyncStatus.synced)
          adapter.idOf(entity),
    ];
    if (ids.isEmpty) return 0;

    await _remoteRepository.deleteRecords(
      uid: uid,
      collection: adapter.collection,
      ids: ids,
    );

    // Only after the remote document is gone. If the delete above throws,
    // the tombstone stays and the next cycle retries — never a local row
    // dropped while its document survives.
    for (final id in ids) {
      await adapter.purgeLocal(id);
    }

    return ids.length;
  }

  /// Uploads EVERY local row, regardless of `syncStatus`.
  ///
  /// Only for a first sync into an empty account. Rows created before sync
  /// existed carry the `synced` default despite never having been uploaded,
  /// so [call] cannot see them — without this they would never leave the
  /// device. Not used on any later cycle: re-uploading everything each time
  /// would defeat the point of tracking pending state.
  Future<int> pushAll<T>({
    required String uid,
    required SyncEntityAdapter<T> adapter,
  }) async {
    final all = await adapter.readAllIncludingDeleted();
    if (all.isEmpty) return 0;

    await _remoteRepository.pushRecords(
      uid: uid,
      collection: adapter.collection,
      records: all.map(adapter.toJson).toList(),
    );

    await adapter.writeAllVerbatim(all.map(adapter.markSynced).toList());
    return all.length;
  }
}
