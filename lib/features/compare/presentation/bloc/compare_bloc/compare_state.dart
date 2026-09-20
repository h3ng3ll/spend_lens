part of 'compare_bloc.dart';

enum ECompareStatus { initial, loading, ready, failed }

@freezed
sealed class CompareState with _$CompareState {
  const factory CompareState({
    @Default(ECompareStatus.initial) ECompareStatus status,
    CompareSnapshot? snapshot,

    /// The two stores being compared. These are USER SELECTIONS, not derived
    /// data, so they are legitimate state — unlike the per-column product
    /// lists, which are recomputed in the widget layer.
    String? leftStoreId,
    String? rightStoreId,
    @Default('') String errorMessage,
  }) = _CompareState;
}
