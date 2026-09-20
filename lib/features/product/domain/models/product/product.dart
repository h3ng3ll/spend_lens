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

    /// The store this product belongs to, or null for a GENERAL-PURPOSE
    /// product — one created from a scan before any store was resolved.
    ///
    /// Per-store products are a deliberate product decision: the same goods
    /// bought at two stores are two [Product] rows, so each store owns its
    /// own price line. The consequence is that cross-store comparison can no
    /// longer group by `productId` alone — see [linkedProductIds].
    ///
    /// Legacy rows decode with null here, which reads correctly: a product
    /// created before stores were tracked genuinely belongs to no store.
    String? storeId,

    /// Products at OTHER stores the user has declared to be the same goods.
    ///
    /// SYMMETRIC — both sides carry each other's id — and resolved into a
    /// transitive group at read time by `resolveLinkedGroup`, so A-B plus
    /// B-C makes A and C comparable without any group-id bookkeeping to
    /// rebalance on unlink.
    ///
    /// This is what keeps the store-detail "cheaper by" comparison alive
    /// under per-store products: the comparator groups observations over the
    /// linked SET rather than a single `productId`. Empty = compares against
    /// nothing, which renders as "Only bought here".
    @Default(<String>[]) List<String> linkedProductIds,

    /// FILENAME of the product's photo on disk (`product_<id>.jpg`),
    /// resolved against the CURRENT Documents directory by
    /// [ProductImageStore] — never a full path, which dangles across iOS
    /// reinstalls, and never the bytes, which must not reach Hive or a bloc
    /// state (see `AvatarImageStore` for the two defects that rule
    /// prevents).
    ///
    /// Null = no photo, which is what makes the remove affordance
    /// conditional.
    String? imageFilename,

    /// Firebase Storage download URL for `users/{uid}/products/{id}.jpg`.
    ///
    /// Carried on the record so the photo travels with the product through
    /// the ordinary record sync: a device that pulls this row learns a photo
    /// exists, and the photo pass fetches the bytes. Empty = not uploaded
    /// yet (offline, or the account is full), which is a normal state and
    /// not an error.
    @Default('') String imageUrl,
    required DateTime updatedAt,
    DateTime? deletedAt,
    @Default(ESyncStatus.synced) ESyncStatus syncStatus,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
