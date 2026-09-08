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

  /// Resolves capability and, when the OS still considers camera permission
  /// ASKABLE, prompts for it exactly once before deciding. This is what a
  /// user-initiated "start scanning" gesture should call — [check] alone can
  /// only ever report a denial it never gave the user a chance to resolve.
  ///
  /// "Exactly once" is a property of the OS, not of a flag this app keeps:
  /// iOS prompts only from `AVAuthorizationStatusNotDetermined` and is inert
  /// afterwards, and Android's `shouldShowRequestPermissionRationale`
  /// bookkeeping decides when a request can still surface a dialog. So no
  /// `hasRequested` field is persisted anywhere — one would inevitably drift
  /// from real OS state (the user can grant or revoke from Settings while the
  /// app is backgrounded), which is the same reason [check] must never be
  /// memoized.
  Future<EScanCapability> checkOrRequest();

  /// Opens the OS-level app settings screen — the only recovery path from
  /// [EScanCapability.permissionPermanentlyDenied].
  Future<void> openAppSettings();
}
