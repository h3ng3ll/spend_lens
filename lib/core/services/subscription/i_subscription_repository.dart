import '../../../features/subscription/domain/models/e_subscription_plan.dart';

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

  /// Presents the SDK's paywall, returning whether the user ended up
  /// entitled.
  ///
  /// Lives behind this interface so the presentation layer never touches the
  /// SDK directly: the widget knows "upgrade", not which vendor or which
  /// placement identifier. Returns false — never throws — when the SDK is
  /// unconfigured, no paywall is set up, or the user dismisses it, so a
  /// failed purchase can never surface as an app error.
  Future<bool> presentPaywall();

  /// Whether the SDK actually started (a non-empty API key was supplied).
  /// The Settings/Profile screens use this to decide whether to even
  /// attempt a premium check, rather than silently treating "unconfigured"
  /// and "checked and not premium" as the same thing in their own logic.
  bool get isConfigured;

  /// Purchases the product backing [plan], returning whether the user ended
  /// up entitled.
  ///
  /// Distinct from [presentPaywall]: that hands the whole selection UI to
  /// the SDK, whereas this is the in-app upgrade sheet's path, where the
  /// user has ALREADY chosen a billing period and the app only needs the
  /// purchase executed.
  ///
  /// Same error contract as everything else here — returns false, never
  /// throws, when the SDK is unconfigured, the product is missing, or the
  /// user cancels. A purchase that did not happen is not an app error.
  Future<bool> purchasePlan(ESubscriptionPlan plan);

  /// Restores a previously-purchased entitlement, returning whether the
  /// user ended up entitled. Required by App Review for any app selling a
  /// subscription; same never-throws contract as [purchasePlan].
  Future<bool> restorePurchases();
}
