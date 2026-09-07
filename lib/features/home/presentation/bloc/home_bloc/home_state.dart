part of 'home_bloc.dart';

enum EHomeStatus { initial, loading, ready, failed }

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    @Default(EHomeStatus.initial) EHomeStatus status,
    HomeSnapshot? snapshot,
    @Default('') String errorMessage,
  }) = _HomeState;
}
