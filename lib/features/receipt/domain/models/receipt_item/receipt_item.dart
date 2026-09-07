import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/models/e_sync_status.dart';
import '../../../../product/domain/models/product/e_unit.dart';

part 'receipt_item.freezed.dart';
part 'receipt_item.g.dart';

/// A single parsed/entered line item on a [Receipt] (design_spendlens.md
/// §3).
///
/// **`rawName` is never overwritten** (spec §11, the hardest invariant this
/// milestone must protect): it is the literal OCR/manual-entry text captured
/// at creation time and must survive normalization, rename, and edit —
/// `normalizedName` and `productId` are what change as the item gets
/// matched/renamed, never `rawName`. See
/// `test/features/receipt/domain/receipt_item_raw_name_test.dart`.
@freezed
sealed class ReceiptItem with _$ReceiptItem {
  const factory ReceiptItem({
    required String id,

    /// Literal text as first captured (OCR output or manual entry).
    /// NEVER overwritten after creation — see class doc.
    required String rawName,

    /// Cleaned/canonicalized name — may change as normalization improves or
    /// the user renames the underlying product match.
    required String normalizedName,
    String? productId,
    required double quantity,
    @Default(EUnit.piece) EUnit unit,
    double? unitPrice,
    required double lineTotal,

    /// Parser confidence in [0, 1] for this line's extraction.
    required double confidence,
    @Default(false) bool isLowConfidence,
    @Default(false) bool isManuallyAdded,

    /// Position on the receipt — preserves print order across
    /// re-normalization or re-ordering elsewhere in the pipeline.
    required int lineIndex,
    required DateTime updatedAt,
    DateTime? deletedAt,
    @Default(ESyncStatus.synced) ESyncStatus syncStatus,
  }) = _ReceiptItem;

  factory ReceiptItem.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemFromJson(json);
}
