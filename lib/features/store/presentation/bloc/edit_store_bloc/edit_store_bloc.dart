import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/services/store_logo_image_store/store_logo_image_store.dart';
import '../../../domain/models/store/store.dart';
import '../../../domain/repositories/i_store_local_repository.dart';
import '../../../domain/use_cases/remove_store_logo_use_case.dart';
import '../../../domain/use_cases/save_store_logo_use_case.dart';

part 'edit_store_event.dart';

part 'edit_store_state.dart';

part 'edit_store_state_ext.dart';

part 'edit_store_bloc.freezed.dart';

/// SCREEN-SCOPED bloc for the Edit Store sheet (BLoC rule A3.8) — built as a
/// field in the sheet's `State`, closed in `dispose`. Never registered in
/// `main()`.
///
/// **Every edit is STAGED and committed once, on Save**, the same contract
/// `EditProfileBloc` follows. Nothing here writes through on change: not a
/// keystroke, and not the logo. Tapping "Remove logo" only sets
/// [EditStoreState.logoRemoved]; the file and the remote object are deleted
/// when Save runs. Closing the sheet without saving therefore leaves the
/// stored store completely untouched.
///
/// The store is loaded by id rather than passed in whole: the sheet is opened
/// from a screen that already holds a `Store`, but re-reading guarantees the
/// commit is built on the CURRENT row rather than on a snapshot that a sync
/// pull may have superseded while the sheet was open.
class EditStoreBloc extends Bloc<EditStoreEvent, EditStoreState> {
  final IStoreLocalRepository _storeLocalRepository;
  final SaveStoreLogoUseCase _saveStoreLogo;
  final RemoveStoreLogoUseCase _removeStoreLogo;
  final StoreLogoImageStore _imageStore;

  EditStoreBloc({
    required IStoreLocalRepository storeLocalRepository,
    required SaveStoreLogoUseCase saveStoreLogo,
    required RemoveStoreLogoUseCase removeStoreLogo,
    required StoreLogoImageStore imageStore,
  }) : this._(
         storeLocalRepository,
         saveStoreLogo,
         removeStoreLogo,
         imageStore,
       );

  EditStoreBloc._(
    this._storeLocalRepository,
    this._saveStoreLogo,
    this._removeStoreLogo,
    this._imageStore,
  ) : super(const EditStoreState()) {
    on<_Started>(_onStarted);
    on<_NameChanged>(_onNameChanged);
    on<_LogoPickStarted>(_onLogoPickStarted);
    on<_LogoPickEnded>(_onLogoPickEnded);
    on<_LogoPicked>(_onLogoPicked);
    on<_LogoRemoved>(_onLogoRemoved);
    // `droppable()`: a second Save arriving while one is in flight would run
    // the upload and the box write twice, and the sheet is already closing on
    // the first one's success.
    on<_Save>(_onSave, transformer: droppable());
  }

  Future<void> _onStarted(_Started event, Emitter<EditStoreState> emit) async {
    emit(state.copyWith(status: EEditStoreStatus.loading));

    try {
      final store = await _storeLocalRepository.getById(event.storeId);
      if (store == null) {
        emit(state.copyWith(status: EEditStoreStatus.failed));
        return;
      }

      // A staged pick can survive a kill mid-edit; it belongs to a session the
      // user never committed, so it is discarded rather than silently adopted
      // by the next store the user opens.
      await _imageStore.discardStaged();

      emit(
        state.copyWith(
          status: EEditStoreStatus.editing,
          store: store,
          name: store.name,
          logoFilename: store.logoFilename ?? '',
          hasPickedLogo: false,
          logoRemoved: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: EEditStoreStatus.failed));
    }
  }

  void _onNameChanged(_NameChanged event, Emitter<EditStoreState> emit) =>
      emit(state.copyWith(name: event.value));

  void _onLogoPickStarted(
    _LogoPickStarted event,
    Emitter<EditStoreState> emit,
  ) => emit(state.copyWith(isPickingLogo: true));

  void _onLogoPickEnded(_LogoPickEnded event, Emitter<EditStoreState> emit) =>
      emit(state.copyWith(isPickingLogo: false));

