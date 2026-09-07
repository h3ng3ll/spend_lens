import '../../../../product/domain/models/product/product.dart';
import '../../../../store/domain/models/store/store.dart';
import '../price_observation/price_observation.dart';

/// Named snapshot class combining the streams [PriceHistoryBloc] reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value), following the exact shape `HomeSnapshot`/`AnalyticsSnapshot`
/// established.
class PriceHistorySnapshot {
  final Product? product;
  final List<PriceObservation> observations;
  final List<Store> stores;

  const PriceHistorySnapshot({
    required this.product,
    required this.observations,
    required this.stores,
  });
}
