import '../models/price_observation/price_observation.dart';

/// One repository per model (hive_rules.md §5) — owns [PriceObservation]
/// only.
abstract interface class IPriceObservationLocalRepository {
  Future<List<PriceObservation>> getAll();

  Future<PriceObservation?> getById(String id);

  Future<void> save(PriceObservation observation);

  Future<void> delete(String id);

  /// Reactive read — current values, then re-emits on every box mutation.
  Stream<List<PriceObservation>> watchAll();
}
