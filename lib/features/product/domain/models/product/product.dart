import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/models/e_sync_status.dart';
import 'e_unit.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// A normalized product identity the parser/normalizer resolves receipt line
/// items to (design_spendlens.md §3, §6 normalizer pipeline). Distinct from
/// [ReceiptItem]: many receipt items across many receipts/stores resolve to
/// one [Product], which is what makes price-history comparison possible.
@freezed
sealed class Product with _$Product {
  const factory Product({
    required String id,

    /// Canonicalized name used for matching (lowercase, whitespace/OCR
    /// cleanup, abbreviation-expanded) — never shown to the user.
    required String normalizedName,

    /// User-facing name.
    required String displayName,

    /// Alternate raw-OCR spellings that have been matched to this product.
    @Default(<String>[]) List<String> aliases,
    String? defaultCategoryId,
    @Default(EUnit.piece) EUnit defaultUnit,
    required DateTime updatedAt,
    DateTime? deletedAt,
    @Default(ESyncStatus.synced) ESyncStatus syncStatus,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
