import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/models/e_sync_status.dart';

part 'receipt.freezed.dart';
part 'receipt.g.dart';

/// A saved, scanned or manually-entered receipt (design_spendlens.md §3).
///
/// `imagePath` stores a **filename only** — the receipt photo itself lives
/// on the filesystem (`<Documents>/receipts/receipt_<id>.jpg`), never as a
/// Hive value (spec §21); `core/services/receipt_image_store.dart` (M8)
/// resolves the directory at read time since the Documents path changes
/// across iOS reinstalls.
@freezed
sealed class Receipt with _$Receipt {
  const factory Receipt({
    required String id,
    String? storeId,
    required DateTime purchasedAt,

    /// The total as printed on the receipt, before reconciliation. `null`
    /// when OCR could not find a total keyword line.
    double? printedTotal,

    /// The sum of this receipt's [ReceiptItem] line totals — always
    /// computed, never null, so a mismatch against [printedTotal] can be
    /// detected by the reconciler (spec §45).
    required double itemsTotal,
    double? discount,
    required String currencyCode,
    String? categoryId,

    /// Filename only (see class doc) — never a full path.
    String? imagePath,
    @Default(<String>[]) List<String> itemIds,

    /// Whether the user has confirmed/accepted the reconciler's total-match
    /// check (spec §45 — a mismatch WARNS but always allows saving).
    @Default(false) bool isReconciled,
    required DateTime updatedAt,
    DateTime? deletedAt,
    @Default(ESyncStatus.synced) ESyncStatus syncStatus,
  }) = _Receipt;

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);
}
