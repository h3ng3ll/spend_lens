import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/combine_latest_streams.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../domain/models/store_page_snapshot/store_page_snapshot.dart';
import '../../../domain/repositories/i_store_local_repository.dart';

part 'store_page_event.dart';

part 'store_page_state.dart';

part 'store_page_state_ext.dart';

part 'store_page_bloc.freezed.dart';

/// Screen-scoped bloc (`registerFactory` semantics: built in
/// `StorePage.initState`, closed in `dispose` — never `main()`, per BLoC rule
/// A3.8). The canonical, app-lifetime `StoresBloc` stays the reactive source
/// for the Stores list's raw store data; this bloc exists ONLY so the
/// Stores list screen can additionally react to [IExpenseLocalRepository]
/// for the per-store visit-count / spent-this-month figures the design
/// requires, without turning that derivation into filtered/derived STATE
/// (BLoC rule A3.1) — the combined snapshot is stored, and every per-store
/// number is a pure function computed in the widget layer.
///
/// Reactive, not static (hive_rules.md §6/§10): combines stores + expenses
/// into ONE [StorePageSnapshot] stream via `combineLatest2` and subscribes
/// with a SINGLE `emit.forEach` — never parallel `emit.forEach` calls, never
/// a Dart record type for the combined value.
class StorePageBloc extends Bloc<StorePageEvent, StorePageState> {
  final IStoreLocalRepository _storeLocalRepository;
  final IExpenseLocalRepository _expenseLocalRepository;

  StorePageBloc({
    required this._storeLocalRepository,
    required this._expenseLocalRepository,
  }) : super(const StorePageState()) {
    on<_Watch>(_onWatch);
  }

  Future<void> _onWatch(_Watch event, Emitter<StorePageState> emit) async {
    emit(state.copyWith(status: EStorePageStatus.loading));

    await emit.forEach<StorePageSnapshot>(
      combineLatest2(
        _storeLocalRepository.watchAll(),
        _expenseLocalRepository.watchAll(),
        (stores, expenses) =>
            StorePageSnapshot(stores: stores, expenses: expenses),
      ),
      onData: (snapshot) =>
          state.copyWith(status: EStorePageStatus.ready, snapshot: snapshot),
      onError: (error, stackTrace) => state.copyWith(
        status: EStorePageStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }
}
