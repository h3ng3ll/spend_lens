import '../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../expense/domain/models/expense/expense.dart';
import '../../../../product/domain/models/product/product.dart';
import '../store/store.dart';

/// Named snapshot class combining the streams [StoreDetailBloc] reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value).
///
/// [expenses] is the FULL expense list, not pre-filtered to this store — the
/// "expenses for this store" narrowing is a plain function computed in the
/// widget layer (BLoC rule A3.1 — no `filteredX` state), so the same
/// snapshot shape stays reusable if a later milestone needs the unfiltered
/// list too.
///
/// M6 adds [products], [priceObservations] and ALL [stores] (not just this
/// one) so `ProductsHereCard` can render the real cross-store comparison
/// lines (design_spendlens.md's Conflicts table: "Both" resolution) once
/// scanning (M7/M8) starts writing [PriceObservation]s — until then these
/// lists are genuinely empty and the card renders its honest empty state,
/// same as M5.
class StoreDetailSnapshot {
  final Store? store;
  final List<Expense> expenses;
  final List<Product> products;
  final List<PriceObservation> priceObservations;
  final List<Store> stores;

  const StoreDetailSnapshot({
    required this.store,
    required this.expenses,
    required this.products,
    required this.priceObservations,
    required this.stores,
  });
}
