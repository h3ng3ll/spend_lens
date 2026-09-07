part of 'categories_bloc.dart';

enum ECategoriesStatus { initial, loading, loaded, failed }

@freezed
sealed class CategoriesState with _$CategoriesState {
  const factory CategoriesState({
    @Default(ECategoriesStatus.initial) ECategoriesStatus status,
    @Default(<Category>[]) List<Category> categories,
    @Default('') String errorMessage,

    /// The id of the category most recently created by [CategoriesEvent.quickCreate].
    /// A one-shot signal a `BlocListener` consumes to pop the picker screen
    /// with the new id — never read to derive displayed state.
    String? lastCreatedId,

    /// Whether the most recent write (quickCreate/rename/delete) failed.
    /// A one-shot signal for an error-toast listener — never read to derive
    /// displayed state.
    @Default(false) bool lastWriteFailed,
  }) = _CategoriesState;
}
