import '../../../../core/models/e_sync_status.dart';
import '../models/product/product.dart';
import '../repositories/i_product_local_repository.dart';

/// Applies a user-typed display name to the [Product] a receipt line
/// resolved to, and returns the product as it now stands.
///
/// WHY A USE CASE. A saved receipt line is displayed by its PRODUCT's name
/// (`receiptItemDisplayName`) — there is one name, on one entity. So a
/// rename typed on a receipt line is only real once it reaches the product,
/// and that made the rename a piece of domain policy that BOTH save paths
/// (`EditReceiptBloc._onSave` and `SaveScannedReceiptUseCase`) needed. It
/// was briefly inlined into each of them, which meant two copies of a rule
/// with three easy ways to get it subtly wrong — and one of the copies
/// already had: it dropped the alias below.
///
/// WHAT THE RULE IS:
///
/// - A blank name, or one equal to the current display name, is NOT a
///   rename — the product is returned untouched and nothing is written.
/// - `normalizedName` is NEVER reassigned. It is the normalizer's matching
///   key and is not shown to anyone; rewriting it would re-point matching at
///   the new spelling and strand every line already bound by the old one.
/// - The PREVIOUS spelling is kept as an alias, so a later receipt that
///   still prints the old text keeps resolving to this same product instead
///   of creating a duplicate. This mirrors the rename on the product-detail
///   screen, which is where the rule was first established.
/// - `ReceiptItem.rawName` is not this class's business and is never
///   touched — it stays byte-for-byte what the receipt printed (spec §11).
class RenameProductUseCase {
  final IProductLocalRepository _productRepository;
  final DateTime Function() _now;

  const RenameProductUseCase({
    required IProductLocalRepository productRepository,
    DateTime Function() now = DateTime.now,
  }) : this._(productRepository, now);

  const RenameProductUseCase._(this._productRepository, this._now);

  /// Renames [product] to [displayName] if that is an actual change, and
  /// returns the product to use from here on — the renamed one when a write
  /// happened, otherwise [product] unchanged.
  ///
  /// Returning the product (rather than void) is what lets a caller keep its
  /// own in-flight candidate list consistent without re-reading the box.
  Future<Product> call({
    required Product product,
    required String displayName,
  }) async {
    final name = displayName.trim();
    if (name.isEmpty || name == product.displayName) return product;

    // Keep the OLD spelling as an alias: `normalizedName` stays the matcher
    // key, so a receipt still printing the previous name keeps resolving to
    // this product instead of creating a duplicate.
    final previous = product.displayName.trim().toLowerCase();
    final aliases = product.aliases.contains(previous) || previous.isEmpty
        ? product.aliases
        : [...product.aliases, previous];

    final renamed = product.copyWith(
      displayName: name,
      aliases: aliases,
      updatedAt: _now(),
      syncStatus: ESyncStatus.pendingUpdate,
    );
    await _productRepository.save(renamed);
    return renamed;
  }
}
