import '../../../../core/models/e_sync_status.dart';
import '../../../../core/services/firebase/e_sync_collection.dart';

/// Everything the sync engine needs to know about ONE entity type.
///
/// The seven syncable entities share no supertype — each is an independent
/// freezed class — so this closure bundle is what lets push and pull be
/// written once instead of seven times. Each adapter is the only place that
/// knows a given entity's concrete type.
class SyncEntityAdapter<T> {
  final ESyncCollection collection;

  /// Tombstones included — push must see deletions.
  final Future<List<T>> Function() readAllIncludingDeleted;

  /// Rows whose `syncStatus != synced`.
  final Future<List<T>> Function() readPending;

  /// Writes rows verbatim (`markPending: false`), for landing server data.
  final Future<void> Function(List<T> items) writeAllVerbatim;

  final Map<String, dynamic> Function(T entity) toJson;
  final T Function(Map<String, dynamic> json) fromJson;

  final String Function(T entity) idOf;
  final DateTime Function(T entity) updatedAtOf;
  final ESyncStatus Function(T entity) syncStatusOf;

  /// Returns [entity] marked `synced`, for the post-push write-back.
  final T Function(T entity) markSynced;

  /// When this row was soft-deleted, or null while it is live.
  ///
  /// Needed so the purge pass can tell a tombstone whose deletion has
  /// already been published from a live row.
  final DateTime? Function(T entity) deletedAtOf;

  /// HARD-removes a row locally, leaving no tombstone.
  ///
  /// Used only to retire a tombstone once its deletion has reached the
  /// server and the remote document is gone — at that point the marker has
  /// done its job and keeping it forever just grows the box.
  final Future<void> Function(String id) purgeLocal;

  /// Re-emits on every box mutation. Used only as a CHANGE TRIGGER for
  /// recounting pending rows — the emitted list itself is ignored, which is
  /// why the element type is not part of this signature.
  final Stream<void> Function() watchAll;

  const SyncEntityAdapter({
    required this.collection,
    required this.readAllIncludingDeleted,
    required this.readPending,
    required this.writeAllVerbatim,
    required this.toJson,
    required this.fromJson,
    required this.idOf,
    required this.updatedAtOf,
    required this.syncStatusOf,
    required this.markSynced,
    required this.deletedAtOf,
    required this.purgeLocal,
    required this.watchAll,
  });
}
