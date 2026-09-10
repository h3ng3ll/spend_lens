import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'
    show GoogleSignInException, GoogleSignInExceptionCode;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/services/crypto_service.dart';
import '../../../../core/services/google_sign_in_service/google_sign_in_service.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/failures/auth_failures.dart';
import '../../domain/models/apple_credentials/apple_credentials.dart';
import '../../domain/models/apple_sign_in_result/apple_sign_in_result.dart';
import '../../domain/repositories/i_auth_repository.dart';

/// Firebase-backed [IAuthRepository] (design_spendlens.md §9 — the M9
/// rewrite fixing the reference template's bugs 1–5).
///
/// Bug 1 (wrong `serverClientId`) is fixed in [GoogleSignInService], which
/// this class delegates to rather than touching `GoogleSignIn` directly.
/// Bugs 2, 3 and 4 are fixed IN THIS FILE — see each method's doc comment.
class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignInService _googleSignInService;
  final CryptoService _cryptoService;
  final LoggerService _loggerService;

  const FirebaseAuthRepository({
    required FirebaseAuth auth,
    required GoogleSignInService googleSignInService,
    required CryptoService cryptoService,
    required LoggerService loggerService,
  }) : this._(auth, googleSignInService, cryptoService, loggerService);

  const FirebaseAuthRepository._(
    this._auth,
    this._googleSignInService,
    this._cryptoService,
    this._loggerService,
  );

  /// Renders any thrown object into a short, greppable cause string.
  ///
  /// Every sign-in path funnels its `catch` through this, so a failure can
  /// never again reach the UI as an unexplained no-op: the platform code is
  /// preserved on the Failure AND written to the log with its stack.
  String _describe(Object error) => switch (error) {
    GoogleSignInException(:final code, :final description) =>
      'GoogleSignInException.${code.name}'
          '${description == null ? '' : ': $description'}',
    FirebaseAuthException(:final code, :final message) =>
      'FirebaseAuthException.$code${message == null ? '' : ': $message'}',
    SignInWithAppleAuthorizationException(:final code, :final message) =>
      'AppleAuthorizationException.${code.name}: $message',
    _ => error.toString(),
  };

  Failure _logged(
    String operation,
    Failure failure,
    Object error,
    StackTrace stackTrace,
  ) {
    _loggerService.error(
      'Auth: $operation failed — ${_describe(error)}',
      error: error,
      stackTrace: stackTrace,
      name: 'Auth',
    );
    return failure;
  }

  @override
  Stream<User?> watchUser() => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<Either<Failure, UserCredential>> signInWithGoogle() async {
    if (!_googleSignInService.isConfigured) {
      // NOT a silent no-op: the service records WHY it never initialized
      // (empty GOOGLE_SERVER_CLIENT_ID, a timeout, or a plugin throw), and
      // that reason is carried to the UI instead of being invented here.
      final reason = _googleSignInService.unconfiguredReason;
      _loggerService.error(
        'Auth: Google sign-in unavailable — $reason',
        name: 'Auth',
      );
      return Left(GoogleSignInUnconfiguredFailure(diagnostic: reason));
    }

    try {
      final account = await _googleSignInService.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        const reason = 'authenticate() returned no idToken';
        _loggerService.error(
          'Auth: Google sign-in failed — $reason',
          name: 'Auth',
        );
        return const Left(GoogleSignInFailure(diagnostic: reason));
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final result = await _auth.signInWithCredential(credential);
      return Right(result);
    } on GoogleSignInException catch (e, stackTrace) {
      // `canceled` does NOT reliably mean the user dismissed the sheet.
      //
      // On Android the plugin maps `GetCredentialFailureType.canceled` to
      // this code, and Credential Manager raises that whenever ITS UI goes
      // away — including when the activity dies because Google rejected the
      // app (`This android application is not registered to use OAuth2.0`,
      // i.e. the signing SHA-1 is not in the Firebase project). The plugin
      // cannot tell "user tapped away" from "the OS killed the flow".
      //
      // Observed symptom this fixes: Google sign-in failed and the app
      // showed NOTHING, while Apple correctly showed its error — because a
      // real configuration failure was being classified as a cancellation
      // and deliberately suppressed.
      //
      // A genuine user cancellation carries no `description`; the platform
      // attaches one only when it has an actual error to report. So an
      // empty description is treated as a real cancellation (stay silent)
      // and a populated one as a failure the user must be told about.
      if (e.code == GoogleSignInExceptionCode.canceled &&
          (e.description == null || e.description!.isEmpty)) {
        return Left(
          _logged(
            'Google sign-in (canceled)',
            GoogleSignInCanceledFailure(diagnostic: _describe(e)),
            e,
            stackTrace,
          ),
        );
      }
      // `providerConfigurationError` lands here — the signature of a missing
      // Android OAuth client / unregistered SHA-1 fingerprint. Previously
      // flattened into a bare `GoogleSignInFailure`, which is why an
      // unconfigured project looked identical to a transient error.
      return Left(
        _logged(
          'Google sign-in',
          GoogleSignInFailure(diagnostic: _describe(e)),
          e,
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        _logged(
          'Google sign-in',
          GoogleSignInFailure(diagnostic: _describe(e)),
          e,
          stackTrace,
        ),
      );
    }
  }

  /// Entry point for Apple Sign-In — dispatches by platform.
  @override
  Future<Either<Failure, AppleSignInResult>> signInWithApple() async {
    if (Platform.isAndroid) {
      return _androidCall();
    } else if (Platform.isIOS) {
      return _iosCall();
    }
    return Left(
      AppleSignInUnsupportedPlatformFailure(
        diagnostic: 'platform=${Platform.operatingSystem}',
      ),
    );
  }

  // =========================
  // ANDROID (Firebase Web OAuth)
  // =========================
  //
  // **Bug 3 fixed here.** The reference template's `_androidCall()` was
  // declared `Future<AppleSignInResult>` and THREW on failure, while its
  // caller unconditionally wrapped the result in `Left(...)` — so a thrown
  // `Exception('Android Apple Sign-In failed: $e')` propagated as an
  // UNCAUGHT error instead of the `Either.Right(Failure)` every other path
  // in this repository returns. `signInWithApple()` above now calls this
  // method directly (no `Left(...)` wrapper at the call site) and this
  // method itself returns `Either`, catching the failure into
  // `Right(AppleSignInFailure())` like every other method here.
  Future<Either<Failure, AppleSignInResult>> _androidCall() async {
    try {
      final provider = OAuthProvider('apple.com')
        ..addScope('email')
        ..addScope('name');

      final result = await _auth.signInWithProvider(provider);

      // On first sign-in the display name arrives on the Firebase user.
      final parts = result.user?.displayName?.trim().split(' ');
      return Right(
        AppleSignInResult(
          userCredential: result,
          credentials: AppleCredentials(
            firstName: parts != null && parts.isNotEmpty ? parts.first : null,
            lastName: parts != null && parts.length > 1
                ? parts.sublist(1).join(' ')
                : null,
            email: result.user?.email,
          ),
        ),
      );
    } catch (e, stackTrace) {
      // Most often `auth/operation-not-allowed` — the Apple provider is not
      // enabled in the Firebase console. That is a configuration answer the
      // user can act on, so it must reach them, not die in a bare catch.
      return Left(
        _logged(
          'Apple sign-in (Android web OAuth)',
          AppleSignInFailure(diagnostic: _describe(e)),
          e,
          stackTrace,
        ),
      );
    }
  }

  // =====================
  // iOS (Native Apple API)
  // =====================
  //
  // **Bug 2 fixed here.** The reference template generated a raw nonce,
  // hashed it, and then discarded BOTH — `getAppleIDCredential`'s `nonce:`
  // argument was commented out, and the hashed value was never passed to
  // Apple, so Apple's identity token carried no nonce claim for Firebase to
  // verify against. That is a replay-protection gap: a captured identity
  // token could be replayed with no proof it belonged to THIS sign-in
  // attempt. The fix pairs both halves correctly: the SHA-256 HASH goes to
  // Apple's `nonce:` parameter (so Apple embeds it into the signed identity
  // token), and the RAW nonce goes to Firebase's credential (so Firebase can
  // verify the token's embedded hash matches).
  Future<Either<Failure, AppleSignInResult>> _iosCall() async {
    try {
      final rawNonce = _cryptoService.generateNonce();
      final hashedNonce = _cryptoService.sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      // The identity token is what Firebase actually verifies. It is nullable
      // on the Apple credential, so it is GUARDED rather than `!`-asserted:
      // a null here must surface as a named failure, not a TypeError.
      final identityToken = appleCredential.identityToken;
      if (identityToken == null) {
        const reason = 'Apple returned no identityToken';
        _loggerService.error(
          'Auth: Apple sign-in failed — $reason',
          name: 'Auth',
        );
        return const Left(AppleSignInFailure(diagnostic: reason));
      }

      // BUILT VIA `AppleAuthProvider`, NOT `OAuthProvider('apple.com')`.
      //
      // This is a real bug fix, not a style change. `OAuthProvider.credential`
      // defaults `signInMethod` to `'oauth'` (never `'apple.com'`), and the
      // native iOS plugin dispatches on signInMethod — not providerId:
      //   FLTFirebaseAuthPlugin.swift `case kSignInMethodApple:` calls
      //   `OAuthProvider.appleCredential(withIDToken:rawNonce:fullName:)` and
      //   ignores accessToken, while `case kSignInMethodOAuth:` builds a
      //   GENERIC OIDC credential and forwards accessToken.
      // So the old call took the generic branch and handed Firebase Apple's
      // `authorizationCode` as an `accessToken`. That code is a single-use
      // OAuth code for server-side redemption, NOT an access token, so
      // verification rejected it with `invalid-credential` — on iOS only,
      // which is why Android (a different code path entirely) was unaffected.
      //
      // `credentialWithIDToken` hardcodes signInMethod to 'apple.com', accepts
      // no accessToken at all, and carries the full name through to the
      // Firebase user profile (which the generic branch silently dropped).
      final oauthCredential = AppleAuthProvider.credentialWithIDToken(
        identityToken,
        rawNonce,
        AppleFullPersonName(
          givenName: appleCredential.givenName,
          familyName: appleCredential.familyName,
        ),
      );

      final result = await _auth.signInWithCredential(oauthCredential);
      return Right(
        AppleSignInResult(
          userCredential: result,
          // Apple only returns the name/email on the FIRST authorization.
          credentials: AppleCredentials(
            firstName: appleCredential.givenName,
            lastName: appleCredential.familyName,
            email: appleCredential.email,
          ),
        ),
      );
    } on SignInWithAppleAuthorizationException catch (e, stackTrace) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return Left(
          _logged(
            'Apple sign-in (canceled)',
            AppleSignInCanceledFailure(diagnostic: _describe(e)),
            e,
            stackTrace,
          ),
        );
      }
      return Left(
        _logged(
          'Apple sign-in',
          AppleSignInFailure(diagnostic: _describe(e)),
          e,
          stackTrace,
        ),
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      // Explicit, though `_describe` already renders the code: a rejection
      // from FIREBASE (bad credential, provider disabled) is a different
      // problem from a rejection by APPLE above, and the two were previously
      // indistinguishable in the handler chain.
      return Left(
        _logged(
          'Apple sign-in (Firebase credential exchange)',
          AppleSignInFailure(diagnostic: _describe(e)),
          e,
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        _logged(
          'Apple sign-in',
          AppleSignInFailure(diagnostic: _describe(e)),
          e,
          stackTrace,
        ),
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignInService.signOut();
    await _auth.signOut();
  }
}
