part of 'edit_store_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension EditStoreStateX on EditStoreState {
  bool get isLoading => status == EEditStoreStatus.loading;

  bool get isEditing => status == EEditStoreStatus.editing;

  bool get isSaving => status == EEditStoreStatus.saving;

  bool get isSaved => status == EEditStoreStatus.saved;

  bool get isFailed => status == EEditStoreStatus.failed;

  /// Alias for [isEditing] — the minimum `isReady` contract (A3 rule 9).
  bool get isReady => isEditing;

  /// Whether a logo is currently shown, and therefore whether the Remove
  /// affordance is offered at all — it appears ONLY when there is something
  /// to remove.
  bool get hasLogo => logoFilename.isNotEmpty;

  /// Whether the logo is busy — being picked/read, or being uploaded.
  ///
  /// One getter so the logo and the button cannot disagree about whether there
  /// is work in flight.
  bool get isLogoBusy => isPickingLogo || isUploadingLogo;

  /// Whether Save should be enabled: something actually changed, the name is
  /// still valid, and no save is already running.
  bool get canSave =>
      !isSaving &&
      // A save started mid-pick would commit the OLD logo and then race the
      // incoming bytes against a write already in flight.
      !isPickingLogo &&
      name.trim().isNotEmpty &&
      // No loaded record means there is nothing to compare against and
      // nothing to write — Save stays disabled rather than committing a form
      // built on no row at all.
      store != null &&
      (name.trim() != store!.name || hasPickedLogo || logoRemoved);
}
