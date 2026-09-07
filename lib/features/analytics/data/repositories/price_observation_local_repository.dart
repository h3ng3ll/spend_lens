import '../../../../core/hive/hive_database.dart';
import '../../domain/models/price_observation/price_observation.dart';
import '../../domain/repositories/i_price_observation_local_repository.dart';

/// Hive-backed [IPriceObservationLocalRepository]. Box name is plural
/// lowercase (`'price_observations'`) per hive_rules.md §5; never cached —
/// every operation re-fetches via the shared [HiveDatabase] helper.
class PriceObservationLocalRepository
    implements IPriceObservationLocalRepository {
  static const _boxName = 'price_observations';

  final HiveDatabase _hiveDatabase;

  const PriceObservationLocalRepository(this._hiveDatabase);

  @override
  Future<List<PriceObservation>> getAll() async {
    final box = await _hiveDatabase.getBox<PriceObservation>(_boxName);
    return box.values.toList();
  }

  @override
  Future<PriceObservation?> getById(String id) async {
    final box = await _hiveDatabase.getBox<PriceObservation>(_boxName);
    return box.get(id);
  }

  @override
  Future<void> save(PriceObservation observation) async {
    final box = await _hiveDatabase.getBox<PriceObservation>(_boxName);
    await box.put(observation.id, observation);
  }

  @override
  Future<void> delete(String id) async {
    final box = await _hiveDatabase.getBox<PriceObservation>(_boxName);
    await box.delete(id);
  }

  @override
  Stream<List<PriceObservation>> watchAll() async* {
    final box = await _hiveDatabase.getBox<PriceObservation>(_boxName);
    yield box.values.toList();
    yield* box.watch().map((_) => box.values.toList());
  }
}
