import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../expense/domain/models/expense/expense.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';

part 'history_event.dart';

part 'history_state.dart';

part 'history_state_ext.dart';

part 'history_bloc.freezed.dart';

/// Screen-scoped bloc (design_spendlens.md §5: `registerFactory`, built in
/// `HistoryPage.initState`, closed in `dispose` — never `main()`, per BLoC
/// rule A3.8).
///
/// Reactive, not static (hive_rules.md §6): subscribes to
/// [IExpenseLocalRepository.watchAll]. M4 lists expenses only; M5 adds the
/// receipt-vs-cash record-type distinction and search/filter chips (never
/// `filteredX` state per BLoC rule A3.1 — filtering stays a UI-side view over
/// the unfiltered list).
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final IExpenseLocalRepository _expenseLocalRepository;

  HistoryBloc({required this._expenseLocalRepository})
    : super(const HistoryState()) {
    on<_Watch>(_onWatch);
  }

  Future<void> _onWatch(_Watch event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(status: EHistoryStatus.loading));

    await emit.forEach<List<Expense>>(
      _expenseLocalRepository.watchAll(),
      onData: (expenses) =>
          state.copyWith(status: EHistoryStatus.loaded, expenses: expenses),
      onError: (error, stackTrace) => state.copyWith(
        status: EHistoryStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }
}
