part of 'scanner_bloc.dart';

/// M7/M8 add `detected(bounds)` / `capture()` / `processingStepCompleted()` /
/// `failed()` here, driven by the native OCR channel and the parser
/// pipeline. M4 has only the reset intent — enough to prove the bloc
/// resolves and the 4-state enum shape is correct.
@freezed
sealed class ScannerEvent with _$ScannerEvent {
  const factory ScannerEvent.reset() = _Reset;
}
