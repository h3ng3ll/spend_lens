import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/services/avatar_image_store/avatar_image_store.dart';
import '../../../domain/models/user_profile/user_profile.dart';
import '../../../domain/repositories/i_user_profile_local_repository.dart';
import '../../../domain/use_cases/remove_avatar_use_case.dart';
import '../../../domain/use_cases/save_user_profile_use_case.dart';
import '../../../domain/use_cases/upload_avatar_use_case.dart';

part 'edit_profile_event.dart';

part 'edit_profile_state.dart';

part 'edit_profile_state_ext.dart';

part 'edit_profile_bloc.freezed.dart';

/// SCREEN-SCOPED bloc for the Edit Profile page (BLoC rule A3.8) — built as a
/// field in the page's `State`, closed in `dispose`.
///
/// **Every edit is STAGED and committed once, on Save**
/// (`edit_profile_screen_rules.md` rule 3/4). Nothing here writes through on
/// change: not a keystroke, and — importantly — not the avatar. Tapping
/// "Remove photo" only sets [EditProfileState.avatarRemoved]; the object is
/// deleted when Save runs. Leaving the screen without saving must therefore
/// leave the stored profile completely untouched.
class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final IUserProfileLocalRepository _localRepository;
  final SaveUserProfileUseCase _saveUserProfile;
  final UploadAvatarUseCase _uploadAvatar;
  final RemoveAvatarUseCase _removeAvatar;
  final AvatarImageStore _imageStore;

  EditProfileBloc({
    required this._localRepository,
    required this._saveUserProfile,
    required this._uploadAvatar,
    required this._removeAvatar,
    required this._imageStore,
  }) : super(const EditProfileState()) {
    on<_Started>(_onStarted);
    on<_FirstNameChanged>(_onFirstNameChanged);
    on<_LastNameChanged>(_onLastNameChanged);
    on<_PhotoPickStarted>(_onPhotoPickStarted);
    on<_PhotoPickEnded>(_onPhotoPickEnded);
    on<_AvatarPicked>(_onAvatarPicked);
    on<_AvatarRemoved>(_onAvatarRemoved);
    // `droppable()`: a second Save arriving while one is in flight would run
    // the upload and the Firestore write twice, and the screen is already
    // closing on the first one's success.
    on<_Save>(_onSave, transformer: droppable());
  }

  /// Loads the stored profile into the form.
  ///
  /// [_Started] carries the LIVE identity from `AuthState` as a fallback,
  /// because the stored profile can legitimately be missing or incomplete: a
  /// session restored at launch, a first run after upgrading to a build that
  /// has profiles, or a seed that failed offline. Falling back keeps this
  /// screen from showing an empty Email field for an account whose address the
  /// Profile screen is displaying one tap away.
  Future<void> _onStarted(
    _Started event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(status: EEditProfileStatus.loading));

    try {
      final stored = await _localRepository.get();
      final profile = _merged(stored, event);
      // A staged pick can survive a kill mid-edit; it belongs to a session the
      // user never committed, so it is discarded rather than silently adopted.
      await _imageStore.discardStaged();
      final filename = await _localRepository.getAvatarFilename();

      emit(
        state.copyWith(
          status: EEditProfileStatus.editing,
          profile: profile,
          firstName: profile.firstName,
          lastName: profile.lastName,
          avatarFilename: filename ?? '',
          hasPickedAvatar: false,
          avatarRemoved: false,
        ),
      );
    } catch (_) {
      // An unreadable local profile is not a dead end: fall back to the live
      // identity so the user can still see their account and set a name,
      // rather than stranding them on an error screen with no way to fix it.
      final profile = _merged(null, event);
      emit(
        state.copyWith(
          status: EEditProfileStatus.editing,
          profile: profile,
          firstName: profile.firstName,
          lastName: profile.lastName,
        ),
      );
    }
  }

  /// The stored profile, with any gap filled from the live auth identity.
  ///
  /// Stored values win wherever they are non-empty — this fills gaps, it never
  /// overwrites — so a name the user edited survives, exactly as in
  /// `SeedProfileFromCredentialsUseCase`.
  UserProfile _merged(UserProfile? stored, _Started event) {
    final base = stored ?? const UserProfile();
    return base.copyWith(
      uid: base.uid.isNotEmpty ? base.uid : event.uid,
      email: base.email.isNotEmpty ? base.email : event.email,
      firstName: base.firstName.isNotEmpty ? base.firstName : event.firstName,
      lastName: base.lastName.isNotEmpty ? base.lastName : event.lastName,
    );
  }

  void _onFirstNameChanged(
    _FirstNameChanged event,
    Emitter<EditProfileState> emit,
  ) => emit(state.copyWith(firstName: event.value));

  void _onLastNameChanged(
    _LastNameChanged event,
    Emitter<EditProfileState> emit,
  ) => emit(state.copyWith(lastName: event.value));

  void _onPhotoPickStarted(
    _PhotoPickStarted event,
    Emitter<EditProfileState> emit,
  ) => emit(state.copyWith(isPickingPhoto: true));

  void _onPhotoPickEnded(
    _PhotoPickEnded event,
    Emitter<EditProfileState> emit,
  ) => emit(state.copyWith(isPickingPhoto: false));

  /// Stages a newly picked image. Clears [EditProfileState.avatarRemoved]:
  /// picking after removing means the user changed their mind, and leaving the
  /// flag set would delete the image they just chose.
  Future<void> _onAvatarPicked(
    _AvatarPicked event,
    Emitter<EditProfileState> emit,
  ) async {
    // Copied file-to-file: the bytes are read and written inside the store and
    // never enter an event, a state, or Hive.
    final filename = await _imageStore.stageFrom(event.sourcePath);
    if (filename == null) {
      // The picked file vanished before it could be staged. Clear the spinner
      // rather than leaving it over an avatar that will never change.
      emit(state.copyWith(isPickingPhoto: false));
      return;
    }
    emit(
      state.copyWith(
        avatarFilename: filename,
        hasPickedAvatar: true,
        avatarRemoved: false,
        // Cleared here too, not only by `_PhotoPickEnded`: the image landing
        // IS the end of the pick, and leaving it set would spin forever over
        // an image already on screen.
        isPickingPhoto: false,
      ),
    );
  }

  /// STAGES the removal — see the class doc. Drops any pending pick too, so
  /// pick-then-remove leaves nothing to upload.
  Future<void> _onAvatarRemoved(
    _AvatarRemoved event,
    Emitter<EditProfileState> emit,
  ) async {
    // Drop the staged file, not the stored one: the removal itself is still
    // staged and is only committed by Save.
    await _imageStore.discardStaged();
    emit(
      state.copyWith(
        avatarRemoved: true,
        hasPickedAvatar: false,
        avatarFilename: '',
      ),
    );
  }

  /// Commits name + avatar in one pass, then reports `saved` so the page can
  /// pop itself.
  Future<void> _onSave(_Save event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(status: EEditProfileStatus.saving));

    try {
      var profile = state.profile.copyWith(
        firstName: state.firstName.trim(),
        lastName: state.lastName.trim(),
        updatedAt: DateTime.now(),
      );

      // Avatar first: both branches return an updated profile whose
      // `photoUrl` is then persisted by the SINGLE save below, so a
      // simultaneous name edit and photo change cannot overwrite each other.
      //
      // A failed avatar step does NOT abort the save. The name is local-only
      // and has nothing to do with Storage, so letting an upload failure take
      // it down discards an edit that would otherwise have succeeded — the
      // user retypes their name because a photo server was unreachable.
      //
      // `UploadAvatarUseCase` caches the compressed bytes locally BEFORE
      // uploading, so the picked image still shows on this device; only
      // `photoUrl` is missing, and the next successful save republishes it.
      var avatarFailed = false;
      // Read back from the staging file only when there is a pick to commit,
      // so the bytes exist for the duration of the upload and no longer.
      final picked = state.hasPickedAvatar
          ? await _imageStore.readBytes(state.avatarFilename)
          : null;
      try {
        if (state.avatarRemoved) {
          profile = await _removeAvatar(profile);
        } else if (picked != null) {
          // Flagged only around the UPLOAD, so the label reports the phase the
          // user is actually waiting on rather than the whole save.
          emit(state.copyWith(isUploadingPhoto: true));
          profile = await _uploadAvatar(profile: profile, bytes: picked);
          emit(state.copyWith(isUploadingPhoto: false));
        }
      } catch (_) {
        avatarFailed = true;
        emit(state.copyWith(isUploadingPhoto: false));
      }

      await _saveUserProfile(profile);

      // The pick is committed (or was never there) — the staging slot must not
      // outlive the save, or the next edit would open onto a stale image.
      await _imageStore.discardStaged();

      // Reported as FAILED even though the name was written: claiming success
      // while the photo silently did not upload is the worse lie, and the
      // toast is the only signal the user gets.
      emit(
        state.copyWith(
          status: avatarFailed
              ? EEditProfileStatus.failed
              : EEditProfileStatus.saved,
          profile: profile,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: EEditProfileStatus.failed));
    }
  }
}
