/// Premium-entitlement contract (design_spendlens.md §6/§9 — `Apphud only`,
/// no custom StoreKit).
///
/// [hasPremiumAccess] is a one-shot check, not a stream: entitlement state
/// only changes after a purchase/restore action the UI itself just
/// performed (or on app relaunch), so there is no independent background
/// mutation for a Bloc to subscribe to the way it would `watchAll()` a Hive
/// box (hive_rules.md §9 governs Hive-backed reactive data, not a
/// third-party SDK's cached entitlement flag).
abstract interface class ISubscriptionRepository {
  /// `true` once the SDK has started successfully AND the entitlement
  /// check itself succeeded. `false` — never a thrown exception — when the
  /// SDK is unconfigured (no API key) or the check fails for any reason:
  /// an absent/failed entitlement check must read as "not premium", never
  /// surface as an app error (recorded global bug
  /// `absent-data-mapped-to-failed-status-first-launch-shows-something-
  /// went-wrong`).
  Future<bool> hasPremiumAccess();

  /// Whether the SDK actually started (a non-empty API key was supplied).
  /// The Settings/Profile screens use this to decide whether to even
  /// attempt a premium check, rather than silently treating "unconfigured"
  /// and "checked and not premium" as the same thing in their own logic.
  bool get isConfigured;
}
