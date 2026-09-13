import '../../../../core/services/logger_service.dart';
import '../models/user_profile/user_profile.dart';
import '../repositories/i_user_profile_local_repository.dart';
import '../repositories/i_user_profile_remote_repository.dart';

/// Persists the profile locally, then mirrors it to Firestore.
///
/// **Order is load-bearing.** The Hive write happens FIRST and its failure
/// propagates; the remote write is attempted after and its failure is
/// swallowed (logged, not thrown). Two reasons:
///
/// 1. An edit made offline must never be lost. Local-first means the user's
///    change is durable the moment Save returns.
/// 2. Firestore has its own on-device write queue (`persistenceEnabled: true`
///    in `FirebaseFirestoreService.configure`), so a write made with no
///    connection is replayed on reconnect. Surfacing that as a save failure
///    would report a problem that the SDK is already handling.
class SaveUserProfileUseCase {
  final IUserProfileLocalRepository _localRepository;
  final IUserProfileRemoteRepository _remoteRepository;
  final LoggerService _loggerService;

  const SaveUserProfileUseCase({
    required IUserProfileLocalRepository localRepository,
    required IUserProfileRemoteRepository remoteRepository,
    required LoggerService loggerService,
  }) : this._(localRepository, remoteRepository, loggerService);

  const SaveUserProfileUseCase._(
    this._localRepository,
    this._remoteRepository,
    this._loggerService,
  );

  Future<void> call(UserProfile profile) async {
    await _localRepository.save(profile);

    if (profile.uid.isEmpty) return;

    try {
      await _remoteRepository.save(profile);
    } catch (error, stackTrace) {
      _loggerService.warning(
        'Profile saved locally but not mirrored to Firestore',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
