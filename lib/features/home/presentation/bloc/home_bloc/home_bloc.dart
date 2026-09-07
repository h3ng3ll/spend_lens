import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/combine_latest_streams.dart';
import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../domain/models/home_snapshot.dart';

part 'home_event.dart';

part 'home_state.dart';

part 'home_state_ext.dart';

part 'home_bloc.freezed.dart';

/// Screen-scoped bloc (design_spendlens.md §5: `registerFactory`, built in
/// `HomePage.initState`, closed in `dispose` — never `main()`, per BLoC rule
/// A3.8).
///
/// Reactive, not static (hive_rules.md §6/§10): combines expenses +
/// categories into ONE [HomeSnapshot] stream via `combineLatest2` and
/// subscribes with a SINGLE `emit.forEach` — never parallel `emit.forEach`
/// calls, never a Dart record type for the combined value.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IExpenseLocalRepository _expenseLocalRepository;
  final ICategoryLocalRepository _categoryLocalRepository;

  HomeBloc({
    required this._expenseLocalRepository,
    required this._categoryLocalRepository,
  }) : super(const HomeState()) {
    on<_Watch>(_onWatch);
  }

  Future<void> _onWatch(_Watch event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: EHomeStatus.loading));

    await emit.forEach<HomeSnapshot>(
      combineLatest2(
        _expenseLocalRepository.watchAll(),
        _categoryLocalRepository.watchAll(),
        (expenses, categories) =>
            HomeSnapshot(expenses: expenses, categories: categories),
      ),
      onData: (snapshot) =>
          state.copyWith(status: EHomeStatus.ready, snapshot: snapshot),
      onError: (error, stackTrace) => state.copyWith(
        status: EHomeStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }
}
