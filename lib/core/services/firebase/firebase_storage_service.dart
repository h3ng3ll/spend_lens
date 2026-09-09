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
