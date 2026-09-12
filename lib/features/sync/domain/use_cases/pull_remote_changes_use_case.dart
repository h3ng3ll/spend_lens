import '../../../../core/models/e_sync_status.dart';
import '../adapters/sync_entity_adapter.dart';
import '../repositories/i_sync_remote_repository.dart';

/// The outcome of one collection's pull.
class PullResult {
  final int applied;

  /// The newest `updatedAt` seen, for the next cursor. Null when the pull
  /// returned nothing.
  final String? newestUpdatedAt;

  const PullResult({required this.applied, this.newestUpdatedAt});
}

/// Downloads remote changes and merges them into the local box.
///
/// Conflict rule — last-write-wins on `updatedAt`, with one exception:
///
/// * local row absent            -> take remote
/// * local `synced`              -> take remote only if strictly newer
/// * local PENDING (any state)   -> keep local, always
///
/// The pending exception is what stops sync from eating an offline edit: such
/// a row has changes the server has never seen, so overwriting it would
/// discard them silently. It keeps its pending status and the next push
/// publishes it, where its later `updatedAt` wins globally.
///
/// Ties lose. `isAfter` is strict, so re-pulling an unchanged page rewrites
/// nothing.
///
/// **The cursor only advances past records this pull actually accounted
/// for.** It used to advance for EVERY fetched record, before the conflict
/// rules ran — so a record skipped because the local row looked pending
/// still moved `lastSyncedAt` past itself. Since `fetchRecords` filters
/// server-side on `updatedAt > sinceUpdatedAt`, that record could then never
/// be fetched again: it was stranded on the server permanently, invisible to
/// this device, and no amount of re-syncing or restarting would bring it
/// back (the cursor is persisted in Hive, so a restart does not reset it).
///
/// That was reachable in normal use, and the `syncStatus`-on-the-wire bug
/// made it common: pulled rows landed falsely pending, so the very next pull
/// skipped them while still stepping the cursor forward.
class PullRemoteChangesUseCase {
  final ISyncRemoteRepository _remoteRepository;

  const PullRemoteChangesUseCase(this._remoteRepository);

  Future<PullResult> call<T>({
    required String uid,
    required SyncEntityAdapter<T> adapter,
    String? sinceUpdatedAt,
  }) async {
    final remote = await _remoteRepository.fetchRecords(
      uid: uid,
      collection: adapter.collection,
      sinceUpdatedAt: sinceUpdatedAt,
    );
    if (remote.isEmpty) {
      return const PullResult(applied: 0);
    }

    final localById = {
      for (final entity in await adapter.readAllIncludingDeleted())
        adapter.idOf(entity): entity,
    };

    final winners = <T>[];
    String? newest = sinceUpdatedAt;

    for (final record in remote) {
      final raw = record.updatedAtRaw;
      // A document with no parseable `updatedAt` cannot be ordered against
      // anything, so it is skipped rather than guessed at — see
      // RemoteRecord.updatedAt on why a `now()` fallback is poison.
      final remoteUpdatedAt = record.updatedAt;
      if (raw == null || remoteUpdatedAt == null) continue;

      final local = localById[record.id];
      if (local != null) {
        // Local has unpublished work — keep it, and do NOT advance the
        // cursor past this record. See the cursor note above: moving past a
        // record this device declined to take strands it permanently.
        if (adapter.syncStatusOf(local) != ESyncStatus.synced) continue;
        // Not newer than what we hold. Safe to advance: we already have an
        // equal-or-newer copy, so there is nothing here to come back for.
        if (!remoteUpdatedAt.isAfter(adapter.updatedAtOf(local))) {
          if (newest == null || raw.compareTo(newest) > 0) newest = raw;
          continue;
        }
      }

      // Advanced only for records actually TAKEN (or already held), never
      // for one that was skipped with work still owed.
      if (newest == null || raw.compareTo(newest) > 0) newest = raw;

      winners.add(adapter.fromJson(record.json));
    }

    if (winners.isNotEmpty) {
      await adapter.writeAllVerbatim(winners);
    }

    return PullResult(applied: winners.length, newestUpdatedAt: newest);
  }
}
