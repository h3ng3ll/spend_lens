import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/logger_service.dart';
import '../models/apple_credentials/apple_credentials.dart';
import '../models/user_profile/user_profile.dart';
import '../repositories/i_user_profile_local_repository.dart';
import '../repositories/i_user_profile_remote_repository.dart';
import 'save_user_profile_use_case.dart';

/// Captures the identity the provider hands over at sign-in.
///
/// ## Why this exists: Apple gives the name exactly ONCE
///
/// `SignInWithApple.getAppleIDCredential` returns `givenName`/`familyName`
/// **only on the first authorization for this app**. Every subsequent sign-in
/// returns nulls for both — permanently, unless the user revokes the app in
/// iOS Settings. `FirebaseAuthRepository` already captures them into
/// [AppleCredentials], but `AuthBloc` used to discard that result with an
/// empty `fold` callback, so the one moment the name was available was thrown
/// away and could never be recovered.
///
/// This use case is the consumer that closes that gap.
///
/// ## The two guards that make re-running it safe
///
/// 1. **Never overwrite a non-empty stored value.** A later Apple sign-in
///    supplies nulls; without this guard, seeding again would blank a name the
///    user had already set. Only EMPTY fields are filled.
/// 2. **The user's own edit always wins.** Because rule 1 only fills gaps, a
///    name typed on the edit screen survives every future sign-in.
///
/// Remote state is consulted before writing so a user signing in on a SECOND
/// device inherits the profile they already created on the first, rather than
/// re-seeding from a provider payload that no longer carries a name.
class SeedProfileFromCredentialsUseCase {
  final IUserProfileLocalRepository _localRepository;
  final IUserProfileRemoteRepository _remoteRepository;
  final SaveUserProfileUseCase _saveUserProfile;
  final LoggerService _loggerService;

  const SeedProfileFromCredentialsUseCase({
    required IUserProfileLocalRepository localRepository,
    required IUserProfileRemoteRepository remoteRepository,
    required SaveUserProfileUseCase saveUserProfile,
    required LoggerService loggerService,
  }) : this._(
         localRepository,
         remoteRepository,
         saveUserProfile,
         loggerService,
       );

  const SeedProfileFromCredentialsUseCase._(
    this._localRepository,
    this._remoteRepository,
    this._saveUserProfile,
    this._loggerService,
  );

  /// [appleCredentials] is null for a Google sign-in.
  ///
  /// Never throws: seeding is best-effort enrichment, and a failure here must
  /// not turn a SUCCESSFUL sign-in into a reported failure.
  Future<void> call({
    required User user,
    AppleCredentials? appleCredentials,
  }) async {
    try {
      await _seed(user, appleCredentials);
    } catch (error, stackTrace) {
      _loggerService.warning(
        'Profile seeding from sign-in credentials failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _seed(User user, AppleCredentials? appleCredentials) async {
    final local = await _localRepository.get();

    // A profile stored for a DIFFERENT uid belongs to the previous user and
    // must not be inherited — start clean rather than merging two identities.
    final existing = (local != null && local.uid == user.uid)
        ? local
        : await _remoteRepository.fetch(user.uid) ??
              const UserProfile();

    final isGoogleAccount = user.providerData.any(
      (info) => info.providerId == 'google.com',
    );

    // Google resends displayName/photoURL on every sign-in; Apple sends the
    // name once and Firebase then exposes it as displayName on that first
    // session only. Both are read here, and both are subject to the
    // fill-only-if-empty rule below.
    final providerNames = _splitName(user.displayName);

    final firstName = _firstNonEmpty([
      existing.firstName,
      appleCredentials?.firstName,
      providerNames.$1,
    ]);
    final lastName = _firstNonEmpty([
      existing.lastName,
      appleCredentials?.lastName,
      providerNames.$2,
    ]);
    final email = _firstNonEmpty([
      user.email,
      appleCredentials?.email,
      existing.email,
    ]);
    final photoUrl = _firstNonEmpty([
      existing.photoUrl,
      user.photoURL,
    ]);

    final seeded = existing.copyWith(
      uid: user.uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      photoUrl: photoUrl,
      isGoogleAccount: isGoogleAccount,
      updatedAt: DateTime.now(),
    );

    await _saveUserProfile(seeded);
  }

  /// The stored value first, so an existing non-empty field is never replaced.
  String _firstNonEmpty(List<String?> candidates) => candidates.firstWhere(
    (value) => value != null && value.trim().isNotEmpty,
    orElse: () => '',
  )!.trim();

  /// Splits a provider display name into (first, rest).
  ///
  /// Only ever used to fill an EMPTY field, so the split being lossy for
  /// multi-word surnames is acceptable: the user can correct it on the edit
  /// screen, and that correction then wins permanently.
  (String?, String?) _splitName(String? displayName) {
    final trimmed = displayName?.trim() ?? '';
    if (trimmed.isEmpty) return (null, null);

    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return (parts.first, null);
    return (parts.first, parts.sublist(1).join(' '));
  }
}
