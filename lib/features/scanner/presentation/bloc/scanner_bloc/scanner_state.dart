part of 'scanner_bloc.dart';

/// The scanner's four sub-states (design_spendlens.md §5), all one route.
enum EScannerStatus { searching, detected, capturing, processing, failed }

@freezed
sealed class ScannerState with _$ScannerState {
  const factory ScannerState({
    @Default(EScannerStatus.searching) EScannerStatus status,
    @Default('') String errorMessage,
  }) = _ScannerState;
}