  /// Stages a newly picked image. Clears [EditStoreState.logoRemoved]: picking
  /// after removing means the user changed their mind, and leaving the flag
  /// set would delete the image they just chose.
  Future<void> _onLogoPicked(
    _LogoPicked event,
    Emitter<EditStoreState> emit,
  ) async {
    // Copied file-to-file: the bytes are read and written inside the store and
    // never enter an event, a state, or Hive.
    final filename = await _imageStore.stageFrom(event.sourcePath);
    if (filename == null) {
      // The picked file vanished before it could be staged. Clear the spinner
      // rather than leaving it over a logo that will never change.
      emit(state.copyWith(isPickingLogo: false));
      return;
    }

    emit(
      state.copyWith(
        logoFilename: filename,
        hasPickedLogo: true,
        logoRemoved: false,
        // Cleared here too, not only by `_LogoPickEnded`: the image landing IS
        // the end of the pick, and leaving it set would spin forever over an
        // image already on screen.
        isPickingLogo: false,
      ),
    );
  }

  /// STAGES the removal — see the class doc. Drops any pending pick too, so
  /// pick-then-remove leaves nothing to upload.
  Future<void> _onLogoRemoved(
    _LogoRemoved event,
    Emitter<EditStoreState> emit,
  ) async {
    // Drops the STAGED file, never the stored one: the removal itself is still
    // staged and is only committed by Save.
    await _imageStore.discardStaged();
    emit(
      state.copyWith(
        logoRemoved: true,
        hasPickedLogo: false,
        logoFilename: '',
      ),
    );
  }

  /// Commits name + logo in one pass, then reports `saved` so the sheet can
  /// close itself.
  Future<void> _onSave(_Save event, Emitter<EditStoreState> emit) async {
    final trimmedName = state.name.trim();
    final loaded = state.store;
    // Both guards are the same guard: there is nothing to commit. A Save that
    // arrived before `_Started` resolved (or after it failed) would otherwise
    // write a record with no id.
    if (trimmedName.isEmpty || loaded == null) return;

    emit(state.copyWith(status: EEditStoreStatus.saving));

    try {
      var store = loaded.copyWith(
        name: trimmedName,
        updatedAt: DateTime.now(),
      );

      // Logo first: both branches return an updated store whose
      // `logoFilename`/`logoUrl` are then persisted by the SINGLE save below,
      // so a simultaneous name edit and logo change cannot overwrite each
      // other.
      //
      // A failed logo step does NOT abort the save. The name is local and has
      // nothing to do with Storage, so letting a remote failure take it down
      // would discard an edit that would otherwise have succeeded.
      var logoFailed = false;
      // Read back from the staging file only when there is a pick to commit,
      // so the bytes exist for the duration of the upload and no longer.
      final picked = state.hasPickedLogo
          ? await _imageStore.readBytes(state.logoFilename)
          : null;

      try {
        if (state.logoRemoved) {
          store = await _removeStoreLogo(store: store, uid: event.uid);
        } else if (picked != null) {
          // Flagged only around the UPLOAD, so the progress reports the phase
          // the user is actually waiting on rather than the whole save.
          emit(state.copyWith(isUploadingLogo: true));
          store = await _saveStoreLogo(
            store: store,
            bytes: picked,
            uid: event.uid,
          );
          emit(state.copyWith(isUploadingLogo: false));
        }
      } catch (_) {
        logoFailed = true;
        emit(state.copyWith(isUploadingLogo: false));
      }

      await _storeLocalRepository.save(store);

      // The pick is committed (or was never there) — the staging slot must not
      // outlive the save, or the next edit would open onto a stale image.
      await _imageStore.discardStaged();

      // Reported as FAILED even though the name was written: claiming success
      // while the logo silently did not save is the worse lie, and the toast
      // is the only signal the user gets.
      emit(
        state.copyWith(
          status: logoFailed
              ? EEditStoreStatus.failed
              : EEditStoreStatus.saved,
          store: store,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: EEditStoreStatus.failed));
    }
  }
}
