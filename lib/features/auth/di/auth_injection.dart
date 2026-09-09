import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/di/injection.dart';
import '../../../core/services/crypto_service.dart';
import '../../../core/services/google_sign_in_service/google_sign_in_service.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/utils/env/env.dart';
import '../data/repositories/firebase_auth_repository.dart';
import '../data/repositories/unconfigured_auth_repository.dart';
import '../domain/repositories/i_auth_repository.dart';
import '../domain/use_cases/apple_sign_in_use_case.dart';
import '../domain/use_cases/google_sign_in_use_case.dart';
import '../domain/use_cases/sign_out_use_case.dart';
import '../presentation/bloc/auth_bloc/auth_bloc.dart';

/// Registers the auth slice (design_spendlens.md §5/§9 — M9).
///
/// **A missing credential is a disabled feature with honest UI, never an
/// exception.** No `GoogleService-Info.plist` / `google-services.json` is
/// bundled with this repo (they are gitignored — the user supplies them
/// later), so `Firebase.initializeApp()` throws
/// `[core/no-app] No Firebase App '[DEFAULT]' has been created` on a fresh
/// checkout. That throw is caught HERE, once, at startup — never left to
/// surface at the first `FirebaseAuth.instance` touch deep in a bloc
/// handler. When Firebase did not initialize, [IAuthRepository] resolves to
/// [UnconfiguredAuthRepository] — a repository that reports "signed out,
/// always" and every sign-in attempt as
/// `AuthUnavailableFailure` with honest copy, never a crash and never a
/// generic "something went wrong" (recorded global bug
/// `absent-data-mapped-to-failed-status-first-launch-shows-something-went-
/// wrong` — this is the same class of defect: absence must not be reported
/// as failure).
Future<bool> initAuthFeature() async {
  final loggerService = getIt<LoggerService>();
  final env = getIt<Env>();

  var firebaseReady = false;
  var firebaseInitError = '';
  try {
    await Firebase.initializeApp();
    firebaseReady = true;
  } catch (e, stackTrace) {
    // Captured, not just logged: the reason travels into
    // `UnconfiguredAuthRepository` so a sign-in tap can TELL the user why it
    // is unavailable instead of failing mutely.
    firebaseInitError = 'Firebase.initializeApp() failed: $e';
    loggerService.error(
      'Firebase did not initialize (no config bundled yet) — '
      'auth/Crashlytics are disabled for this run: $e',
      error: e,
      stackTrace: stackTrace,
    );
  }

  if (!firebaseReady) {
    getIt.registerLazySingleton<IAuthRepository>(
      () => UnconfiguredAuthRepository(reason: firebaseInitError),
    );
  } else {
    final googleSignInService = GoogleSignInService(
      googleSignIn: GoogleSignIn.instance,
      loggerService: loggerService,
    );
    await googleSignInService.init(env);

    getIt.registerLazySingleton<IAuthRepository>(
      () => FirebaseAuthRepository(
        auth: FirebaseAuth.instance,
        googleSignInService: googleSignInService,
        cryptoService: const CryptoService(),
        loggerService: loggerService,
      ),
    );
  }

  getIt.registerLazySingleton(
    () => GoogleSignInUseCase(getIt<IAuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => AppleSignInUseCase(getIt<IAuthRepository>()),
  );
  getIt.registerLazySingleton(() => SignOutUseCase(getIt<IAuthRepository>()));

  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      authRepository: getIt<IAuthRepository>(),
      googleSignInUseCase: getIt<GoogleSignInUseCase>(),
      appleSignInUseCase: getIt<AppleSignInUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
    ),
  );

  // Returned so the sync slice can pick its remote repository without
  // re-running (or duplicating) the Firebase-availability probe.
  return firebaseReady;
}
