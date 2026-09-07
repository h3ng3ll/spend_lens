part of 'scanner_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension ScannerStateX on ScannerState {
  bool get isSearching => status == EScannerStatus.searching;

  bool get isDetected => status == EScannerStatus.detected;

  bool get isCapturing => status == EScannerStatus.capturing;

  bool get isProcessing => status == EScannerStatus.processing;

  bool get isFailed => status == EScannerStatus.failed;
}
