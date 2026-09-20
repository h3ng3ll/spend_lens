import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/store/e_store_type.dart';
import '../../../domain/models/store/store.dart';
import '../../../domain/repositories/i_store_local_repository.dart';
import '../../../domain/use_cases/delete_store_use_case.dart';

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
///
/// Also owns every store WRITE (quick-create, full create, delete) — these
/// used to be direct `getIt<IStoreLocalRepository>()` calls from
/// `ChooseStorePage`/`NewStorePage`/`StoreDeleteSection`, a BLoC-layer
/// violation. The write path emits [lastCreatedId] once, for a
/// `BlocListener` to pop the picker/create screen with — and
/// [lastWriteFailed] on any write exception, read by an error-toast
/// listener.
class StoresBloc extends Bloc<StoresEvent, StoresState> {
  final IStoreLocalRepository _storeLocalRepository;
  final DeleteStoreUseCase _deleteStore;
  final DateTime Function() _now;

  StoresBloc({
    required IStoreLocalRepository storeLocalRepository,
    required DeleteStoreUseCase deleteStore,
    DateTime Function() now = DateTime.now,
  }) : this._(storeLocalRepository, deleteStore, now);

  StoresBloc._(this._storeLocalRepository, this._deleteStore, this._now)
    : super(const StoresState()) {
    on<_Watch>(_onWatch);
    on<_QuickCreate>(_onQuickCreate);
    on<_Create>(_onCreate);
    on<_Delete>(_onDelete);
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

  Future<void> _onQuickCreate(
    _QuickCreate event,
    Emitter<StoresState> emit,
  ) async {
    final trimmed = event.name.trim();
    if (trimmed.isEmpty) return;

    try {
      final now = _now();
      final store = Store(
        id: now.microsecondsSinceEpoch.toString(),
        name: trimmed,
        type: EStoreType.other,
        updatedAt: now,
      );
      await _storeLocalRepository.save(store);
      emit(state.copyWith(lastCreatedId: store.id, lastWriteFailed: false));
    } catch (_) {
      emit(state.copyWith(lastWriteFailed: true));
    }
  }

  Future<void> _onCreate(_Create event, Emitter<StoresState> emit) async {
    final trimmedName = event.name.trim();
    if (trimmedName.isEmpty) return;

    try {
      final trimmedAlias = event.receiptAlias.trim();
      final now = _now();
      final store = Store(
        id: now.microsecondsSinceEpoch.toString(),
        name: trimmedName,
        receiptAliases: trimmedAlias.isEmpty ? const [] : [trimmedAlias],
        type: event.type,
        updatedAt: now,
      );
      await _storeLocalRepository.save(store);
      emit(state.copyWith(lastCreatedId: store.id, lastWriteFailed: false));
    } catch (_) {
      emit(state.copyWith(lastWriteFailed: true));
    }
  }

  /// Deletes the store AND every record referencing it.
  ///
  /// The cascade lives in [DeleteStoreUseCase], not here: it spans five
  /// repositories, and a bloc reaching across that many slices is the
  /// layering violation this bloc's own history already records. The user
  /// has seen the record count in the confirm dialog by the time this
  /// runs -- see `StoreDeleteSection`.
  Future<void> _onDelete(_Delete event, Emitter<StoresState> emit) async {
    try {
      await _deleteStore(event.storeId, uid: event.uid);
      emit(state.copyWith(lastWriteFailed: false));
    } catch (_) {
      emit(state.copyWith(lastWriteFailed: true));
    }
  }
}
