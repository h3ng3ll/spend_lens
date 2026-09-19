part of 'edit_store_bloc.dart';

/// Intent events (BLoC rule A3.7) — the UI dispatches these and never branches
/// on state to choose between them.
@freezed
sealed class EditStoreEvent with _$EditStoreEvent {
  /// Loads the stored store into the form. Dispatched from the sheet's
  /// `initState` — this bloc is screen-scoped, so it is never dispatched from
  /// `main()`.
  const factory EditStoreEvent.started(String storeId) = _Started;

  const factory EditStoreEvent.nameChanged(String value) = _NameChanged;

  /// The OS picker is open, or its result is being read. Dispatched by the UI
  /// around that work — the picker is a system dialog, so the sheet owns the
  /// call while the bloc owns the state it produces.
  const factory EditStoreEvent.logoPickStarted() = _LogoPickStarted;

  /// The pick ended without an image: cancelled, or it failed to read.
  const factory EditStoreEvent.logoPickEnded() = _LogoPickEnded;

  /// A picked image, identified by its PATH on disk.
  ///
  /// Deliberately not its bytes: freezed would render a `Uint8List` field as a
  /// multi-megabyte decimal string in this event's `toString()`, which is the
  /// exact shape that once tombstoned this app through `AppObserver`. The
  /// picker hands back a file anyway, so a path costs nothing.
  const factory EditStoreEvent.logoPicked(String sourcePath) = _LogoPicked;

  /// Carries NO payload: removal is not a toggle and not a value, it is a
  /// single intent the handler interprets against current state.
  const factory EditStoreEvent.logoRemoved() = _LogoRemoved;

  /// Commits the staged edits.
  ///
  /// [uid] is the signed-in user, or empty when signed out — the logo is then
  /// kept locally with no upload attempted. Passed in rather than read from an
  /// auth repository here, because this bloc owns store editing and must not
  /// reach across to another feature's state.
  const factory EditStoreEvent.save({@Default('') String uid}) = _Save;
}
