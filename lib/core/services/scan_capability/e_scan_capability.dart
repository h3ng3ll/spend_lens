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
}
