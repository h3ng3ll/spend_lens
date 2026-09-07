import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/combine_latest_streams.dart';
import '../../../../product/domain/models/product/product.dart';
import '../../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/models/price_history_snapshot/price_history_snapshot.dart';
import '../../../domain/repositories/i_price_observation_local_repository.dart';

part 'price_history_event.dart';

part 'price_history_state.dart';

part 'price_history_state_ext.dart';

part 'price_history_bloc.freezed.dart';

/// Screen-scoped bloc (`registerFactory` semantics: built in
/// `PriceHistoryPage.initState`, closed in `dispose` — never `main()`, per
/// BLoC rule A3.8), taking [productId] as a constructor param.
///
/// Reactive, not static (hive_rules.md §6/§10): combines products +
/// price observations + stores into ONE [PriceHistorySnapshot] stream via
/// `combineLatest3` and subscribes with a SINGLE `emit.forEach`.
///
/// "No observations for this product yet" is `EPriceHistoryStatus.empty` —
/// distinct from `failed` (recorded chronic bug
/// `absent-data-mapped-to-failed-status-first-launch-shows-something-went-
/// wrong`: absent data is never an error). "Product record itself is gone"
/// is `notFound`, distinct from both.
class PriceHistoryBloc extends Bloc<PriceHistoryEvent, PriceHistoryState> {
  final String productId;
  final IProductLocalRepository _productLocalRepository;
  final IPriceObservationLocalRepository _priceObservationLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;

  PriceHistoryBloc({
    required this.productId,
    required this._productLocalRepository,
    required this._priceObservationLocalRepository,
    required this._storeLocalRepository,
  }) : super(const PriceHistoryState()) {
    on<_Watch>(_onWatch);
  }

  Future<void> _onWatch(
    _Watch event,
    Emitter<PriceHistoryState> emit,
  ) async {
    emit(state.copyWith(status: EPriceHistoryStatus.loading));

    await emit.forEach<PriceHistorySnapshot>(
      combineLatest3(
        _productLocalRepository.watchAll(),
        _priceObservationLocalRepository.watchAll(),
        _storeLocalRepository.watchAll(),
        (products, observations, stores) => PriceHistorySnapshot(
          product: _findProduct(products, productId),
          observations: observations,
          stores: stores,
        ),
      ),
      onData: (snapshot) {
        if (snapshot.product == null) {
          return state.copyWith(status: EPriceHistoryStatus.notFound);
        }
        final hasObservations = snapshot.observations.any(
          (observation) =>
              observation.productId == productId &&
              observation.deletedAt == null,
        );
        return state.copyWith(
          status: hasObservations
              ? EPriceHistoryStatus.ready
              : EPriceHistoryStatus.empty,
          snapshot: snapshot,
        );
      },
      onError: (error, stackTrace) => state.copyWith(
        status: EPriceHistoryStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }

  Product? _findProduct(List<Product> products, String id) {
    for (final product in products) {
      if (product.id == id) return product;
    }
    return null;
  }
}
