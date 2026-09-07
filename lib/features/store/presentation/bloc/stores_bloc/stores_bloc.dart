import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/store/store.dart';
import '../../../domain/repositories/i_store_local_repository.dart';

part 'stores_event.dart';

part 'stores_state.dart';

part 'stores_state_ext.dart';

part 'stores_bloc.freezed.dart';

/// App-lifetime bloc (design_spendlens.md §5: `registerLazySingleton`,
/// dispatched once from `main()` — never re-dispatched from a screen's
/// `initState`, per BLoC rule A3.8).
///
/// Reactive, not static (hive_rules.md §6): subscribes to
/// [IStoreLocalRepository.watchAll] via `emit.forEach` — a store created via
/// "New store", or resolved automatically by the receipt parser (M8), is
/// reflected here without a re-dispatch.
class StoresBloc extends Bloc<StoresEvent, StoresState> {
  final IStoreLocalRepository _storeLocalRepository;

  StoresBloc({required this._storeLocalRepository})
    : super(const StoresState()) {
    on<_Watch>(_onWatch);
  }

  Future<void> _onWatch(_Watch event, Emitter<StoresState> emit) async {
    emit(state.copyWith(status: EStoresStatus.loading));

    await emit.forEach<List<Store>>(
      _storeLocalRepository.watchAll(),
      onData: (stores) =>
          state.copyWith(status: EStoresStatus.loaded, stores: stores),
      onError: (error, stackTrace) => state.copyWith(
        status: EStoresStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }
}
