import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/combine_latest_streams.dart';
import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/models/history_snapshot.dart';

part 'history_event.dart';

part 'history_state.dart';

part 'history_state_ext.dart';

part 'history_bloc.freezed.dart';

/// Screen-scoped bloc (design_spendlens.md §5: `registerFactory`, built in
/// `HistoryPage.initState`, closed in `dispose` — never `main()`, per BLoC
/// rule A3.8).
///
/// Reactive, not static (hive_rules.md §6/§10): combines expenses +
/// categories + stores into ONE [HistorySnapshot] stream via
/// `combineLatest3` and subscribes with a SINGLE `emit.forEach` — never
/// parallel `emit.forEach` calls, never a Dart record type for the combined
/// value. Search/filter is a pure UI-side computation over
/// `state.snapshot.expenses` (BLoC rule A3.1 — never a `filteredX` field).
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final IExpenseLocalRepository _expenseLocalRepository;
  final ICategoryLocalRepository _categoryLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;

  HistoryBloc({
    required this._expenseLocalRepository,
    required this._categoryLocalRepository,
    required this._storeLocalRepository,
  }) : super(const HistoryState()) {
    on<_Watch>(_onWatch);
  }

  Future<void> _onWatch(_Watch event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(status: EHistoryStatus.loading));

    await emit.forEach<HistorySnapshot>(
      combineLatest3(
        _expenseLocalRepository.watchAll(),
        _categoryLocalRepository.watchAll(),
        _storeLocalRepository.watchAll(),
        (expenses, categories, stores) => HistorySnapshot(
          expenses: expenses,
          categories: categories,
          stores: stores,
        ),
      ),
      onData: (snapshot) =>
          state.copyWith(status: EHistoryStatus.loaded, snapshot: snapshot),
      onError: (error, stackTrace) => state.copyWith(
        status: EHistoryStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }
}
