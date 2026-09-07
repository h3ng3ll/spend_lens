part of 'store_page_bloc.dart';

enum EStorePageStatus { initial, loading, ready, failed }

@freezed
sealed class StorePageState with _$StorePageState {
  const factory StorePageState({
    @Default(EStorePageStatus.initial) EStorePageStatus status,
    StorePageSnapshot? snapshot,
    @Default('') String errorMessage,
  }) = _StorePageState;
}
