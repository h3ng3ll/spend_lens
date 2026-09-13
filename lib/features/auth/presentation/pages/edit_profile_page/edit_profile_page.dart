import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/services/avatar_image_store/avatar_image_store.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/services/permission_requester.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/utils/extensions/go_router_x.dart';
import '../../../domain/repositories/i_user_profile_local_repository.dart';
import '../../../domain/use_cases/remove_avatar_use_case.dart';
import '../../../domain/use_cases/save_user_profile_use_case.dart';
import '../../../domain/use_cases/upload_avatar_use_case.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'widgets/avatar_source_sheet.dart';
import 'widgets/e_avatar_source.dart';
import 'widgets/edit_profile_body.dart';

/// `EditProfilePageRoute` (`/profile/edit`) — a top-level push above the shell,
/// reached only from the Profile avatar and only while signed in.
///
/// [EditProfileBloc] is SCREEN-scoped (BLoC rule A3.8): built here as a field,
/// closed in `dispose`. Every edit is staged in that bloc and committed once
/// on Save (`edit_profile_screen_rules.md`).
///
/// The controllers are seeded from the bloc's first `editing` state via a
/// `BlocListener` rather than in `initState`, because the stored profile is
/// read asynchronously and is not available when the widget mounts.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final EditProfileBloc _editProfileBloc = EditProfileBloc(
    localRepository: getIt<IUserProfileLocalRepository>(),
    saveUserProfile: getIt<SaveUserProfileUseCase>(),
    uploadAvatar: getIt<UploadAvatarUseCase>(),
    removeAvatar: getIt<RemoveAvatarUseCase>(),
    imageStore: getIt<AvatarImageStore>(),
  );

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // The live identity is passed in as a FALLBACK for the stored profile,
    // which can legitimately be missing (a session restored at launch, a first
    // run after upgrading, a seed that failed offline). Read once here rather
    // than watched: this screen edits a snapshot and commits it on Save.
    final authState = context.read<AuthBloc>().state;
    _editProfileBloc.add(
      EditProfileEvent.started(
        uid: authState.uid,
        email: authState.email,
        firstName: authState.firstName,
        lastName: authState.lastName,
      ),
    );
  }

  @override
  void dispose() {
    _editProfileBloc.close();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _onFirstNameChanged(String value) =>
      _editProfileBloc.add(EditProfileEvent.firstNameChanged(value));

  void _onLastNameChanged(String value) =>
      _editProfileBloc.add(EditProfileEvent.lastNameChanged(value));

  void _onSave() => _editProfileBloc.add(const EditProfileEvent.save());

  /// Opens the source sheet and hands the outcome to the bloc as an intent.
  ///
  /// The OS picker is a system dialog, not app logic, so launching it stays in
  /// the UI layer — but only the resulting PATH goes to the bloc, which owns
  /// every staging decision from there. The bytes are never read here.
  Future<void> _onAvatarTap() async {
    final source = await AvatarSourceSheet.show(
      context,
      hasAvatar: _editProfileBloc.state.hasAvatar,
    );
    if (source == null || !mounted) return;

    if (source == EAvatarSource.remove) {
      _editProfileBloc.add(const EditProfileEvent.avatarRemoved());
      return;
    }

    // Flagged across BOTH the OS picker and the staging copy. Neither is
    // instant on a multi-megabyte photo, and before this the avatar sat
    // unchanged with no feedback the whole time — indistinguishable from a tap
    // that did nothing.
    _editProfileBloc.add(const EditProfileEvent.photoPickStarted());

    try {
      final permissionRequester = getIt<PermissionRequester>();
      final file = source == EAvatarSource.camera
          ? await permissionRequester.onPickCamera(context)
          : await permissionRequester.onPickGallery(context);
      if (file == null) {
        _editProfileBloc.add(const EditProfileEvent.photoPickEnded());
        return;
      }

      _editProfileBloc.add(EditProfileEvent.avatarPicked(file.path));
    } catch (_) {
      // A read that throws (a revoked permission, a file that vanished) must
      // still clear the flag — a stuck spinner over an unchanged avatar is
      // worse than the failure itself, because it never resolves.
      _editProfileBloc.add(const EditProfileEvent.photoPickEnded());
    }
  }

  /// Seeds the controllers once the stored profile has loaded. Guarded on the
  /// transition INTO `editing` so a later rebuild cannot overwrite what the
  /// user is currently typing.
  bool _listenWhenLoaded(EditProfileState p, EditProfileState c) =>
      p.isLoading && c.isEditing;

  void _onLoaded(BuildContext context, EditProfileState state) {
    _firstNameController.text = state.firstName;
    _lastNameController.text = state.lastName;
  }

  bool _listenWhenSaved(EditProfileState p, EditProfileState c) =>
      !p.isSaved && c.isSaved;

  /// Save persists and EXITS (`edit_profile_screen_rules.md` rule 4).
  void _onSaved(BuildContext context, EditProfileState state) {
    UiMessageService.showSuccess(AppLocalizations.of(context).tProfileSaved);
    context.goBack();
  }

  bool _listenWhenFailed(EditProfileState p, EditProfileState c) =>
      !p.isFailed && c.isFailed;

  void _onFailed(BuildContext context, EditProfileState state) =>
      UiMessageService.showError(
        AppLocalizations.of(context).tProfileSaveFailed,
      );

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return BlocProvider<EditProfileBloc>.value(
      value: _editProfileBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<EditProfileBloc, EditProfileState>(
            listenWhen: _listenWhenLoaded,
            listener: _onLoaded,
          ),
          BlocListener<EditProfileBloc, EditProfileState>(
            listenWhen: _listenWhenSaved,
            listener: _onSaved,
          ),
          BlocListener<EditProfileBloc, EditProfileState>(
            listenWhen: _listenWhenFailed,
            listener: _onFailed,
          ),
        ],
        child: BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (context, state) => PopScope(
            // Blocked only WHILE a save runs. An upload is in flight, and
            // leaving mid-flight disposes the bloc that owns it: the save
            // would neither finish nor report, leaving the user believing an
            // edit landed that did not.
            //
            // `canPop` follows the live flag and is never a constant — this
            // screen stays dismissible at every other moment.
            canPop: !state.isSaving,
            child: Scaffold(
              backgroundColor: scheme.bg,
              body: SafeArea(
                child: EditProfileBody(
                  state: state,
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  onFirstNameChanged: _onFirstNameChanged,
                  onLastNameChanged: _onLastNameChanged,
                  onAvatarTap: _onAvatarTap,
                  onSave: _onSave,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
