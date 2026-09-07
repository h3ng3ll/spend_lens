import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignInException, GoogleSignInExceptionCode;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/services/crypto_service.dart';
import '../../../../core/services/google_sign_in_service/google_sign_in_service.dart';
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

  const FirebaseAuthRepository({
    required FirebaseAuth auth,
    required GoogleSignInService googleSignInService,
    required CryptoService cryptoService,
  }) : this._(auth, googleSignInService, cryptoService);

  const FirebaseAuthRepository._(
    this._auth,
    this._googleSignInService,
    this._cryptoService,
  );

  @override
  Stream<User?> watchUser() => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<Either<UserCredential, Failure>> signInWithGoogle() async {
    if (!_googleSignInService.isConfigured) {
      return const Right(GoogleSignInUnconfiguredFailure());
    }

    try {
      final account = await _googleSignInService.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        return const Right(GoogleSignInFailure());
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final result = await _auth.signInWithCredential(credential);
      return Left(result);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const Right(GoogleSignInCanceledFailure());
      }
      return const Right(GoogleSignInFailure());
    } catch (_) {
      return const Right(GoogleSignInFailure());
    }
  }

  /// Entry point for Apple Sign-In — dispatches by platform.
  @override
  Future<Either<AppleSignInResult, Failure>> signInWithApple() async {
    if (Platform.isAndroid) {
      return _androidCall();
    } else if (Platform.isIOS) {
      return _iosCall();
    }
    return const Right(AppleSignInUnsupportedPlatformFailure());
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
  Future<Either<AppleSignInResult, Failure>> _androidCall() async {
    try {
      final provider = OAuthProvider('apple.com')
        ..addScope('email')
        ..addScope('name');

      final result = await _auth.signInWithProvider(provider);

      // On first sign-in the display name arrives on the Firebase user.
      final parts = result.user?.displayName?.trim().split(' ');
      return Left(
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
    } catch (_) {
      return const Right(AppleSignInFailure());
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
  // token), and the RAW nonce goes to Firebase's `OAuthProvider.credential`
  // (so Firebase can verify the token's embedded hash matches).
  Future<Either<AppleSignInResult, Failure>> _iosCall() async {
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

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce,
      );

      final result = await _auth.signInWithCredential(oauthCredential);
      return Left(
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
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return const Right(AppleSignInCanceledFailure());
      }
      return const Right(AppleSignInFailure());
    } catch (_) {
      return const Right(AppleSignInFailure());
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignInService.signOut();
    await _auth.signOut();
  }
}
