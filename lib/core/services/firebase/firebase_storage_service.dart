import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// Receipt-photo storage, scoped per user.
///
/// Paths mirror the Firestore layout (`/users/{uid}/receipts/...`) and the
/// matching `storage.rules`, so one uid check governs both stores.
///
/// [usedBytes] is why this class reports sizes at all: the Profile screen's
/// storage bar must show a MEASURED figure, and object metadata is the only
/// honest source for it. The design's "38 MB" is prototype simulation and is
/// never reproduced.
/// Ceiling for a single downloaded photo. `getData` buffers the whole
/// object in memory, and receipt photos are compressed to ~200 KB before
/// upload, so 20 MB is far above any legitimate file while still bounding a
/// corrupt or hostile one.
const int _kMaxPhotoBytes = 20 * 1024 * 1024;

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage;

  FirebaseStorageService({required FirebaseStorage firebaseStorage})
    : this._(firebaseStorage);

  FirebaseStorageService._(this._firebaseStorage);

  Reference _receiptsFolder(String uid) =>
      _firebaseStorage.ref().child('users/$uid/receipts');

  Reference _receiptRef(String uid, String receiptId) =>
      _receiptsFolder(uid).child('$receiptId.jpg');

  /// Uploads [bytes] as this receipt's photo, replacing any existing object.
  /// Returns the stored byte count so the caller can update usage without a
  /// second round-trip.
  Future<int> uploadReceiptPhoto({
    required String uid,
    required String receiptId,
    required Uint8List bytes,
  }) async {
    final task = await _receiptRef(uid, receiptId).putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return task.totalBytes;
  }

  /// Downloads this receipt's photo, or null when the object is absent.
  ///
  /// The counterpart to [uploadReceiptPhoto], and the half that makes the
  /// cloud copy actually a BACKUP rather than a one-way archive: without a
  /// download there was no way to get an image back onto a device that no
  /// longer had it, so clearing local photos would have lost them for good.
  ///
  /// [_kMaxPhotoBytes] bounds `getData` because it buffers the whole object
  /// in memory. Receipt photos are compressed to roughly 200 KB before
  /// upload, so this ceiling is far above any legitimate file and exists to
  /// stop a corrupt or hostile object from exhausting memory.
  ///
  /// Returns null rather than throwing when the object is missing — a
  /// receipt whose photo never uploaded (the account was full, say) is a
  /// normal state, not an error.
  Future<Uint8List?> downloadReceiptPhoto({
    required String uid,
    required String receiptId,
  }) async {
    try {
      return await _receiptRef(uid, receiptId).getData(_kMaxPhotoBytes);
    } on FirebaseException catch (error) {
      if (error.code == 'object-not-found') return null;
      rethrow;
    }
  }

  Future<void> deleteReceiptPhoto({
    required String uid,
    required String receiptId,
  }) async {
    try {
      await _receiptRef(uid, receiptId).delete();
    } on FirebaseException catch (error) {
      // Already gone is success, not a failure — deleting a receipt whose
      // photo never uploaded must not surface an error.
      if (error.code == 'object-not-found') return;
      rethrow;
    }
  }

  /// The receipt ids that already have a photo object in the bucket.
  ///
  /// Lets the upload stage be STATELESS: rather than tracking an
  /// `isPhotoUploaded` flag on every [Receipt] (a Hive model change, with
  /// the adapter-regeneration hazards hive_rules.md warns about), the sync
  /// asks the bucket what it already holds and uploads only the difference.
  /// Re-running a cycle therefore uploads nothing twice.
  ///
  /// Paginated for the same reason as [usedBytes] — `listAll()` is one
  /// unbounded call.
  Future<Set<String>> uploadedReceiptIds(String uid) async {
    final ids = <String>{};
    String? pageToken;

    do {
      final page = await _receiptsFolder(uid).list(
        ListOptions(maxResults: 100, pageToken: pageToken),
      );
      for (final item in page.items) {
        // Objects are stored as `<receiptId>.jpg`.
        ids.add(item.name.replaceFirst(RegExp(r'\.jpg$'), ''));
      }
      pageToken = page.nextPageToken;
    } while (pageToken != null);

    return ids;
  }

  /// Total bytes this user occupies, summed from real object metadata.
  ///
  /// Paginated: `listAll()` would fetch every object in one unbounded call.
  Future<int> usedBytes(String uid) async {
    var total = 0;
    String? pageToken;

    do {
      final page = await _receiptsFolder(uid).list(
        ListOptions(maxResults: 100, pageToken: pageToken),
      );
      for (final item in page.items) {
        final metadata = await item.getMetadata();
        total += metadata.size ?? 0;
      }
      pageToken = page.nextPageToken;
    } while (pageToken != null);

    return total;
  }
}
