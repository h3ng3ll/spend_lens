import '../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../linking/linked_product_group.dart';
import '../models/product/product.dart';
import '../repositories/i_product_local_repository.dart';

/// Splits legacy store-less products into one product per store — the
/// one-shot repair that makes the per-store product model true of data
/// created before it existed.
///
/// THE DEFECT IT FIXES. `Product.storeId` is stamped only when the
/// normalizer CREATES a product, so every product predating that field
/// stayed null — "general purpose". Because the Stores screen lists products
/// by where their PRICES were observed rather than by ownership, one such
/// product appears under every store it was ever bought at, and its page
/// shows every store's prices in one list and one inflation curve. A "+23%"
/// rise could then be nothing but a switch from a cheap shop to an expensive
/// one.
///
/// IDEMPOTENT BY CONSTRUCTION. A product that already owns a store is
/// skipped, and split copies are given deterministic ids, so a second run
/// finds its work already done rather than splitting the splits. That also
/// makes it safe across devices: the split publishes through ordinary sync,
/// and a device that pulls already-split products simply has nothing to do.
/// The settings flag is an optimisation on top, never the correctness
/// guarantee.
class SplitLegacyProductsUseCase {
  final IProductLocalRepository _productRepository;
  final IPriceObservationLocalRepository _priceObservationRepository;
  final IReceiptLocalRepository _receiptRepository;
  final IReceiptItemLocalRepository _receiptItemRepository;
  final DateTime Function() _now;

  const SplitLegacyProductsUseCase({
    required this._productRepository,
    required this._priceObservationRepository,
    required this._receiptRepository,
    required this._receiptItemRepository,
    this._now = DateTime.now,
  });

  /// Runs the split. Returns the number of products created.
  Future<int> call() async {
    final products = await _productRepository.getAll();
    final legacy = products.where((p) => p.storeId == null).toList();
    if (legacy.isEmpty) return 0;

    final observations = await _priceObservationRepository.getAll();

    var created = 0;
    for (final product in legacy) {
      created += await _splitOne(product, observations);
    }
    return created;
  }

  Future<int> _splitOne(
    Product product,
    List<PriceObservation> allObservations,
  ) async {
    final mine = allObservations
        .where((o) => o.productId == product.id && o.deletedAt == null)
        .toList();

    // Group by store, keeping only observations that name one. A manually
    // entered price with no store belongs nowhere in particular, so it stays
    // with the original product rather than being assigned by guesswork.
    final byStore = <String, List<PriceObservation>>{};
    for (final observation in mine) {
      final storeId = observation.storeId;
      if (storeId == null) continue;
      byStore.putIfAbsent(storeId, () => []).add(observation);
    }

    // Nothing says where this product belongs. Leaving it general-purpose is
    // the honest outcome — inventing a store would be a guess the user never
    // made, and they can still assign one by hand.
    if (byStore.isEmpty) return 0;

    // Oldest history first, so the ORIGINAL id — the one receipt items and
    // sync already reference — stays with the store the product was bought
    // at first, and the fewest rows have to be repointed.
    final storeIds = byStore.keys.toList()
      ..sort((a, b) {
        final byDate = _earliest(byStore[a]!).compareTo(_earliest(byStore[b]!));
        // Ties broken by id so the outcome is deterministic across devices
        // and across runs; an unstable order here would let two devices keep
        // the original id on different stores.
        return byDate != 0 ? byDate : a.compareTo(b);
      });

    final now = _now();
    final owner = storeIds.first;
    final splitIds = <String>[product.id];

    // The original adopts the first store. No new row, no repointing: its
    // observations already carry that storeId.
    await _productRepository.save(
      product.copyWith(storeId: owner, updatedAt: now),
    );

    var created = 0;
    for (final storeId in storeIds.skip(1)) {
      // Deterministic: a second run produces the same id and overwrites the
      // existing copy in place instead of minting a duplicate.
      final copyId = '${product.id}_split_$storeId';
      splitIds.add(copyId);

      // Written BEFORE its observations are repointed, so no observation
      // ever names a product that does not exist yet.
      await _productRepository.save(
        Product(
          id: copyId,
          normalizedName: product.normalizedName,
          displayName: product.displayName,
          aliases: product.aliases,
          defaultCategoryId: product.defaultCategoryId,
          defaultUnit: product.defaultUnit,
          storeId: storeId,
          updatedAt: now,
        ),
      );
      created++;

      for (final observation in byStore[storeId]!) {
        await _priceObservationRepository.save(
          observation.copyWith(productId: copyId, updatedAt: now),
        );
        await _repointReceiptItem(observation, product.id, copyId);
      }
    }

    await _linkSplitSet(splitIds, now);
    return created;
  }

  /// Repoints the receipt line that produced [observation] at the split copy.
  ///
  /// NOT cosmetic. `RecordPriceObservationsUseCase` rebuilds a receipt's
  /// observations from `receiptItem.productId` and REPLACES the whole set on
  /// every correction save. A receipt item still naming the pre-split product
  /// would therefore drag its observation back the first time the user edits
  /// that receipt — silently undoing this migration weeks later, with the
  /// prices re-merging and no error to notice.
  ///
  /// Changing `productId` disturbs nothing else: the observation's own id is
  /// derived from `receiptId`, and the retire sweep matches on `receiptId`
  /// too, never on the product.
  Future<void> _repointReceiptItem(
    PriceObservation observation,
    String fromProductId,
    String toProductId,
  ) async {
    final receiptId = observation.receiptId;
    if (receiptId == null) return;

    final receipt = await _receiptRepository.getById(receiptId);
    if (receipt == null) return;

    for (final itemId in receipt.itemIds) {
      final item = await _receiptItemRepository.getById(itemId);
      if (item == null || item.deletedAt != null) continue;
      if (item.productId != fromProductId) continue;

      await _receiptItemRepository.save(
        item.copyWith(productId: toProductId, updatedAt: _now()),
      );
    }
  }

  /// Links every member of a split set to every other member.
  ///
  /// The split is the one case where a cross-store link is known to be
  /// correct without asking: these rows were literally one product a moment
  /// ago. Linking them keeps the store-detail "cheaper by" comparison
  /// working across the split, which would otherwise collapse to "only
  /// bought here" for data that had a real comparison before.
  Future<void> _linkSplitSet(List<String> ids, DateTime now) async {
    if (ids.length < 2) return;

    for (var i = 0; i < ids.length; i++) {
      for (var j = i + 1; j < ids.length; j++) {
        final a = await _productRepository.getById(ids[i]);
        final b = await _productRepository.getById(ids[j]);
        if (a == null || b == null) continue;

        final linked = linkProducts(a, b, now);
        await _productRepository.save(linked.a);
        await _productRepository.save(linked.b);
      }
    }
  }

  DateTime _earliest(List<PriceObservation> observations) {
    var earliest = observations.first.observedAt;
    for (final observation in observations) {
      if (observation.observedAt.isBefore(earliest)) {
        earliest = observation.observedAt;
      }
    }
    return earliest;
  }
}
