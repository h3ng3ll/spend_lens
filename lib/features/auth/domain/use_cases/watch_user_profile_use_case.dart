import '../models/user_profile/user_profile.dart';
import '../repositories/i_user_profile_local_repository.dart';

/// Reactive read of the stored profile (A1 SRP).
class WatchUserProfileUseCase {
  final IUserProfileLocalRepository _repository;

  const WatchUserProfileUseCase(this._repository);

  Stream<UserProfile?> call() => _repository.watch();
}
