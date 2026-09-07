part of 'stores_bloc.dart';

enum EStoresStatus { initial, loading, loaded, failed }

@freezed
sealed class StoresState with _$StoresState {
  const factory StoresState({
    @Default(EStoresStatus.initial) EStoresStatus status,
    @Default(<Store>[]) List<Store> stores,
    @Default('') String errorMessage,
  }) = _StoresState;
}
