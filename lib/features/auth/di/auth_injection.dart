import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../sync/domain/adapters/sync_entity_adapters.dart';
import '../../settings/domain/repositories/i_settings_local_repository.dart';
import '../../../core/services/firebase/firebase_firestore_service.dart';
import '../../sync/domain/use_cases/clear_synced_local_records_use_case.dart';
import '../../sync/domain/use_cases/run_full_sync_use_case.dart';
import '../../sync/domain/repositories/i_sync_remote_repository.dart';

import '../../../core/di/injection.dart';
import '../../../core/services/crypto_service.dart';
import '../../../core/services/google_sign_in_service/google_sign_in_service.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/utils/env/env.dart';
import '../../../core/services/avatar_image_store/avatar_image_store.dart';
import '../../../core/services/firebase/firebase_storage_service.dart';
import '../../../core/services/image_compression_service.dart';
import '../../../core/hive/hive_database.dart';
import '../data/repositories/firebase_auth_repository.dart';
import '../data/repositories/unconfigured_auth_repository.dart';
import '../data/repositories/unconfigured_user_profile_repository.dart';
import '../data/repositories/user_profile_firestore_repository.dart';
import '../data/repositories/user_profile_local_repository.dart';
import '../domain/repositories/i_auth_repository.dart';
import '../domain/repositories/i_user_profile_local_repository.dart';
import '../domain/repositories/i_user_profile_remote_repository.dart';
import '../domain/use_cases/apple_sign_in_use_case.dart';
import '../domain/use_cases/delete_account_use_case.dart';
import '../domain/use_cases/google_sign_in_use_case.dart';
import '../domain/use_cases/remove_avatar_use_case.dart';
import '../domain/use_cases/save_user_profile_use_case.dart';
import '../domain/use_cases/seed_profile_from_credentials_use_case.dart';
import '../domain/use_cases/sign_out_use_case.dart';
import '../domain/use_cases/upload_avatar_use_case.dart';
import '../domain/use_cases/watch_user_profile_use_case.dart';
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

  // Profile slice. The remote half follows the SAME availability probe as the
  // auth repository above: with no Firebase config it resolves to the
  // unconfigured no-op, so a profile edit still saves locally and the screen
  // reports honest success rather than a crash.
  getIt.registerLazySingleton<IUserProfileLocalRepository>(
    () => UserProfileLocalRepository(getIt<HiveDatabase>()),
  );

  if (firebaseReady) {
    getIt.registerLazySingleton<IUserProfileRemoteRepository>(
      () => UserProfileFirestoreRepository(
        firestoreService: getIt<FirebaseFirestoreService>(),
        storageService: getIt<FirebaseStorageService>(),
      ),
    );
  } else {
    getIt.registerLazySingleton<IUserProfileRemoteRepository>(
      () => const UnconfiguredUserProfileRepository(),
    );
  }

  getIt.registerLazySingleton(
    () => WatchUserProfileUseCase(getIt<IUserProfileLocalRepository>()),
  );
  getIt.registerLazySingleton(
    () => SaveUserProfileUseCase(
      localRepository: getIt<IUserProfileLocalRepository>(),
      remoteRepository: getIt<IUserProfileRemoteRepository>(),
      loggerService: getIt<LoggerService>(),
    ),
  );
  // Avatar bytes live on the FILESYSTEM, never in Hive or a bloc state —
  // see `AvatarImageStore` for the two defects that rule prevents.
  getIt.registerLazySingleton(() => const AvatarImageStore());
  getIt.registerLazySingleton(
    () => UploadAvatarUseCase(
      localRepository: getIt<IUserProfileLocalRepository>(),
      remoteRepository: getIt<IUserProfileRemoteRepository>(),
      compressionService: getIt<ImageCompressionService>(),
      imageStore: getIt<AvatarImageStore>(),
    ),
  );
  getIt.registerLazySingleton(
    () => RemoveAvatarUseCase(
      localRepository: getIt<IUserProfileLocalRepository>(),
      remoteRepository: getIt<IUserProfileRemoteRepository>(),
      imageStore: getIt<AvatarImageStore>(),
    ),
  );
  // Registered before AuthBloc, which depends on it. Its own dependencies
  // (sync remote repo, adapters, the record repositories) are registered by
  // the sync/feature slices that ran earlier, and every registration is lazy.
  getIt.registerLazySingleton(
    () => DeleteAccountUseCase(
      authRepository: getIt<IAuthRepository>(),
      syncRemoteRepository: getIt<ISyncRemoteRepository>(),
      profileRemoteRepository: getIt<IUserProfileRemoteRepository>(),
      profileLocalRepository: getIt<IUserProfileLocalRepository>(),
      storageService: getIt<FirebaseStorageService>(),
      adapters: getIt<SyncEntityAdapters>(),
      receiptLocalRepository: getIt<IReceiptLocalRepository>(),
      settingsLocalRepository: getIt<ISettingsLocalRepository>(),
      imageStore: getIt<ReceiptImageStore>(),
      loggerService: getIt<LoggerService>(),
    ),
  );

  getIt.registerLazySingleton(
    () => SeedProfileFromCredentialsUseCase(
      localRepository: getIt<IUserProfileLocalRepository>(),
      remoteRepository: getIt<IUserProfileRemoteRepository>(),
      saveUserProfile: getIt<SaveUserProfileUseCase>(),
      loggerService: getIt<LoggerService>(),
    ),
  );

  // Registered here rather than in the sync slice because `AuthBloc`
  // depends on it and auth is initialized first. Its own dependencies (the
  // receipt/store repositories and the image store) are all registered
  // earlier still, and every registration is lazy, so nothing resolves
  // before it exists.
  getIt.registerLazySingleton(
    () => ClearSyncedLocalRecordsUseCase(
      receiptLocalRepository: getIt<IReceiptLocalRepository>(),
      adapters: getIt<SyncEntityAdapters>(),
      settingsLocalRepository: getIt<ISettingsLocalRepository>(),
      imageStore: getIt<ReceiptImageStore>(),
      runFullSync: getIt<RunFullSyncUseCase>(),
      firestoreService: getIt<FirebaseFirestoreService>(),
      loggerService: getIt<LoggerService>(),
    ),
  );

  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      authRepository: getIt<IAuthRepository>(),
      googleSignInUseCase: getIt<GoogleSignInUseCase>(),
      appleSignInUseCase: getIt<AppleSignInUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
      clearSyncedLocalRecords: getIt<ClearSyncedLocalRecordsUseCase>(),
      deleteAccountUseCase: getIt<DeleteAccountUseCase>(),
      seedProfileFromCredentials: getIt<SeedProfileFromCredentialsUseCase>(),
      watchUserProfile: getIt<WatchUserProfileUseCase>(),
      userProfileLocalRepository: getIt<IUserProfileLocalRepository>(),
    ),
  );

  // Returned so the sync slice can pick its remote repository without
  // re-running (or duplicating) the Firebase-availability probe.
  return firebaseReady;
}
