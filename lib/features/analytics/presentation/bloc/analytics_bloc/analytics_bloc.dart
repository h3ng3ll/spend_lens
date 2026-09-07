import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../expense/domain/models/expense/expense.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';

part 'analytics_event.dart';

part 'analytics_state.dart';

part 'analytics_state_ext.dart';

part 'analytics_bloc.freezed.dart';

/// Screen-scoped bloc (design_spendlens.md §5: `registerFactory`, built in
/// `AnalyticsPage.initState`, closed in `dispose` — never `main()`, per BLoC
/// rule A3.8).
///
/// Reactive, not static (hive_rules.md §6): subscribes to
/// [IExpenseLocalRepository.watchAll] — Expenses are computed FROM, never
/// stored as the source of truth for anything else (spec §49). The real
/// calculator/insight generator (M6) consume this same stream; M4 only
/// proves the wiring.
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final IExpenseLocalRepository _expenseLocalRepository;

  AnalyticsBloc({required this._expenseLocalRepository})
    : super(const AnalyticsState()) {
    on<_Watch>(_onWatch);
  }

  Future<void> _onWatch(_Watch event, Emitter<AnalyticsState> emit) async {
    emit(state.copyWith(status: EAnalyticsStatus.loading));

    await emit.forEach<List<Expense>>(
      _expenseLocalRepository.watchAll(),
      onData: (expenses) =>
          state.copyWith(status: EAnalyticsStatus.loaded, expenses: expenses),
      onError: (error, stackTrace) => state.copyWith(
        status: EAnalyticsStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }
}
