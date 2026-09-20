import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/combine_latest_streams.dart';
import '../../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/models/compare_snapshot/compare_snapshot.dart';

part 'compare_event.dart';

part 'compare_state.dart';

part 'compare_state_ext.dart';

part 'compare_bloc.freezed.dart';

/// Screen-scoped bloc (`registerFactory` semantics: built in
/// `ComparePage.initState`, closed in `dispose` — never `main()`, per BLoC
/// rule A3.8).
///
/// Reactive, not static (hive_rules.md §6/§10): combines stores + products +
/// price observations into ONE [CompareSnapshot] stream via `combineLatest3`
/// and subscribes with a SINGLE `emit.forEach`.
class CompareBloc extends Bloc<CompareEvent, CompareState> {
  final IStoreLocalRepository _storeLocalRepository;
  final IProductLocalRepository _productLocalRepository;
  final IPriceObservationLocalRepository _priceObservationLocalRepository;

  CompareBloc({
    required this._storeLocalRepository,
    required this._productLocalRepository,
    required this._priceObservationLocalRepository,
  }) : super(const CompareState()) {
    on<_Watch>(_onWatch);
    on<_SelectLeft>(_onSelectLeft);
    on<_SelectRight>(_onSelectRight);
  }

  Future<void> _onWatch(_Watch event, Emitter<CompareState> emit) async {
    emit(state.copyWith(status: ECompareStatus.loading));

    await emit.forEach<CompareSnapshot>(
      combineLatest3(
        _storeLocalRepository.watchAll(),
        _productLocalRepository.watchAll(),
        _priceObservationLocalRepository.watchAll(),
        (stores, products, observations) => CompareSnapshot(
          stores: stores,
          products: products,
          observations: observations,
        ),
      ),
      onData: (snapshot) {
        // Seeded ONCE, on the first emission that can support a comparison,
        // so the screen opens on something real rather than two empty
        // pickers. Done here rather than by add()-ing from a listener —
        // dispatching from inside a handler is forbidden.
        final left = state.leftStoreId ?? _storeAt(snapshot, 0);
        final right = state.rightStoreId ?? _storeAt(snapshot, 1);

        return state.copyWith(
          status: ECompareStatus.ready,
          snapshot: snapshot,
          leftStoreId: left,
          rightStoreId: right,
        );
      },
      onError: (error, stackTrace) => state.copyWith(
        status: ECompareStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }

  void _onSelectLeft(_SelectLeft event, Emitter<CompareState> emit) {
    emit(state.copyWith(leftStoreId: event.storeId));
  }

  void _onSelectRight(_SelectRight event, Emitter<CompareState> emit) {
    emit(state.copyWith(rightStoreId: event.storeId));
  }

  String? _storeAt(CompareSnapshot snapshot, int index) {
    if (snapshot.stores.length <= index) return null;
    return snapshot.stores[index].id;
  }
}
