import '../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../product/domain/models/product/product.dart';
import '../../../../store/domain/models/store/store.dart';

/// Named snapshot class combining the streams `CompareBloc` reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value), following the shape `StoreDetailSnapshot` established.
///
/// Everything is the FULL list. Narrowing each half to its selected store is
/// a plain function computed in the widget layer (BLoC rule A3.1 — no
/// derived state), so the two columns share one definition of "this store's
/// products" with the rest of the app.
class CompareSnapshot {
  final List<Store> stores;
  final List<Product> products;
  final List<PriceObservation> observations;

  const CompareSnapshot({
    required this.stores,
    required this.products,
    required this.observations,
  });
}
