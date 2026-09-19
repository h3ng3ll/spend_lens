import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/services/permission_requester.dart';
import '../../../../../core/services/store_logo_image_store/store_logo_image_store.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/utils/extensions/go_router_x.dart';
import '../../../../auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import '../../../domain/repositories/i_store_local_repository.dart';
import '../../../domain/use_cases/remove_store_logo_use_case.dart';
import '../../../domain/use_cases/save_store_logo_use_case.dart';
import '../../bloc/edit_store_bloc/edit_store_bloc.dart';
import 'widgets/e_store_logo_source.dart';
import 'widgets/edit_store_page_body.dart';
import 'widgets/store_logo_source_sheet.dart';

/// `EditStorePageRoute` (`/store/:storeId/edit`) — edits a store's NAME and
/// LOGO, reached from the edit icon in `StoreDetailHeader`.
///
/// A top-level push above the shell, mirroring `EditProfilePage`, which is the
/// same job for the other editable record in this app. It is deliberately NOT a
/// second "store form": type and receipt aliases stay with `NewStorePage`,
/// which owns creation.
///
/// [EditStoreBloc] is SCREEN-scoped (BLoC rule A3.8): built here as a field,
/// closed in `dispose`. Every edit is staged in that bloc and committed once on
/// Save.
///
/// The controller is seeded from the bloc's first `editing` state via a
/// `BlocListener` rather than in `initState`, because the store is read
/// asynchronously and is not available when the widget mounts.
class EditStorePage extends StatefulWidget {
  final String storeId;

  const EditStorePage({super.key, required this.storeId});

  @override
  State<EditStorePage> createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {
  final EditStoreBloc _editStoreBloc = EditStoreBloc(
    storeLocalRepository: getIt<IStoreLocalRepository>(),
    saveStoreLogo: getIt<SaveStoreLogoUseCase>(),
    removeStoreLogo: getIt<RemoveStoreLogoUseCase>(),
    imageStore: getIt<StoreLogoImageStore>(),
  );

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameControllerChanged);
    _editStoreBloc.add(EditStoreEvent.started(widget.storeId));
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameControllerChanged);
    _nameController.dispose();
    _editStoreBloc.close();
    super.dispose();
  }

  /// The field is a shared `NewStoreTextField`, which exposes no `onChanged` —
  /// so the controller is the change source, exactly as `NewStorePage` does it.
  /// The bloc still owns the value; this only forwards it.
  void _onNameControllerChanged() =>
      _editStoreBloc.add(EditStoreEvent.nameChanged(_nameController.text));

  void _onClose() => context.goBack();

  /// The uid is read ONCE, at save time, from the live auth state — this bloc
  /// owns store editing and must not subscribe to another feature's state.
  /// Empty means signed out, and the logo is then kept locally only.
  void _onSave() => _editStoreBloc.add(
    EditStoreEvent.save(uid: context.read<AuthBloc>().state.uid),
  );

  /// Opens the source sheet and hands the outcome to the bloc as an intent.
  ///
  /// The OS picker is a system dialog, not app logic, so launching it stays in
  /// the UI layer — but only the resulting PATH goes to the bloc, which owns
  /// every staging decision from there. The bytes are never read here.
  Future<void> _onLogoTap() async {
    final source = await StoreLogoSourceSheet.show(
      context,
      hasLogo: _editStoreBloc.state.hasLogo,
    );
    if (source == null || !mounted) return;

    if (source == EStoreLogoSource.remove) {
      _editStoreBloc.add(const EditStoreEvent.logoRemoved());
      return;
    }

    // Flagged across BOTH the OS picker and the staging copy. Neither is
    // instant on a multi-megabyte photo, and without it the logo sits unchanged
    // with no feedback the whole time — indistinguishable from a tap that did
    // nothing.
    _editStoreBloc.add(const EditStoreEvent.logoPickStarted());

    try {
      final permissionRequester = getIt<PermissionRequester>();
      final file = source == EStoreLogoSource.camera
          ? await permissionRequester.onPickCamera(context)
          : await permissionRequester.onPickGallery(context);
      if (file == null) {
        _editStoreBloc.add(const EditStoreEvent.logoPickEnded());
        return;
      }

      _editStoreBloc.add(EditStoreEvent.logoPicked(file.path));
    } catch (_) {
      // A read that throws (a revoked permission, a file that vanished) must
      // still clear the flag — a stuck spinner over an unchanged logo is worse
      // than the failure itself, because it never resolves.
      _editStoreBloc.add(const EditStoreEvent.logoPickEnded());
    }
  }

  /// Seeds the controller once the store has loaded. Guarded on the transition
  /// INTO `editing` so a later rebuild cannot overwrite what the user is
  /// currently typing.
  bool _listenWhenLoaded(EditStoreState p, EditStoreState c) =>
      p.isLoading && c.isEditing;

  void _onLoaded(BuildContext context, EditStoreState state) =>
      _nameController.text = state.name;

  bool _listenWhenSaved(EditStoreState p, EditStoreState c) =>
      !p.isSaved && c.isSaved;

  /// Save persists and EXITS.
  void _onSaved(BuildContext context, EditStoreState state) {
    UiMessageService.showSuccess(AppLocalizations.of(context).tStoreSaved);
    context.goBack();
  }

  bool _listenWhenFailed(EditStoreState p, EditStoreState c) =>
      !p.isFailed && c.isFailed;

  void _onFailed(BuildContext context, EditStoreState state) =>
      UiMessageService.showError(
        AppLocalizations.of(context).tSaveFailedGeneric,
      );

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return BlocProvider<EditStoreBloc>.value(
      value: _editStoreBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<EditStoreBloc, EditStoreState>(
            listenWhen: _listenWhenLoaded,
            listener: _onLoaded,
          ),
          BlocListener<EditStoreBloc, EditStoreState>(
            listenWhen: _listenWhenSaved,
            listener: _onSaved,
          ),
          BlocListener<EditStoreBloc, EditStoreState>(
            listenWhen: _listenWhenFailed,
            listener: _onFailed,
          ),
        ],
        child: BlocBuilder<EditStoreBloc, EditStoreState>(
          builder: (context, state) => PopScope(
            // Blocked only WHILE a save runs. An upload is in flight, and
            // leaving mid-flight disposes the bloc that owns it: the save would
            // neither finish nor report, leaving the user believing an edit
            // landed that did not.
            //
            // `canPop` follows the live flag and is never a constant — this
            // screen stays dismissible at every other moment.
            canPop: !state.isSaving,
            child: Scaffold(
              backgroundColor: scheme.bg,
              body: SafeArea(
                child: EditStorePageBody(
                  state: state,
                  nameController: _nameController,
                  onLogoTap: _onLogoTap,
                  onSave: _onSave,
                  onClose: _onClose,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
