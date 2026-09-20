import '../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../store/domain/models/store/store.dart';
import '../product/product.dart';

/// Named snapshot class combining the streams `ProductDetailBloc` reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value), following the shape `StoreDetailSnapshot` established.
///
/// [allProducts] is the FULL list, not just this product: the linked-product
/// card has to resolve `linkedProductIds` to live rows, and the link picker
/// needs candidates from other stores. Narrowing happens in the widget
/// layer as plain functions (BLoC rule A3.1 — no derived state).
class ProductDetailSnapshot {
  final Product? product;
  final List<Product> allProducts;
  final List<PriceObservation> observations;
  final List<Store> stores;

  const ProductDetailSnapshot({
    required this.product,
    required this.allProducts,
    required this.observations,
    required this.stores,
  });
}
