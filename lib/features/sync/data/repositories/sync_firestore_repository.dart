import '../../../../core/services/firebase/e_sync_collection.dart';
import '../../../../core/services/firebase/firebase_firestore_service.dart';
import '../../domain/models/remote_record/remote_record.dart';
import '../../domain/repositories/i_sync_remote_repository.dart';

/// Firestore-backed [ISyncRemoteRepository].
///
/// Throws on failure rather than returning `Either`: the `Failure` boundary
/// lives in the use cases (matching how `google_sign_in_use_case` wraps
/// `IAuthRepository`), so error classification happens once, where the retry
/// decision is made.
class SyncFirestoreRepository implements ISyncRemoteRepository {
  final FirebaseFirestoreService _firestoreService;

  const SyncFirestoreRepository(this._firestoreService);

  @override
  Future<void> pushRecords({
    required String uid,
    required ESyncCollection collection,
    required List<Map<String, dynamic>> records,
  }) async {
    if (records.isEmpty) return;

    final reference = _firestoreService.records(uid, collection);

    // Firestore caps a batch at 500 operations; a chunk per commit keeps a
    // large first upload from failing wholesale.
    for (
      var offset = 0;
      offset < records.length;
      offset += FirebaseFirestoreService.kBatchLimit
    ) {
      final end = (offset + FirebaseFirestoreService.kBatchLimit).clamp(
        0,
        records.length,
      );
      final batch = _firestoreService.batch();

      for (final record in records.sublist(offset, end)) {
        final id = record['id'] as String;
        // `set` without merge: the local row is the whole truth for this
        // document, and a merge would leave stale fields behind after an
        // edit that cleared one.
        batch.set(reference.doc(id), record);
      }

      await batch.commit();
    }
  }

  @override
  Future<List<RemoteRecord>> fetchRecords({
    required String uid,
    required ESyncCollection collection,
    String? sinceUpdatedAt,
  }) async {
    var query = _firestoreService.records(uid, collection).orderBy('updatedAt');

    if (sinceUpdatedAt != null && sinceUpdatedAt.isNotEmpty) {
      // String comparison is correct here: `toIso8601String()` is
      // fixed-width and zero-padded, so lexicographic == chronological.
      query = query.where('updatedAt', isGreaterThan: sinceUpdatedAt);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => RemoteRecord(id: doc.id, json: doc.data()))
        .toList();
  }

  @override
  Future<bool> hasAnyRecords({required String uid}) async {
    for (final collection in ESyncCollection.values) {
      final snapshot = await _firestoreService
          .records(uid, collection)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) return true;
    }
    return false;
  }
}
