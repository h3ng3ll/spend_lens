import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/combine_latest_streams.dart';
import '../../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../domain/models/store/store.dart';
import '../../../domain/models/store_detail_snapshot/store_detail_snapshot.dart';
import '../../../domain/repositories/i_store_local_repository.dart';

part 'store_detail_event.dart';

part 'store_detail_state.dart';

part 'store_detail_state_ext.dart';

part 'store_detail_bloc.freezed.dart';

/// Screen-scoped bloc (`registerFactory` semantics: built in
/// `StoreDetailPage.initState`, closed in `dispose` — never `main()`, per
/// BLoC rule A3.8), taking [storeId] as a constructor param.
///
/// Reactive, not static (hive_rules.md §6/§10): combines the store list
/// (resolving THIS store by id) + all expenses into ONE
/// [StoreDetailSnapshot] stream via `combineLatest2` and subscribes with a
/// SINGLE `emit.forEach` — never parallel `emit.forEach` calls, never a Dart
/// record type for the combined value. "Expenses for this store" and the
/// visit-count/spent-this-month figures are plain functions over the
/// snapshot, computed in the widget layer — never stored as derived state
/// (BLoC rule A3.1).
class StoreDetailBloc extends Bloc<StoreDetailEvent, StoreDetailState> {
  final IStoreLocalRepository _storeLocalRepository;
  final IExpenseLocalRepository _expenseLocalRepository;
  final IProductLocalRepository _productLocalRepository;
  final IPriceObservationLocalRepository _priceObservationLocalRepository;
  final String storeId;

  StoreDetailBloc({
    required this.storeId,
    required this._storeLocalRepository,
    required this._expenseLocalRepository,
    required this._productLocalRepository,
    required this._priceObservationLocalRepository,
  }) : super(const StoreDetailState()) {
    on<_Watch>(_onWatch);
  }

  Future<void> _onWatch(_Watch event, Emitter<StoreDetailState> emit) async {
    emit(state.copyWith(status: EStoreDetailStatus.loading));

    await emit.forEach<StoreDetailSnapshot>(
      combineLatest4(
        _storeLocalRepository.watchAll(),
        _expenseLocalRepository.watchAll(),
        _productLocalRepository.watchAll(),
        _priceObservationLocalRepository.watchAll(),
        (stores, expenses, products, priceObservations) => StoreDetailSnapshot(
          store: _findStore(stores, storeId),
          expenses: expenses,
          products: products,
          priceObservations: priceObservations,
          stores: stores,
        ),
      ),
      onData: (snapshot) => snapshot.store == null
          ? state.copyWith(status: EStoreDetailStatus.notFound)
          : state.copyWith(
              status: EStoreDetailStatus.ready,
              snapshot: snapshot,
            ),
      onError: (error, stackTrace) => state.copyWith(
        status: EStoreDetailStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }

  Store? _findStore(List<Store> stores, String id) {
    for (final store in stores) {
      if (store.id == id) return store;
    }
    return null;
  }
}
