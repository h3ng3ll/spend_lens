part of 'compare_bloc.dart';

@freezed
sealed class CompareEvent with _$CompareEvent {
  const factory CompareEvent.watch() = _Watch;

  const factory CompareEvent.selectLeftStore(String storeId) = _SelectLeft;

  const factory CompareEvent.selectRightStore(String storeId) = _SelectRight;
}
