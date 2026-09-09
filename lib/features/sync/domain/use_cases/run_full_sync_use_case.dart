import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/utils/sync_error_classifier.dart';
import '../../../settings/domain/repositories/i_settings_local_repository.dart';
import '../adapters/sync_entity_adapters.dart';
import '../repositories/i_sync_remote_repository.dart';
import 'pull_remote_changes_use_case.dart';
import 'push_pending_changes_use_case.dart';

/// What one sync cycle accomplished.
class SyncReport {
  final int pushed;
  final int pulled;

  const SyncReport({required this.pushed, required this.pulled});

  bool get didAnything => pushed > 0 || pulled > 0;
}

/// One sync cycle: push local changes, then pull remote ones.
///
/// Push first, deliberately. Pulling first would let a remote row win
/// last-write-wins against a local edit that has not been published yet —
/// and although the pull explicitly refuses to overwrite a pending row, the
/// ordering means the server sees this device's work before we ask what
/// changed, so the two devices converge in one cycle instead of two.
class RunFullSyncUseCase {
  final ISyncRemoteRepository _remoteRepository;
  final PushPendingChangesUseCase _pushPendingChanges;
  final PullRemoteChangesUseCase _pullRemoteChanges;
  final SyncEntityAdapters _adapters;
  final ISettingsLocalRepository _settingsLocalRepository;

  const RunFullSyncUseCase({
    required ISyncRemoteRepository remoteRepository,
    required PushPendingChangesUseCase pushPendingChanges,
    required PullRemoteChangesUseCase pullRemoteChanges,
    required SyncEntityAdapters adapters,
    required ISettingsLocalRepository settingsLocalRepository,
  }) : this._(
         remoteRepository,
         pushPendingChanges,
         pullRemoteChanges,
         adapters,
         settingsLocalRepository,
       );

  const RunFullSyncUseCase._(
    this._remoteRepository,
    this._pushPendingChanges,
    this._pullRemoteChanges,
    this._adapters,
    this._settingsLocalRepository,
  );

  /// Runs a cycle for [uid].
  ///
  /// Returns `Left` on failure — the project's side order, Left = failure.
  /// The failure is CLASSIFIED (offline vs permission vs unexpected) so the
  /// UI can distinguish a benign, self-healing offline state from something
  /// actually broken.
  Future<Either<Failure, SyncReport>> call({required String uid}) async {
    try {
      final settings = await _settingsLocalRepository.get();
      final adapters = _adapters.all();

      // FIRST-SYNC BACKFILL. Rows created before sync existed default to
      // `synced` but were never uploaded, so nothing would ever push them.
      // When the account is genuinely empty, re-mark everything local as
      // pendingCreate once. Gated on the remote being empty, not on the
      // cursor alone: a reinstall has a null cursor but a populated account,
      // and re-uploading there would be pointless traffic.
      final isFirstSync =
          settings.lastSyncedAt == null &&
          !await _remoteRepository.hasAnyRecords(uid: uid);

      var pushed = 0;
      for (final adapter in adapters) {
        if (isFirstSync) {
          // Rows that predate sync are marked `synced` but were never
          // uploaded, so `readPending` cannot see them and they would stay
          // on this device forever. On a first sync into an empty account,
          // upload EVERY local row (tombstones included) once.
          pushed += await _pushPendingChanges.pushAll(
            uid: uid,
            adapter: adapter,
          );
        } else {
          pushed += await _pushPendingChanges(uid: uid, adapter: adapter);
        }
      }

      var pulled = 0;
      var cursor = settings.lastSyncedAt;
      for (final adapter in adapters) {
        final result = await _pullRemoteChanges(
          uid: uid,
          adapter: adapter,
          sinceUpdatedAt: cursor,
        );
        pulled += result.applied;

        // One cursor for all collections: keep the OLDEST high-water mark so
        // a collection that lagged behind is not skipped on the next cycle.
        final newest = result.newestUpdatedAt;
        if (newest != null &&
            (cursor == null || newest.compareTo(cursor) > 0)) {
          cursor = newest;
        }
      }

      if (cursor != null && cursor != settings.lastSyncedAt) {
        final latest = await _settingsLocalRepository.get();
        await _settingsLocalRepository.save(
          latest.copyWith(lastSyncedAt: cursor),
        );
      }

      return Right(SyncReport(pushed: pushed, pulled: pulled));
    } catch (error) {
      return Left(classifySyncError(error));
    }
  }
}
