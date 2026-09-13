part of 'edit_profile_bloc.dart';

/// Intent events (BLoC rule A3.7) — the UI dispatches these and never branches
/// on state to choose between them.
@freezed
sealed class EditProfileEvent with _$EditProfileEvent {
  /// Loads the stored profile into the form. Dispatched from the page's
  /// `initState` — this bloc is screen-scoped, so it is never dispatched from
  /// `main()`.
  ///
  /// Carries the LIVE identity from `AuthState` so the form can fall back to
  /// it when the stored profile is missing or incomplete — see
  /// `EditProfileBloc._onStarted`.
  const factory EditProfileEvent.started({
    @Default('') String uid,
    @Default('') String email,
    @Default('') String firstName,
    @Default('') String lastName,
  }) = _Started;

  const factory EditProfileEvent.firstNameChanged(String value) =
      _FirstNameChanged;

  const factory EditProfileEvent.lastNameChanged(String value) =
      _LastNameChanged;

  /// The OS picker is open, or its result is being read. Dispatched by the UI
  /// around that work — the picker is a system dialog, so the page owns the
  /// call while the bloc owns the state it produces.
  const factory EditProfileEvent.photoPickStarted() = _PhotoPickStarted;

  /// The pick ended without an image: cancelled, or it failed to read.
  const factory EditProfileEvent.photoPickEnded() = _PhotoPickEnded;

  /// A picked image, identified by its PATH on disk.
  ///
  /// Deliberately not its bytes. Freezed generates
  /// `'...avatarPicked(bytes: $bytes)'` for a `Uint8List` field, so any log of
  /// this event would render a multi-megabyte array as a decimal string — the
  /// exact shape that tombstoned the app through `AppObserver`. The picker
  /// hands back a file anyway, so a path costs nothing and closes the hole.
  const factory EditProfileEvent.avatarPicked(String sourcePath) =
      _AvatarPicked;

  /// Carries NO payload: removal is not a toggle and not a value, it is a
  /// single intent the handler interprets against current state.
  const factory EditProfileEvent.avatarRemoved() = _AvatarRemoved;

  const factory EditProfileEvent.save() = _Save;
}
