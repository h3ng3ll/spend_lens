part of 'price_history_bloc.dart';

enum EPriceHistoryStatus { initial, loading, ready, empty, notFound, failed }

@freezed
sealed class PriceHistoryState with _$PriceHistoryState {
  const factory PriceHistoryState({
    @Default(EPriceHistoryStatus.initial) EPriceHistoryStatus status,
    PriceHistorySnapshot? snapshot,
    @Default('') String errorMessage,
  }) = _PriceHistoryState;
}
