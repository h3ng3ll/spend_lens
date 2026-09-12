import '../models/receipt/receipt.dart';
import '../models/receipt_storage_info/receipt_storage_info.dart';

/// The receipt data source, resolved.
///
/// Sits ABOVE [IReceiptLocalRepository] rather than replacing it. That
/// separation is deliberate and load-bearing:
///
/// - [IReceiptLocalRepository] stays the single Hive-owning store for the
///   `Receipt` model (hive_rules.md §5, one repository per model). The sync
///   engine's adapters keep talking to it directly, because they operate on
///   raw rows including tombstones.
/// - THIS interface is what screens and blocs talk to. It owns the question
///   "where does this data come from" — local box, filesystem photo, or
///   remote state — so a bloc never composes `FirebaseStorageService` +
///   `ReceiptImageStore` + a local repository by hand to answer one
///   question about a receipt.
///
/// Adding a source later (a remote fetch for a receipt this device has
/// never held) changes only the implementation; no caller moves.
abstract interface class IReceiptRepository {
  Future<Receipt?> getById(String id);

  /// Reactive read — current values, then re-emits on every box mutation.
  Stream<List<Receipt>> watchAll();

  /// Sync state and measured sizes for one receipt.
  ///
  /// Throws nothing for a missing receipt — returns null instead, so a
  /// detail screen opened on a record that was deleted elsewhere shows an
  /// empty state rather than an error.
  Future<ReceiptStorageInfo?> storageInfo(String id);
}
