part of 'scanner_bloc.dart';

/// The scanner's sub-states (design_spendlens.md §5), all one route.
/// `ready` is the pipeline's successful terminal step — a usable
/// [ParsedReceipt] was produced and stashed on [PendingReceiptDraftStore];
/// the UI (which alone holds a [BuildContext]) reacts to it via a
/// `BlocListener` to navigate to `ReviewPageRoute`, since navigation is a
/// UI concern the bloc cannot perform itself.
enum EScannerStatus {
  searching,
  detected,
  capturing,
  processing,
  failed,
  ready,
}

@freezed
sealed class ScannerState with _$ScannerState {
  const factory ScannerState({
    @Default(EScannerStatus.searching) EScannerStatus status,

    /// The detector's last real bounding box, painted as the corner overlay.
    /// `null` while [status] is `searching` (nothing found yet).
    Rect? detectedBounds,

    /// Which of the 4 processing steps has COMPLETED (0..4). The UI reads
    /// this to render each step row as done / in-progress / pending — never
    /// a fake percentage, since [design_spendlens.md §8] the four labels
    /// report genuine pipeline progress.
    @Default(0) int processingStep,

    @Default('') String errorMessage,
  }) = _ScannerState;
}
