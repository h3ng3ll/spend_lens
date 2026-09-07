import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../logger_service.dart';
import '../../utils/env/env.dart';

/// How long `GoogleSignIn.initialize` may take before this service gives
/// up on it. `main()` awaits `initAuthFeature()` → `init(env)` → this call
/// BEFORE `runApp`, the exact same unbounded-native-await-before-first-
/// frame shape as `Apphud.start`
/// (`sig:unbounded-third-party-sdk-await-before-runapp-hangs-first-frame`)
/// — a plugin channel call this Dart code cannot otherwise cap must never
/// be allowed to block launch indefinitely.
const Duration _kInitializeTimeout = Duration(seconds: 5);

/// Thin wrapper around `google_sign_in`'s singleton `GoogleSignIn.instance`,
/// exposing the one ID token stream `FirebaseAuthRepository` needs
/// (design_spendlens.md §9).
///
/// **Bug 1 fixed here.** The reference template
/// (`sinergy_hub/lib/core/services/google_sign_in_service/src/
/// google_sign_in_service_mobile.dart`) called `initialize(serverClientId:
/// env.webPushCertificate())` — a Firebase Cloud Messaging web-push VAPID
/// key, entirely unrelated to OAuth. `Env.googleServerClientId` (`.env`'s
/// `GOOGLE_SERVER_CLIENT_ID`) is the correct value: the OAuth 2.0 **web**
/// client id from the same Google Cloud project as the Firebase project,
/// required on BOTH Android and iOS per the `google_sign_in` v7 API even
/// though it is a "web" client id (it is what lets Firebase verify the
/// token servers-side).
///
/// This app is iOS/Android only (design_spendlens.md binding decision 5),
/// so unlike the template there is no `src/google_sign_in_service_web.dart`
/// conditional-import split — that complexity only exists to support a web
/// target this app does not have.
class GoogleSignInService {
  final GoogleSignIn _googleSignIn;
  final LoggerService _loggerService;
  bool _initialized = false;

  GoogleSignInService({
    required GoogleSignIn googleSignIn,
    required LoggerService loggerService,
  }) : this._(googleSignIn, loggerService);

  GoogleSignInService._(this._googleSignIn, this._loggerService);

  /// Idempotent — `google_sign_in`'s `initialize()` is itself
  /// re-entrant-safe, but this guard avoids re-attaching a second listener
  /// to `authenticationEvents` (this service, not the caller, owns that
  /// subscription's lifetime).
  Future<void> init(Env env) async {
    if (_initialized) return;

    if (env.googleServerClientId.isEmpty) {
      // No credential configured — degrade gracefully rather than crash.
      // `signInWithGoogle()` on the auth repository checks this same
      // emptiness and reports a Failure with honest copy instead of
      // reaching this uninitialized client at all.
      _loggerService.info(
        'GoogleSignInService: GOOGLE_SERVER_CLIENT_ID is empty — '
        'Google sign-in is disabled until .env is configured.',
      );
      return;
    }

    try {
      await _googleSignIn
          .initialize(serverClientId: env.googleServerClientId)
          .timeout(_kInitializeTimeout);
      _initialized = true;
    } on TimeoutException {
      _loggerService.warning(
        'GoogleSignInService.init did not complete within '
        '${_kInitializeTimeout.inSeconds}s — treating Google sign-in as '
        'disabled.',
      );
    } catch (e) {
      if (kDebugMode) {
        _loggerService.warning('GoogleSignInService.init failed: $e');
      }
    }
  }

  bool get isConfigured => _initialized;

  Future<GoogleSignInAccount> authenticate() => _googleSignIn.authenticate();

  Future<void> signOut() async {
    if (!_initialized) return;
    await _googleSignIn.disconnect();
  }
}
