part of 'store_detail_bloc.dart';

enum EStoreDetailStatus { initial, loading, ready, notFound, failed }

@freezed
sealed class StoreDetailState with _$StoreDetailState {
  const factory StoreDetailState({
    @Default(EStoreDetailStatus.initial) EStoreDetailStatus status,
    StoreDetailSnapshot? snapshot,
    @Default('') String errorMessage,
  }) = _StoreDetailState;
}
