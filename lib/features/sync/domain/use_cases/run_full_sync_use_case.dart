import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/utils/sync_error_classifier.dart';
import '../../../settings/domain/repositories/i_settings_local_repository.dart';
import '../adapters/sync_entity_adapters.dart';
import '../repositories/i_sync_remote_repository.dart';
import 'pull_remote_changes_use_case.dart';
import 'push_pending_changes_use_case.dart';
import 'download_receipt_photos_use_case.dart';
import 'download_store_logos_use_case.dart';
import 'upload_receipt_photos_use_case.dart';

/// What one sync cycle accomplished.
class SyncReport {
  final int pushed;
  final int pulled;

  /// Receipt photos uploaded to cloud storage this cycle.
  final int photosUploaded;

  /// Receipt photos restored FROM cloud storage this cycle — a device that
  /// lost its files (reinstall, restore, the sign-out cleanup) getting them
  /// back.
  final int photosDownloaded;

  /// Store logos restored FROM cloud storage this cycle. Counted separately
  /// from [photosDownloaded] so the log line stays diagnosable: the two pass
  /// over different collections and fail for different reasons.
  final int logosDownloaded;

  /// Remote documents removed because their deletion had been published.
  final int purged;

  const SyncReport({
    required this.pushed,
    required this.pulled,
    this.photosUploaded = 0,
    this.photosDownloaded = 0,
    this.logosDownloaded = 0,
    this.purged = 0,
  });

  bool get didAnything =>
      pushed > 0 ||
      pulled > 0 ||
      photosUploaded > 0 ||
      photosDownloaded > 0 ||
      logosDownloaded > 0 ||
      purged > 0;
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
  final UploadReceiptPhotosUseCase _uploadReceiptPhotos;
  final DownloadReceiptPhotosUseCase _downloadReceiptPhotos;
  final DownloadStoreLogosUseCase _downloadStoreLogos;
  final SyncEntityAdapters _adapters;
  final ISettingsLocalRepository _settingsLocalRepository;
  final LoggerService _loggerService;

  const RunFullSyncUseCase({
    required ISyncRemoteRepository remoteRepository,
    required PushPendingChangesUseCase pushPendingChanges,
    required PullRemoteChangesUseCase pullRemoteChanges,
    required UploadReceiptPhotosUseCase uploadReceiptPhotos,
    required DownloadReceiptPhotosUseCase downloadReceiptPhotos,
    required DownloadStoreLogosUseCase downloadStoreLogos,
    required SyncEntityAdapters adapters,
    required ISettingsLocalRepository settingsLocalRepository,
    required LoggerService loggerService,
  }) : this._(
         remoteRepository,
         pushPendingChanges,
         pullRemoteChanges,
         uploadReceiptPhotos,
         downloadReceiptPhotos,
         downloadStoreLogos,
         adapters,
         settingsLocalRepository,
         loggerService,
       );

  const RunFullSyncUseCase._(
    this._remoteRepository,
    this._pushPendingChanges,
    this._pullRemoteChanges,
    this._uploadReceiptPhotos,
    this._downloadReceiptPhotos,
    this._downloadStoreLogos,
    this._adapters,
    this._settingsLocalRepository,
    this._loggerService,
  );

