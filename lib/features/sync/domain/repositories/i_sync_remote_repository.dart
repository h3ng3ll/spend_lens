import '../../../../core/services/firebase/e_sync_collection.dart';
import '../models/remote_record/remote_record.dart';

/// The remote half of record sync.
///
/// Deliberately generic over `Map<String, dynamic>` rather than typed per
/// entity: all seven entities serialize through the same `toJson()`/`fromJson`
/// contract, so a typed interface would need seven near-identical methods and
/// seven implementations to say the same thing. Mapping back to a model
/// happens in the pull use case, which is the only place that knows which
/// collection it asked for.
abstract interface class ISyncRemoteRepository {
  /// Upserts [records] into [collection] for [uid], in batches.
  ///
  /// Tombstones are written as documents carrying `deletedAt`, never as
  /// Firestore deletes — a removed document leaves nothing for a
  /// currently-offline device to learn from, so it would re-upload the row.
  Future<void> pushRecords({
    required String uid,
    required ESyncCollection collection,
    required List<Map<String, dynamic>> records,
  });

  /// Permanently removes [ids] from [collection], in batches.
  ///
  /// The SECOND half of a delete, run after the tombstone has been pushed.
  /// A tombstone alone leaves the document sitting in Firestore forever: the
  /// record is correctly hidden in the app, but the console still shows it,
  /// and it keeps consuming the user's storage for data they deleted.
  ///
  /// Ordering is what makes this safe — see `RunFullSyncUseCase`. The
  /// tombstone is uploaded first so any other device can learn about the
  /// deletion from it; only then is the document purged.
  Future<void> deleteRecords({
    required String uid,
    required ESyncCollection collection,
    required List<String> ids,
  });

  /// Every document in [collection] whose `updatedAt` is strictly after
  /// [sinceUpdatedAt] (an ISO-8601 string), or all of them when it is null.
  Future<List<RemoteRecord>> fetchRecords({
    required String uid,
    required ESyncCollection collection,
    String? sinceUpdatedAt,
  });

  /// Whether this user has any records at all. Distinguishes a genuinely
  /// empty account (first sync from this device — everything local must be
  /// uploaded) from one that simply has nothing new since the cursor.
  Future<bool> hasAnyRecords({required String uid});
}
