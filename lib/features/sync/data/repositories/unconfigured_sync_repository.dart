import '../../../../core/services/firebase/e_sync_collection.dart';
import '../../domain/models/remote_record/remote_record.dart';
import '../../domain/repositories/i_sync_remote_repository.dart';

/// No-op [ISyncRemoteRepository] for when Firebase is unavailable.
///
/// Mirrors `UnconfiguredAuthRepository`: a missing backend is a DISABLED
/// FEATURE with honest UI, never a thrown exception. Every method succeeds
/// vacuously, so the sync bloc settles on "disabled" rather than "failed" —
/// respecting the recorded bug where absent data was mapped to a failed
/// status and the first launch read "something went wrong".
class UnconfiguredSyncRepository implements ISyncRemoteRepository {
  const UnconfiguredSyncRepository();

  @override
  Future<void> pushRecords({
    required String uid,
    required ESyncCollection collection,
    required List<Map<String, dynamic>> records,
  }) async {}

  @override
  Future<void> deleteRecords({
    required String uid,
    required ESyncCollection collection,
    required List<String> ids,
  }) async {}

  @override
  Future<List<RemoteRecord>> fetchRecords({
    required String uid,
    required ESyncCollection collection,
    String? sinceUpdatedAt,
  }) async => const [];

  @override
  Future<bool> hasAnyRecords({required String uid}) async => false;
}
