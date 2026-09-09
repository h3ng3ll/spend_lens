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
