part of 'edit_profile_bloc.dart';

enum EEditProfileStatus { loading, editing, saving, saved, failed }

@freezed
sealed class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    @Default(EEditProfileStatus.loading) EEditProfileStatus status,

    /// The record as loaded, carrying `uid`/`email`/`photoUrl`. The editable
    /// fields are held separately below so the form can be compared against
    /// this to detect real changes.
    @Default(UserProfile()) UserProfile profile,
    @Default('') String firstName,
    @Default('') String lastName,

    /// FILENAME of what the avatar currently LOOKS like on screen — the stored
    /// image, the staged pick, or empty after a staged removal.
    ///
    /// Never the bytes. A `Uint8List` here put `DeepCollectionEquality` in the
    /// generated `==`/`hashCode` (~36 ms per emit on a 12 MB photo, on a state
    /// that re-emits every keystroke) and the raw bytes in `toString()`
    /// (~309 ms, a 57 MB string) — which `AppObserver` then built four times
    /// per Save until the platform killed the process. See `AvatarImageStore`.
    @Default('') String avatarFilename,

    /// Whether [avatarFilename] points at a newly picked image awaiting Save.
    ///
    /// Distinct from the filename so Save knows whether there is anything to
    /// UPLOAD, rather than re-uploading the unchanged stored image every time.
    @Default(false) bool hasPickedAvatar,

    /// Staged removal, applied on Save. Never committed on tap
    /// (`edit_profile_screen_rules.md` rule 3).
    @Default(false) bool avatarRemoved,

    /// Whether an image is being fetched from the OS picker and read into
    /// memory.
    ///
    /// Covers the gap between the source sheet closing and the picked bytes
    /// arriving: the picker itself, plus `readAsBytes` on a multi-megabyte
    /// photo. Without it the avatar sat unchanged with no feedback for
    /// seconds, which reads as a tap that did nothing.
    @Default(false) bool isPickingPhoto,

    /// Whether the save is currently in its PHOTO phase.
    ///
    /// Separate from [status] so the progress label can name what is actually
    /// happening. Uploading an image is the slow, network-bound part and the
    /// one worth reporting; writing a name is instant and local.
    @Default(false) bool isUploadingPhoto,
  }) = _EditProfileState;
}
