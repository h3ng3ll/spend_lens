import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanner_event.dart';

part 'scanner_state.dart';

part 'scanner_state_ext.dart';

part 'scanner_bloc.freezed.dart';

/// Screen-scoped bloc (design_spendlens.md §5: `registerFactory`, built in
/// `ScannerPage.initState`, closed in `dispose` — never `main()`, per BLoC
/// rule A3.8).
///
/// Drives the scanner's four sub-states as ONE route
/// (design_spendlens.md §5 — `EScannerStatus {searching, detected,
/// capturing, processing, failed}`). M4 ships the state machine's shape
/// only; the real transitions (detector bounds → `_onDetected`, shutter tap
/// → `_onCapture`, each OCR/parse/normalize/price-lookup stage completing →
/// `_onProcessingStep`) are wired to the native channel and the parser at
/// M7/M8 (design_spendlens.md §8 — the prototype's fixed timer chain is a
/// SIMULATION, never behavior to port).
class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc() : super(const ScannerState()) {
    on<_Reset>(_onReset);
  }

  void _onReset(_Reset event, Emitter<ScannerState> emit) {
    emit(const ScannerState());
  }
}
