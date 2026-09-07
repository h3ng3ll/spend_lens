part of 'scanner_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension ScannerStateX on ScannerState {
  bool get isSearching => status == EScannerStatus.searching;

  bool get isDetected => status == EScannerStatus.detected;

  bool get isCapturing => status == EScannerStatus.capturing;

  bool get isProcessing => status == EScannerStatus.processing;

  bool get isFailed => status == EScannerStatus.failed;

  bool get isReady => status == EScannerStatus.ready;

  /// True for every in-progress phase — the minimum `isLoading` contract
  /// (A3 rule 9) mapped onto this bloc's multi-phase status enum, which has
  /// no single generic "loading" value of its own.
  bool get isLoading =>
      status == EScannerStatus.searching ||
      status == EScannerStatus.detected ||
      status == EScannerStatus.capturing ||
      status == EScannerStatus.processing;
}
