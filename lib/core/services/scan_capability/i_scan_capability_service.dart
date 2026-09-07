import 'e_scan_capability.dart';

/// Lives in `core/services/` (not a feature) because TWO unrelated
/// consumers read it (design_spendlens.md §6): the Home screen's "Scan
/// Receipt" button (tapping it when not [EScanCapability.supported] shows a
/// per-state toast and never navigates) and the Settings screen's scanning
/// status row (states the status directly, with an "Open Settings" action
/// on [EScanCapability.permissionPermanentlyDenied]).
///
/// Both consumers MUST read this ONE source rather than deriving capability
/// themselves — otherwise the two surfaces can disagree about whether
/// scanning works.
abstract interface class IScanCapabilityService {
  /// Resolves the current capability. Never memoized by the caller across
  /// app lifecycle events — permission state and camera availability can
  /// both change while the app is backgrounded (the user grants/revokes
  /// camera access from OS Settings), so every read re-checks.
  Future<EScanCapability> check();

  /// Requests camera permission if it has not been requested yet (or was
  /// denied but not permanently). Returns the resulting capability so the
  /// caller can react without a second [check] round-trip.
  Future<EScanCapability> requestPermission();

  /// Opens the OS-level app settings screen — the only recovery path from
  /// [EScanCapability.permissionPermanentlyDenied].
  Future<void> openAppSettings();
}
