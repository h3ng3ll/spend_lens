import 'dart:async';
import 'package:apphud/apphud.dart';

import '../logger_service.dart';
import '../../utils/env/env.dart';
import 'i_subscription_repository.dart';

/// [ISubscriptionRepository] backed by the Apphud SDK
/// (design_spendlens.md §6/§9 — `apphud` 3.4.0 is the official SDK, so no
/// custom StoreKit).
///
/// **A missing API key is a disabled feature, never a crash.** `Apphud
/// .start(apiKey:)` requires a non-empty key; with no `.env` value supplied
/// yet (the user fills it in later — see this project's credential policy)
/// this repository never calls `start()` at all, and [hasPremiumAccess]
/// short-circuits to `false` without touching the native channel.
/// How long `Apphud.start` may take before the app gives up on it. Launch
/// must never depend on a reachable subscription backend.
const Duration _kStartTimeout = Duration(seconds: 5);

/// How long `Apphud.hasPremiumAccess()` may take before this repository
/// gives up on it. Lower risk than [_kStartTimeout] — this call is guarded
/// by [_started] and already falls back to `false` on any thrown error —
/// but it is the SAME unbounded-native-await shape as every other site in
/// this class, so it gets the same bound rather than being the one call
/// left unguarded.
const Duration _kPremiumCheckTimeout = Duration(seconds: 5);

/// How long fetching placements / showing the paywall may take. Longer than
/// the entitlement check because it is a user-initiated, visible action, but
/// still BOUNDED for the same reason: an unreachable backend must not leave
/// the tap hanging with no feedback.
const Duration _kPaywallTimeout = Duration(seconds: 20);

class ApphudSubscriptionRepository implements ISubscriptionRepository {
  final LoggerService _loggerService;
  bool _started = false;

  ApphudSubscriptionRepository({required LoggerService loggerService})
    : this._(loggerService);

  ApphudSubscriptionRepository._(this._loggerService);

  Future<void> init(Env env) async {
    if (env.apphudApiKey.isEmpty) {
      _loggerService.info(
        'ApphudSubscriptionRepository: APPHUD_API_KEY is empty — '
        'subscription checks are disabled until .env is configured.',
      );
      return;
    }

    try {
      // BOUNDED, and that bound is load-bearing: `Apphud.start` does NOT
      // complete when the key is syntactically valid but rejected (a
      // placeholder key answers 401 and the SDK's future never settles).
      // `main()` awaits this before `runApp`, so an unbounded await hangs
      // the app on the native splash forever with a clean logcat — observed
      // on a real device, not hypothesised. A third-party SDK may never
      // gate the first frame.
      await Apphud.start(apiKey: env.apphudApiKey).timeout(_kStartTimeout);
      _started = true;
    } on TimeoutException {
      _loggerService.warning(
        'Apphud.start did not complete within '
        '${_kStartTimeout.inSeconds}s — treating subscriptions as disabled. '
        'This is the expected path for a placeholder APPHUD_API_KEY.',
      );
    } catch (e) {
      _loggerService.warning('Apphud.start failed: $e');
    }
  }

  /// Fetches the first placement that actually has a paywall screen and
  /// shows it.
  ///
  /// Returns false rather than throwing on every failure path — SDK not
  /// started, no placement configured, no screen attached, timeout, or the
  /// user dismissing it. A purchase that did not happen is not an app
  /// error, and the recorded bug
  /// `absent-data-mapped-to-failed-status-first-launch-shows-something-went-
  /// wrong` is exactly what surfacing it as one would reproduce.
  @override
  Future<bool> presentPaywall() async {
    if (!_started) {
      _loggerService.info(
        'ApphudSubscriptionRepository: presentPaywall skipped — SDK not '
        'started (no API key).',
      );
      return false;
    }

    try {
      final placements = await Apphud.placements().timeout(_kPaywallTimeout);

      final paywall = placements
          .map((placement) => placement.paywall)
          .nonNulls
          .where((candidate) => candidate.hasScreen)
          .firstOrNull;

      if (paywall == null) {
        // Configured in the dashboard, or it is not. Either way there is
        // nothing to present, and inventing a fallback purchase sheet here
        // would be worse than reporting nothing happened.
        _loggerService.warning(
          'ApphudSubscriptionRepository: no placement with a paywall screen.',
        );
        return false;
      }

      final result = await Apphud.showPaywall(
        paywall,
      ).timeout(_kPaywallTimeout);

      return result.success;
    } on TimeoutException {
      _loggerService.warning(
        'ApphudSubscriptionRepository: paywall did not complete within '
        '${_kPaywallTimeout.inSeconds}s.',
      );
      return false;
    } catch (error) {
      _loggerService.warning(
        'ApphudSubscriptionRepository: paywall failed: $error',
      );
      return false;
    }
  }

  @override
  bool get isConfigured => _started;

  @override
  Future<bool> hasPremiumAccess() async {
    if (!_started) return false;
    try {
      return await Apphud.hasPremiumAccess().timeout(_kPremiumCheckTimeout);
    } on TimeoutException {
      _loggerService.warning(
        'Apphud.hasPremiumAccess did not complete within '
        '${_kPremiumCheckTimeout.inSeconds}s — treating as no premium '
        'access.',
      );
      return false;
    } catch (e) {
      _loggerService.warning('Apphud.hasPremiumAccess failed: $e');
      return false;
    }
  }
}
