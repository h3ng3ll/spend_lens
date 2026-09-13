part of 'edit_profile_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension EditProfileStateX on EditProfileState {
  bool get isLoading => status == EEditProfileStatus.loading;

  bool get isEditing => status == EEditProfileStatus.editing;

  bool get isSaving => status == EEditProfileStatus.saving;

  bool get isSaved => status == EEditProfileStatus.saved;

  bool get isFailed => status == EEditProfileStatus.failed;

  /// Alias for [isEditing] — the minimum `isReady` contract (A3 rule 9).
  bool get isReady => isEditing;

  /// Whether an avatar is currently shown, and therefore whether the Remove
  /// affordance is offered at all (`edit_profile_screen_rules.md` rule 2 —
  /// remove appears ONLY when an avatar exists).
  bool get hasAvatar => avatarFilename.isNotEmpty;

  /// Whether the avatar is busy — being picked/read, or being uploaded.
  ///
  /// One getter so the avatar and the button cannot disagree about whether
  /// there is work in flight.
  bool get isAvatarBusy => isPickingPhoto || isUploadingPhoto;

  /// The email is provider-owned and displayed read-only.
  String get email => profile.email;

  /// Whether Save should be enabled: something actually changed, and no save
  /// is already running.
  bool get canSave =>
      !isSaving &&
      // A save started mid-pick would commit the OLD avatar and then race the
      // incoming bytes against a write already in flight.
      !isPickingPhoto &&
      (firstName.trim() != profile.firstName ||
          lastName.trim() != profile.lastName ||
          hasPickedAvatar ||
          avatarRemoved);
}
