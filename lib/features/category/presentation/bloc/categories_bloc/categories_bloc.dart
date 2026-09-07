import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/category/category.dart';
import '../../../domain/repositories/i_category_local_repository.dart';

part 'categories_event.dart';

part 'categories_state.dart';

part 'categories_state_ext.dart';

part 'categories_bloc.freezed.dart';

/// App-lifetime bloc (design_spendlens.md §5: `registerLazySingleton`,
/// dispatched once from `main()` — never re-dispatched from a screen's
/// `initState`, per BLoC rule A3.8).
///
/// Reactive, not static (hive_rules.md §6): subscribes to
/// [ICategoryLocalRepository.watchAll] via `emit.forEach` so a category added/
/// edited/deleted from any screen is reflected here without a re-dispatch.
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final ICategoryLocalRepository _categoryLocalRepository;

  CategoriesBloc({required this._categoryLocalRepository})
    : super(const CategoriesState()) {
    on<_Watch>(_onWatch);
  }

  Future<void> _onWatch(_Watch event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(status: ECategoriesStatus.loading));

    await emit.forEach<List<Category>>(
      _categoryLocalRepository.watchAll(),
      onData: (categories) => state.copyWith(
        status: ECategoriesStatus.loaded,
        categories: categories,
      ),
      onError: (error, stackTrace) => state.copyWith(
        status: ECategoriesStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }
}
