part of 'history_bloc.dart';

enum EHistoryStatus { initial, loading, loaded, failed }

@freezed
sealed class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default(EHistoryStatus.initial) EHistoryStatus status,
    @Default(<Expense>[]) List<Expense> expenses,
    @Default('') String errorMessage,
  }) = _HistoryState;
}
