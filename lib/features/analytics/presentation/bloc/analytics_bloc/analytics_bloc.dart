import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/combine_latest_streams.dart';
import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/models/analytics_snapshot.dart';

part 'analytics_event.dart';

part 'analytics_state.dart';

part 'analytics_state_ext.dart';

part 'analytics_bloc.freezed.dart';

/// Screen-scoped bloc (design_spendlens.md §5: `registerFactory`, built in
/// `AnalyticsPage.initState`, closed in `dispose` — never `main()`, per BLoC
/// rule A3.8).
///
/// Reactive, not static (hive_rules.md §6/§10): combines expenses +
/// categories + stores into ONE [AnalyticsSnapshot] stream via
/// `combineLatest3` and
/// subscribes with a SINGLE `emit.forEach` — never parallel `emit.forEach`
/// calls, never a Dart record type for the combined value. Follows the
/// exact shape `HomeBloc` established. Expenses/Categories are computed
/// FROM here, never stored as the source of truth for anything else (spec
/// §49). The M5 screen computes simple aggregates (sums, counts, shares)
/// directly from this raw snapshot via plain functions — the deterministic
/// calculator + parameterized insight generator are M6.
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final IExpenseLocalRepository _expenseLocalRepository;
  final ICategoryLocalRepository _categoryLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;

  AnalyticsBloc({
    required this._expenseLocalRepository,
    required this._categoryLocalRepository,
    required this._storeLocalRepository,
  }) : super(const AnalyticsState()) {
    on<_Watch>(_onWatch);
  }

  Future<void> _onWatch(_Watch event, Emitter<AnalyticsState> emit) async {
    emit(state.copyWith(status: EAnalyticsStatus.loading));

    await emit.forEach<AnalyticsSnapshot>(
      combineLatest3(
        _expenseLocalRepository.watchAll(),
        _categoryLocalRepository.watchAll(),
        _storeLocalRepository.watchAll(),
        (expenses, categories, stores) => AnalyticsSnapshot(
          expenses: expenses,
          categories: categories,
          stores: stores,
        ),
      ),
      onData: (snapshot) =>
          state.copyWith(status: EAnalyticsStatus.loaded, snapshot: snapshot),
      onError: (error, stackTrace) => state.copyWith(
        status: EAnalyticsStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }
}
