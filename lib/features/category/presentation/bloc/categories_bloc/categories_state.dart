part of 'categories_bloc.dart';

enum ECategoriesStatus { initial, loading, loaded, failed }

@freezed
sealed class CategoriesState with _$CategoriesState {
  const factory CategoriesState({
    @Default(ECategoriesStatus.initial) ECategoriesStatus status,
    @Default(<Category>[]) List<Category> categories,
    @Default('') String errorMessage,
  }) = _CategoriesState;
}
