part of 'edit_store_bloc.dart';

enum EEditStoreStatus { loading, editing, saving, saved, failed }

@freezed
sealed class EditStoreState with _$EditStoreState {
  const factory EditStoreState({
    @Default(EEditStoreStatus.loading) EEditStoreStatus status,

    /// The record as loaded, carrying `id`/`type`/`receiptAliases`/`logoUrl`.
    /// The editable fields are held separately below so the form can be
    /// compared against this to detect real changes.
    ///
    /// Null until `_Started` resolves it. Nullable rather than defaulted to a
    /// placeholder because `Store.updatedAt` is a required `DateTime`, which
    /// cannot exist in a `const` default — and a non-const default would be a
    /// fake record the save path could mistake for a real one.
    Store? store,
    @Default('') String name,

    /// FILENAME of what the logo currently LOOKS like on screen — the stored
    /// image, the staged pick, or empty after a staged removal.
    ///
    /// Never the bytes. A `Uint8List` here would put `DeepCollectionEquality`
    /// in the generated `==`/`hashCode` on a state that re-emits every
    /// keystroke, and the raw bytes in `toString()`. See `AvatarImageStore`
    /// for the two defects that combination already caused in this app.
    @Default('') String logoFilename,

    /// Whether [logoFilename] points at a newly picked image awaiting Save.
    ///
    /// Distinct from the filename so Save knows whether there is anything to
    /// UPLOAD, rather than re-uploading the unchanged stored image every time.
    @Default(false) bool hasPickedLogo,

    /// Staged removal, applied on Save — never committed on tap.
    @Default(false) bool logoRemoved,

    /// Whether an image is being fetched from the OS picker and read into
    /// memory.
    ///
    /// Covers the gap between the source sheet closing and the picked bytes
    /// arriving: the picker itself, plus the staging copy of a multi-megabyte
    /// photo. Without it the logo sits unchanged with no feedback for
    /// seconds, which reads as a tap that did nothing.
    @Default(false) bool isPickingLogo,

    /// Whether the save is currently in its UPLOAD phase.
    ///
    /// Separate from [status] so the progress indicator can sit on the logo
    /// itself. Uploading an image is the slow, network-bound part and the one
    /// worth reporting; writing a name is instant and local.
    @Default(false) bool isUploadingLogo,
  }) = _EditStoreState;
}
