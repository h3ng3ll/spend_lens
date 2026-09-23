import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// Image storage, scoped per user.
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

  /// The avatar object, in its own `profile/` folder.
  ///
  /// Kept OUT of `receipts/` so the two can be told apart — [uploadedReceiptIds]
  /// lists that folder to decide which receipt photos still need uploading, and
  /// an avatar filed there would read as a receipt id. It is still BILLED, and
  /// [usedBytes] counts it.
  Reference _avatarRef(String uid) =>
      _firebaseStorage.ref().child('users/$uid/profile/avatar.jpg');

  Reference _receiptRef(String uid, String receiptId) =>
      _receiptsFolder(uid).child('$receiptId.jpg');

  /// A store's logo object, in its own `stores/` folder.
  ///
  /// Kept OUT of `receipts/` for the same reason as the avatar: it would
  /// otherwise read as a receipt id in [uploadedReceiptIds]. It is still
  /// BILLED, and [usedBytes] counts it.
  Reference _storeLogoRef(String uid, String storeId) =>
      _firebaseStorage.ref().child('users/$uid/stores/$storeId.jpg');

  /// A product's photo object, in its own `products/` folder.
  ///
  /// Kept OUT of `receipts/` for the same reason as the store logo and the
  /// avatar: it would otherwise read as a receipt id in [uploadedReceiptIds].
  /// It is still BILLED, and [usedBytes] counts it.
  Reference _productImageRef(String uid, String productId) =>
      _firebaseStorage.ref().child('users/$uid/products/$productId.jpg');

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

  /// Uploads [bytes] as this store's logo, replacing any existing object,
  /// and returns its download URL for the store record.
  ///
  /// The URL is what makes the logo travel: it rides the ordinary record sync
  /// on `Store.logoUrl`, so another device learns a logo exists from the
  /// document alone and fetches the bytes in the photo pass.
  Future<String> uploadStoreLogo({
    required String uid,
    required String storeId,
    required Uint8List bytes,
  }) async {
    final ref = _storeLogoRef(uid, storeId);
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  /// Downloads this store's logo, or null when the object is absent.
  ///
  /// Bounded by [_kMaxPhotoBytes] for the same reason as
  /// [downloadReceiptPhoto] — `getData` buffers the whole object in memory,
  /// and a logo is compressed far below this ceiling.
  ///
  /// Returns null rather than throwing when the object is missing: a store
  /// whose logo never uploaded (offline, or a full account) is a normal
  /// state, not an error.
  Future<Uint8List?> downloadStoreLogo({
    required String uid,
    required String storeId,
  }) async {
    try {
      return await _storeLogoRef(uid, storeId).getData(_kMaxPhotoBytes);
    } on FirebaseException catch (error) {
      if (error.code == 'object-not-found') return null;
      rethrow;
    }
  }

  /// Removes a store's logo object. Already-gone is success, not failure —
  /// the same contract as [deleteReceiptPhoto] and [deleteAvatar], and it is
  /// what lets a remove be retried safely after a partial failure.
  Future<void> deleteStoreLogo({
    required String uid,
    required String storeId,
  }) async {
    try {
      await _storeLogoRef(uid, storeId).delete();
    } on FirebaseException catch (error) {
      if (error.code == 'object-not-found') return;
      rethrow;
    }
  }

  /// Uploads [bytes] as this product's photo, replacing any existing object,
  /// and returns its download URL for the product record.
  ///
  /// The URL is what makes the photo travel: it rides the ordinary record
  /// sync on `Product.imageUrl`, so another device learns a photo exists
  /// from the document alone and fetches the bytes in the photo pass.
  Future<String> uploadProductImage({
    required String uid,
    required String productId,
    required Uint8List bytes,
  }) async {
    final ref = _productImageRef(uid, productId);
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  /// Downloads this product's photo, or null when the object is absent.
  ///
  /// Bounded by [_kMaxPhotoBytes] for the same reason as
  /// [downloadReceiptPhoto] — `getData` buffers the whole object in memory,
  /// and a product photo is compressed far below this ceiling.
  ///
  /// Returns null rather than throwing when the object is missing: a product
  /// whose photo never uploaded (offline, or a full account) is a normal
  /// state, not an error.
  Future<Uint8List?> downloadProductImage({
    required String uid,
    required String productId,
  }) async {
    try {
      return await _productImageRef(uid, productId).getData(_kMaxPhotoBytes);
    } on FirebaseException catch (error) {
      if (error.code == 'object-not-found') return null;
      rethrow;
    }
  }

  /// Removes a product's photo object. Already-gone is success, not failure
  /// — the same contract as [deleteStoreLogo].
  Future<void> deleteProductImage({
    required String uid,
    required String productId,
  }) async {
    try {
      await _productImageRef(uid, productId).delete();
    } on FirebaseException catch (error) {
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

  /// Uploads the user's avatar, replacing any existing object, and returns
  /// its download URL for the Firestore profile document.
  Future<String> uploadAvatar({
    required String uid,
    required Uint8List bytes,
  }) async {
    final ref = _avatarRef(uid);
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  /// Removes the avatar object. Already-gone is success, not failure — the
  /// same contract as [deleteReceiptPhoto], and it is what lets a remove be
  /// retried safely after a partial failure.
  Future<void> deleteAvatar({required String uid}) async {
    try {
      await _avatarRef(uid).delete();
    } on FirebaseException catch (error) {
      if (error.code == 'object-not-found') return;
      rethrow;
    }
  }

  /// Total bytes this user occupies, summed from real object metadata
  /// across EVERY folder this class writes to.
  ///
  /// It used to sum `receipts/` alone, on the reasoning that the Profile
  /// copy calls the figure receipt photos. That was wrong in the direction
  /// that matters: the quota Firebase actually enforces is the whole
  /// bucket, so a store logo or a product photo consumed it while the bar
  /// reported 0 MB. A user with only logos uploaded saw an empty bar, and a
  /// user near the ceiling could be refused an upload the bar said there was
  /// room for. A measurement that omits real bytes is not a narrower
  /// measurement — it is an inaccurate one.
  ///
  /// The copy was corrected to match (`storageEstimateNote`), rather than
  /// the number being trimmed to match the copy.
  ///
  /// Paginated: `listAll()` would fetch every object in one unbounded call.
  Future<int> usedBytes(String uid) async {
    var total = 0;
    for (final folder in _billedFolders(uid)) {
      total += await _folderBytes(folder);
    }
    return total;
  }

  /// Every folder whose objects count against the user's bucket quota.
  ///
  /// `profile/` holds the avatar, which is one small object but is still
  /// billed; leaving it out would reintroduce the same class of error this
  /// method exists to fix.
  List<Reference> _billedFolders(String uid) => [
    _receiptsFolder(uid),
    _firebaseStorage.ref().child('users/$uid/stores'),
    _firebaseStorage.ref().child('users/$uid/products'),
    _firebaseStorage.ref().child('users/$uid/profile'),
  ];

  /// Deletes every RECORD file this user has in the bucket — receipt
  /// photos, store logos and product photos. The avatar under `profile/` is
  /// account identity, not a record, so it is left alone.
  ///
  /// Driven by what the BUCKET holds, not by local rows: a photo whose
  /// record is already gone locally would otherwise be unreachable forever.
  ///
  /// Every page is listed BEFORE anything is deleted, so deleting cannot
  /// shift the listing under a page token and skip objects.
  Future<void> deleteRecordFiles(String uid) async {
    final folders = [
      _receiptsFolder(uid),
      _firebaseStorage.ref().child('users/$uid/stores'),
      _firebaseStorage.ref().child('users/$uid/products'),
    ];

    for (final folder in folders) {
      final items = <Reference>[];
      String? pageToken;
      do {
        final page = await folder.list(
          ListOptions(maxResults: 100, pageToken: pageToken),
        );
        items.addAll(page.items);
        pageToken = page.nextPageToken;
      } while (pageToken != null);

      for (final item in items) {
        try {
          await item.delete();
        } on FirebaseException catch (error) {
          if (error.code == 'object-not-found') continue;
          rethrow;
        }
      }
    }
  }

  /// Sums one folder's object sizes, a page at a time.
  ///
  /// A folder that does not exist yet lists as empty rather than throwing,
  /// which is the normal state for a user who has never added a logo.
  Future<int> _folderBytes(Reference folder) async {
    var total = 0;
    String? pageToken;

    do {
      final page = await folder.list(
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
