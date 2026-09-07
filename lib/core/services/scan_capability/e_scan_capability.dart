/// The scanner's capability state (design_spendlens.md §6).
///
/// This is a HARDWARE and PERMISSION condition, never a platform one — a
/// real Android phone reports [supported], an iOS Simulator (no physical
/// camera) reports [noCamera]. Never branch on `Platform.isX` to decide
/// this; always resolve it through [IScanCapabilityService].
enum EScanCapability {
  /// A camera exists, permission is granted (or not yet requested), and
  /// on-device OCR is available. Scanning may proceed.
  supported,

  /// The device has no usable camera (e.g. a camera-less tablet, or an iOS
  /// Simulator with no physical camera attached).
  noCamera,

  /// A camera exists, but on-device text recognition is not available.
  ocrUnavailable,

  /// Camera permission was denied but may still be requested again (the
  /// user has not permanently blocked it).
  permissionDenied,

  /// Camera permission was denied permanently ("Don't ask again" / iOS
  /// "Never Allow") — the only way forward is the OS Settings app.
  permissionPermanentlyDenied,

  /// The native capability probe (`availableCameras()` / OCR availability)
  /// did not settle within its bound. This is a REAL, surfaced state — never
  /// a silent hang — for the same reason `Apphud.start` is timeout-bound
  /// before `runApp` (`sig:unbounded-third-party-sdk-await-before-runapp-
  /// hangs-first-frame`): a plugin channel call can fail to complete on some
  /// devices/emulators with no camera HAL, and the caller must never await
  /// it unbounded.
  unavailable,
}