  /// Runs a cycle for [uid].
  ///
  /// Returns `Left` on failure — the project's side order, Left = failure.
  /// The failure is CLASSIFIED (offline vs permission vs unexpected) so the
  /// UI can distinguish a benign, self-healing offline state from something
  /// actually broken.
  /// [fullResync] ignores the stored cursor and pulls EVERY remote record.
  ///
  /// The manual "Synchronize now" action passes true. An incremental pull
  /// asks only for records newer than `lastSyncedAt`, which is the right
  /// default for automatic cycles but useless as a repair: if a record was
  /// ever missed, the cursor has already moved past it and no ordinary sync
  /// will ever ask for it again. A user tapping Synchronize is asking for
  /// exactly that repair, so the manual path does the thorough thing.
  Future<Either<Failure, SyncReport>> call({
    required String uid,
    bool fullResync = false,
  }) async {
    try {
      final settings = await _settingsLocalRepository.get();
      final adapters = _adapters.all();

      // FIRST-SYNC BACKFILL. Rows created before sync existed default to
      // `synced` but were never uploaded, so nothing would ever push them.
      // When the account is genuinely empty, re-mark everything local as
      // pendingCreate once.
      //
      // Gated ONLY on the remote being empty — deliberately NOT on
      // `lastSyncedAt == null` as well. That extra condition made the
      // backfill unreachable after the very first cycle: once a cursor was
      // stored, a local row that had never actually been uploaded stayed
      // `synced` forever, so `readPending` could not see it, the push
      // skipped it, and the sign-out cleanup then refused to clear it
      // (correctly — it cannot prove the server has it). An empty account
      // with local rows means exactly one thing, whatever the cursor says:
      // nothing here has been published yet.
      final isFirstSync = !await _remoteRepository.hasAnyRecords(uid: uid);

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

      // AFTER the push, never before: a tombstone must reach the server so
      // other devices can learn about the deletion, and only then is the
      // document removed. This is what makes Firestore REFLECT a delete
      // instead of keeping the record forever.
      var purged = 0;
      for (final adapter in adapters) {
        purged += await _pushPendingChanges.purgePublishedDeletions(
          uid: uid,
          adapter: adapter,
        );
      }

      // AFTER the record push, so a photo's receipt row always reaches the
      // server before (or with) its image — never an object in the bucket
      // that no document refers to.
      //
      // This is what makes Profile's storage bar mean anything: before it
      // existed, `usedBytes` measured a bucket nothing ever wrote to, so it
      // correctly but uselessly reported 0 MB of the quota.
      final photosUploaded = await _uploadReceiptPhotos(uid: uid);

      var pulled = 0;
      // Per-collection high-water marks, reduced to the OLDEST at the end.
      final marks = <String>[];

      // LEGACY RECOVERY. A document written without `updatedAt` is excluded
      // from `where('updatedAt' > cursor)` by Firestore itself — silently,
      // as an empty result rather than an error. So an incremental pull can
      // never retrieve one, and the user sees a cycle report success while
      // the record stays invisible.
      //
      // The manual "Synchronize now" already repairs this by passing
      // `fullResync`, but nothing automatic ever does: every listener- and
      // lifecycle-driven cycle passes false, so the repair path only ran if
      // the user happened to tap the row. Running it once per install makes
      // recovery automatic, which is the point — the stranded record is on
      // the device the user is already holding.
      final needsLegacyPull = !settings.legacyPullCompleted;

      final unfiltered = fullResync || needsLegacyPull;

      // A full resync starts from nothing, so the server returns everything
      // and any previously-stranded record comes back.
      var cursor = unfiltered ? null : settings.lastSyncedAt;
      for (final adapter in adapters) {
        // SELF-REPAIR, per collection. A collection this device holds NOTHING
        // of cannot trust the shared cursor: there is no local row the cursor
        // could legitimately be "past". Asking unfiltered costs one full read
        // of an empty-for-us collection and is the only way a collection
        // stranded behind the cursor ever comes back.
        //
        // This is not hypothetical — it is the state the max-instead-of-min
        // bug left devices in: categories re-seeded at 13:19 dragged the
        // shared cursor forward, and the receipts (12:54, 13:12) sat in
        // Firestore permanently unreachable while the app showed an empty
        // list and reported `upToDate`.
        final holdsNothingLocally =
            (await adapter.readAllIncludingDeleted()).isEmpty;

        final result = await _pullRemoteChanges(
          uid: uid,
          adapter: adapter,
          sinceUpdatedAt: holdsNothingLocally ? null : cursor,
        );
        pulled += result.applied;

        // Collected, not folded into `cursor` yet: one shared cursor must
        // end up at the OLDEST of the seven marks, and that minimum is only
        // known once every collection has been pulled.
        //
        // This used to take the MAXIMUM, which silently stranded records.
        // A cycle that pushed freshly re-seeded categories got their
        // `updatedAt` back as that collection's mark, jumped the shared
        // cursor to it, and every OTHER collection — whose records are
        // older — fell permanently behind the `updatedAt >` filter. The
        // receipts were still in Firestore and no future sync would ever
        // ask for them again.
        final newest = result.newestUpdatedAt;
        if (newest != null) marks.add(newest);
      }

      // The OLDEST mark, so no collection is skipped. A collection that
      // returned nothing contributes no mark and cannot drag the cursor
      // forward past another collection's unseen records.
      if (marks.length == adapters.length) {
        final oldest = marks.reduce((a, b) => a.compareTo(b) <= 0 ? a : b);
        if (cursor == null || oldest.compareTo(cursor) > 0) cursor = oldest;
      }

      final cursorMoved = cursor != null && cursor != settings.lastSyncedAt;
      if (cursorMoved || needsLegacyPull) {
        final latest = await _settingsLocalRepository.get();
        await _settingsLocalRepository.save(
          latest.copyWith(
            lastSyncedAt: cursorMoved ? cursor : latest.lastSyncedAt,
            // Set even when the sweep found nothing: it ran, and an empty
            // account has no legacy rows to find. Leaving it false would
            // re-read every collection on every cycle forever.
            legacyPullCompleted: true,
          ),
        );
      }

      // AFTER the pull: a photo needs its receipt row to exist locally
      // before there is anything to attach it to. This is what restores
      // images on a device that lost them — a reinstall, or the sign-out
      // cleanup that clears synced records.
      final photosDownloaded = await _downloadReceiptPhotos(uid: uid);

      // Same ordering rule as the photos above: the store row must exist
      // locally before its logo has anything to attach to.
      final logosDownloaded = await _downloadStoreLogos(uid: uid);

      // One line per cycle, deliberately kept. Every sync bug in this
      // feature presented as "the UI says up to date and nothing happened",
      // and without an outcome line that state is indistinguishable from a
      // healthy no-op.
      _loggerService.info(
        'RunFullSync: pushed=$pushed pulled=$pulled purged=$purged '
        'photosUp=$photosUploaded photosDown=$photosDownloaded '
        'logosDown=$logosDownloaded',
        name: 'Sync',
      );

      return Right(
        SyncReport(
          pushed: pushed,
          pulled: pulled,
          photosUploaded: photosUploaded,
          photosDownloaded: photosDownloaded,
          logosDownloaded: logosDownloaded,
          purged: purged,
        ),
      );
    } catch (error, stackTrace) {
      // LOGGED before it is classified away. `classifySyncError` maps this
      // to a short, user-facing `Failure` and the original exception —
      // with its Firestore code and stack — is gone after that. This is the
      // only place that detail still exists, and a sync that silently
      // stopped working is precisely what needs it.
      _loggerService.error(
        'RunFullSync: cycle failed',
        error: error,
        stackTrace: stackTrace,
        name: 'Sync',
      );
      return Left(classifySyncError(error));
    }
  }
}
