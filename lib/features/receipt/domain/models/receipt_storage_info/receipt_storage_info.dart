import '../../../../../core/models/e_sync_status.dart';

/// What one receipt costs in storage, and whether it has reached the server.
///
/// A plain class, not freezed: it is derived at read time from the receipt,
/// its items and the photo on disk — never persisted, never serialized, so
/// it needs no `copyWith`, no adapter and no `toJson`.
///
/// [photoBytes] and [documentBytes] are kept SEPARATE rather than summed.
/// Only the photo occupies Firebase Storage and counts toward the quota
/// Profile's bar measures; the document lives in Firestore and is accounted
/// differently. A single combined number would imply the two are
/// interchangeable against one quota, which they are not.
class ReceiptStorageInfo {
  final ESyncStatus syncStatus;

  /// Size of the receipt photo on disk, or 0 when this receipt has no photo
  /// (or its file is gone — an OS purge, a restore from backup).
  final int photoBytes;

  /// Estimated size of the receipt document plus its items
  /// (`ReceiptSizeCalculator`).
  final int documentBytes;

  /// Whether the photo is believed to have reached cloud storage.
  ///
  /// DERIVED from [syncStatus], not queried from Firebase — see
  /// `ReceiptRepository.storageInfo` for why.
  final bool isPhotoUploaded;

  const ReceiptStorageInfo({
    required this.syncStatus,
    required this.photoBytes,
    required this.documentBytes,
    required this.isPhotoUploaded,
  });

  bool get hasPhoto => photoBytes > 0;
}
