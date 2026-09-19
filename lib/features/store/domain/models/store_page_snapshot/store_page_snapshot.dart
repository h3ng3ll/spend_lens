import '../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../expense/domain/models/expense/expense.dart';
import '../../../../product/domain/models/product/product.dart';
import '../store/store.dart';

/// Named snapshot class combining the streams [StorePageBloc] reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value).
///
/// Per-store aggregates (visit count, total spent this month, product count)
/// are deliberately NOT stored here or in any bloc state — they are derived
/// as plain functions over this snapshot in the widget layer (BLoC rule A3.1
/// — no `filteredX`/derived fields in state).
class StorePageSnapshot {
  final List<Store> stores;
  final List<Expense> expenses;

  /// Carried so a row can resolve a product id to a product. The COUNT only
  /// needs [priceObservations], but keeping the two together matches
  /// `StoreDetailSnapshot` and means a future row detail does not need
  /// another stream added to the combine.
  final List<Product> products;

  /// The product<->store edge (`PriceObservation.storeId` +
  /// `.productId`) — the only link between the two, and therefore the only
  /// thing a per-store product count can be derived from.
  final List<PriceObservation> priceObservations;

  const StorePageSnapshot({
    required this.stores,
    required this.expenses,
    required this.products,
    required this.priceObservations,
  });
}
