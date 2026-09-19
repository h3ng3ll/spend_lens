import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/models/e_sync_status.dart';
import 'e_store_type.dart';

part 'store.freezed.dart';
part 'store.g.dart';

/// A store the user has bought from (design_spendlens.md §3). Created
/// either explicitly ("New store" flow) or resolved by the receipt parser's
/// store-resolver stage from a receipt's printed name.
@freezed
sealed class Store with _$Store {
  const factory Store({
    required String id,
    required String name,

    /// Alternate spellings the parser has seen on printed receipts for this
    /// store (e.g. `'NR1 SRL'` for "Nr.1, Green Hills") — never displayed,
    /// used only to resolve incoming receipts to this [Store].
    @Default(<String>[]) List<String> receiptAliases,
    @Default(EStoreType.other) EStoreType type,

    /// FILENAME of the store's logo on disk (`store_<id>.jpg`), resolved
    /// against the CURRENT Documents directory by [StoreLogoImageStore] —
    /// never a full path, which dangles across iOS reinstalls, and never the
    /// bytes, which must not reach Hive or a bloc state (see
    /// `AvatarImageStore` for the two defects that rule prevents).
    ///
    /// Null = no logo, which is what makes the remove affordance conditional.
    String? logoFilename,

    /// Firebase Storage download URL for `users/{uid}/stores/{id}.jpg`.
    ///
    /// Carried on the record so the logo travels with the store through the
    /// ordinary record sync: a device that pulls this row learns a logo
    /// exists, and the photo pass fetches the bytes. Empty = not uploaded
    /// yet (offline, or the account is full), which is a normal state and
    /// not an error.
    @Default('') String logoUrl,
    required DateTime updatedAt,
    DateTime? deletedAt,
    @Default(ESyncStatus.synced) ESyncStatus syncStatus,
  }) = _Store;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
}
