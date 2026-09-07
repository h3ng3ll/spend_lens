part of 'home_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension HomeStateX on HomeState {
  bool get isInitial => status == EHomeStatus.initial;

  bool get isLoading => status == EHomeStatus.loading;

  bool get isReady => status == EHomeStatus.ready;

  bool get isFailed => status == EHomeStatus.failed;
}
