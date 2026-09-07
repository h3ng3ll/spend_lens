import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/category/category.dart';
import '../../../domain/models/category/next_custom_category_color.dart';
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
///
/// Also owns every category WRITE (quick-create, rename, delete) — these
/// used to be direct `getIt<ICategoryLocalRepository>()` calls from
/// `CategoryPage`/`NewCategoryPage`, a BLoC-layer violation (UI code calling
/// a repository directly). The write path emits [lastCreatedId] once, for a
/// `BlocListener` to pop the picker/create screen with — and
/// [lastWriteFailed] on any write exception, read by an error-toast
/// listener (BLoC rule: every write surfaces both outcomes, never just the
/// happy path).
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final ICategoryLocalRepository _categoryLocalRepository;
  final DateTime Function() _now;

  CategoriesBloc({
    required this._categoryLocalRepository,
    this._now = DateTime.now,
  }) : super(const CategoriesState()) {
    on<_Watch>(_onWatch);
    on<_QuickCreate>(_onQuickCreate);
    on<_Rename>(_onRename);
    on<_Delete>(_onDelete);
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

  Future<void> _onQuickCreate(
    _QuickCreate event,
    Emitter<CategoriesState> emit,
  ) async {
    final trimmed = event.name.trim();
    if (trimmed.isEmpty) return;

    try {
      final customCount = state.categories.where((c) => !c.isBuiltIn).length;
      final now = _now();
      final category = Category(
        id: now.microsecondsSinceEpoch.toString(),
        name: trimmed,
        colorHex: nextCustomCategoryColorHex(customCount),
        isBuiltIn: false,
        updatedAt: now,
      );

      await _categoryLocalRepository.save(category);
      emit(state.copyWith(lastCreatedId: category.id, lastWriteFailed: false));
    } catch (_) {
      emit(state.copyWith(lastWriteFailed: true));
    }
  }

  Future<void> _onRename(_Rename event, Emitter<CategoriesState> emit) async {
    final trimmed = event.newName.trim();
    if (trimmed.isEmpty) return;

    try {
      final updated = event.category.copyWith(name: trimmed, updatedAt: _now());
      await _categoryLocalRepository.save(updated);
      emit(state.copyWith(lastWriteFailed: false));
    } catch (_) {
      emit(state.copyWith(lastWriteFailed: true));
    }
  }

  Future<void> _onDelete(_Delete event, Emitter<CategoriesState> emit) async {
    try {
      await _categoryLocalRepository.delete(event.categoryId);
      emit(state.copyWith(lastWriteFailed: false));
    } catch (_) {
      emit(state.copyWith(lastWriteFailed: true));
    }
  }
}
