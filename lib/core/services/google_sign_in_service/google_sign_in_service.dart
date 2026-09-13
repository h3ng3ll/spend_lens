import 'dart:async';

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

  /// Why [init] did not leave this service usable. Empty once initialized.
  ///
  /// Kept as state because `isConfigured == false` alone is not actionable:
  /// the repository reports this reason to the user and the log instead of
  /// a generic "not configured yet", so an empty `.env` value, a timed-out
  /// plugin channel and an outright plugin throw are told apart.
  String _unconfiguredReason = 'GoogleSignInService.init() has not run yet.';

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
      _unconfiguredReason =
          'GOOGLE_SERVER_CLIENT_ID is empty in .env';
      _loggerService.warning(
        'GoogleSignInService: $_unconfiguredReason — '
        'Google sign-in is disabled until .env is configured.',
      );
      return;
    }

    try {
      await _googleSignIn
          .initialize(serverClientId: env.googleServerClientId)
          .timeout(_kInitializeTimeout);
      _initialized = true;
      _unconfiguredReason = '';
    } on TimeoutException {
      _unconfiguredReason =
          'initialize() timed out after ${_kInitializeTimeout.inSeconds}s';
      _loggerService.warning(
        'GoogleSignInService.init did not complete within '
        '${_kInitializeTimeout.inSeconds}s — treating Google sign-in as '
        'disabled.',
      );
    } catch (e, stackTrace) {
      _unconfiguredReason = 'initialize() threw: $e';
      // Logged at ERROR on every build, not just debug: a swallowed
      // initialization failure is exactly what makes the sign-in button look
      // inert with a clean log in release.
      _loggerService.error(
        'GoogleSignInService.init failed: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  bool get isConfigured => _initialized;

  /// Why this service is unusable — empty when [isConfigured] is `true`.
  String get unconfiguredReason => _unconfiguredReason;

  /// Wraps `google_sign_in`'s `authenticate()` with verbose tracing at the
  /// plugin boundary.
  ///
  /// This is the exact seam where "the button does nothing" was impossible to
  /// diagnose: the call either returns an account, throws a
  /// [GoogleSignInException] whose `code` names the real problem, or — on a
  /// misconfigured project — never surfaces anything useful at all. Logging
  /// entry, exit and the typed failure code here means the platform's own
  /// verdict is always on the record, independent of whatever the repository
  /// above chooses to map it to.
  ///
  /// `providerConfigurationError` is the one to look for: on Android it means
  /// Credential Manager could not match the app to an OAuth client — i.e. the
  /// signing certificate's SHA-1 is not registered in the Firebase project, so
  /// `google-services.json` carries no `client_type: 1` entry.
  Future<GoogleSignInAccount> authenticate() async {
    if (!_googleSignIn.supportsAuthenticate()) {
      // Would otherwise throw a bare UnsupportedError from deep in the plugin.
      _loggerService.error(
        'GoogleSignInService.authenticate: platform does not support '
        'authenticate() — this build cannot start an interactive sign-in.',
      );
      throw const GoogleSignInException(
        code: GoogleSignInExceptionCode.uiUnavailable,
        description: 'authenticate() is unsupported on this platform',
      );
    }

    _loggerService.info('GoogleSignInService.authenticate: starting…');
    try {
      final account = await _googleSignIn.authenticate();
      _loggerService.info(
        'GoogleSignInService.authenticate: succeeded for ${account.email}',
      );
      return account;
    } on GoogleSignInException catch (e, stackTrace) {
      _loggerService.error(
        'GoogleSignInService.authenticate: ${e.code.name}'
        '${e.description == null ? '' : ' — ${e.description}'}'
        '${e.code == GoogleSignInExceptionCode.providerConfigurationError ? ' '
            '[likely cause: the signing cert SHA-1 is not registered in the '
            'Firebase project, so google-services.json has no Android OAuth '
            'client]' : ''}',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      _loggerService.error(
        'GoogleSignInService.authenticate: unexpected error: $e',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Ends the Google session, leaving the app's OAuth grant INTACT.
  ///
  /// **THE BUG THIS FIXES.** This used to call [GoogleSignIn.disconnect],
  /// which does not end a session — it REVOKES the authorization grant. The
  /// consequence surfaced in account deletion, which is a two-step flow:
  /// `user.delete()` rejects a credential older than a few minutes with
  /// `requires-recent-login`, so the account can only be deleted by
  /// re-authenticating and retrying. But an earlier attempt had already
  /// revoked the grant, so when the retry opened Credential Manager it had no
  /// authorized account to offer, closed immediately, and the plugin reported
  /// it as `[16] Cancelled by user.` — indistinguishable from the user tapping
  /// away. The re-auth could therefore NEVER succeed, `user.delete()` was
  /// never retried, and the account survived every deletion attempt.
  ///
  /// Revoking is correct only once the account is genuinely gone — that is
  /// [disconnect], called from the deletion success path.
  Future<void> signOut() async {
    if (!_initialized) return;
    try {
      await _googleSignIn.signOut();
    } catch (e, stackTrace) {
      // Never let a sign-out failure escape as an unhandled error — but
      // never swallow it silently either: a sign-out that half-worked leaves
      // the next sign-in in a confusing state, and this log is the only clue.
      _loggerService.error(
        'GoogleSignInService.signOut: signOut failed: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Revokes the app's OAuth grant entirely.
  ///
  /// Separate from [signOut] because the two are not interchangeable: this
  /// one is irreversible from the app's side and makes the next sign-in a
  /// fresh authorization. Call it ONLY after the Firebase account has actually
  /// been deleted — before that point it breaks the re-authentication the
  /// deletion itself depends on (see [signOut]).
  Future<void> disconnect() async {
    if (!_initialized) return;
    try {
      await _googleSignIn.disconnect();
    } catch (e, stackTrace) {
      _loggerService.error(
        'GoogleSignInService.disconnect: disconnect failed: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
