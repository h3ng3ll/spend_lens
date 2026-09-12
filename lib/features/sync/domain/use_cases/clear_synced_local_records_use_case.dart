import '../../../../core/models/e_sync_status.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../../../core/services/firebase/firebase_firestore_service.dart';
import '../../../store/domain/repositories/i_store_local_repository.dart';
import 'run_full_sync_use_case.dart';

/// Drops local copies of records the server already holds, on sign-out.
///
/// **Only `synced` rows are removed.** A row that is not synchronized
/// exists nowhere else — deleting it would destroy the user's only copy —
/// so it stays on the device and syncs once they sign in again. That
/// asymmetry is the entire safety property of this operation.
///
/// **Hard delete, never the repositories' soft delete.** `delete()` stamps
/// `pendingDelete` + `deletedAt` so a removal PROPAGATES; using it here
/// would push tombstones on the next sync and erase the user's cloud data —
/// the exact opposite of the intent. Every removal here goes through
/// `deleteLocalOnly`, which leaves no tombstone.
///
/// Photos go too, because [DownloadReceiptPhotosUseCase] fetches them back
/// on the next sign-in. Without that download path this would lose images
/// permanently, which is why the two landed together.
///
/// **It syncs FIRST.** Without that this cleared almost nothing in practice:
/// records created since the last cycle are still `pendingCreate`, so the
/// `synced`-only rule (correctly) kept every one of them, and a user who
/// added a receipt and signed out saw nothing removed at all. Pushing first
/// turns "not synchronized yet" into "safely on the server", which is what
/// makes it eligible to be cleared.
///
/// A failed sync is not fatal: whatever did not reach the server simply
/// stays on the device, which is the same guarantee as before. A `Left`
/// means fewer rows qualify as `synced`, which the clearing rule already
/// handles — so the cycle's result is not inspected here at all.
class ClearSyncedLocalRecordsUseCase {
  final IReceiptLocalRepository _receiptLocalRepository;
  final IReceiptItemLocalRepository _receiptItemLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;
  final ReceiptImageStore _imageStore;
  final RunFullSyncUseCase _runFullSync;
  final FirebaseFirestoreService _firestoreService;
  final LoggerService _loggerService;

  const ClearSyncedLocalRecordsUseCase({
    required this._receiptLocalRepository,
    required this._receiptItemLocalRepository,
    required this._storeLocalRepository,
    required this._imageStore,
    required this._runFullSync,
    required this._firestoreService,
    required this._loggerService,
  });

  /// Returns how many receipts were cleared.
  Future<int> call() async {
    await _publishPendingWork();

    final receipts = await _receiptLocalRepository.getAll();

    final cleared = <String>{};
    for (final receipt in receipts) {
      if (receipt.syncStatus != ESyncStatus.synced) continue;

      // The photo first: if this throws we have not yet dropped the row, so
      // a retry still knows the file is owed. The reverse order would leave
      // an orphaned JPEG no record points at.
      await _imageStore.delete(receipt.imagePath);

      for (final itemId in receipt.itemIds) {
        await _receiptItemLocalRepository.deleteLocalOnly(itemId);
      }
      await _receiptLocalRepository.deleteLocalOnly(receipt.id);
      cleared.add(receipt.id);
    }

    await _clearOrphanedStores();

    return cleared.length;
  }

  /// Pushes everything outstanding so it becomes eligible for clearing.
  ///
  /// Runs while the session is still alive — the caller invokes this BEFORE
  /// `signOut()`, so `currentUid` is still valid here.
  ///
  /// Returns NOTHING, deliberately. Success is not actionable: a failed
  /// cycle must never block sign-out, and the outcome is already absorbed by
  /// the `synced`-only rule that follows — fewer rows qualify, so more of
  /// them stay on the device, which is the conservative and correct result.
  /// Returning a `bool` no caller can act on would only invite someone to
  /// branch on it and skip the cleanup, which is exactly the wrong
  /// behaviour.
  ///
  /// The failure IS handled, though — it is LOGGED rather than discarded.
  /// `RunFullSyncUseCase` classifies it into a `Failure` and returns it;
  /// nothing in the sync feature logs, so dropping the `Left` here would
  /// erase the only record that a sign-out left unpushed work behind. That
  /// is precisely the case worth diagnosing later: the user signed out, the
  /// rows stayed local, and without this line nobody could tell why.
  Future<void> _publishPendingWork() async {
    final uid = _firestoreService.currentUid;
    if (uid == null || uid.isEmpty) {
      _loggerService.info(
        'ClearSyncedLocalRecords: no signed-in user — nothing to publish '
        'before sign-out.',
      );
      return;
    }

    final result = await _runFullSync(uid: uid);

    // The project's side order: Left = failure.
    result.fold(
      (failure) => _loggerService.warning(
        'ClearSyncedLocalRecords: pre-sign-out sync did not complete '
        '(${failure.message}). Unpushed rows stay on this device and are '
        'not eligible for clearing.',
      ),
      (report) => _loggerService.info(
        'ClearSyncedLocalRecords: pre-sign-out sync pushed '
        '${report.pushed} record(s).',
      ),
    );
  }

  /// Removes synced stores nothing local still points at.
  ///
  /// Re-reads the receipts AFTER the deletions above, so "still referenced"
  /// means referenced by what actually remains. A store a
  /// not-synchronized receipt points at is kept — dropping it would leave
  /// that receipt naming a store this device no longer has.
  Future<void> _clearOrphanedStores() async {
    final remaining = await _receiptLocalRepository.getAll();
    final referenced = {
      for (final receipt in remaining)
        if (receipt.storeId != null) receipt.storeId!,
    };

    final stores = await _storeLocalRepository.getAll();
    for (final store in stores) {
      if (store.syncStatus != ESyncStatus.synced) continue;
      if (referenced.contains(store.id)) continue;

      await _storeLocalRepository.deleteLocalOnly(store.id);
    }
  }
}
