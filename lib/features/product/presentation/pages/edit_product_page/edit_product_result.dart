import '../../../domain/models/product/e_unit.dart';

/// What `EditProductPage` returns — a named class, never a Dart record, per
/// the project's discipline for structured values.
///
/// [storeId] is nullable and its null is MEANINGFUL: it is the user choosing
/// "make general purpose", not an absent answer. The caller compares each
/// field against the product it started from and dispatches only what
/// actually changed.
class EditProductResult {
  final String displayName;
  final String? storeId;
  final String? categoryId;
  final EUnit unit;

  /// The STAGED photo's filename, or null when the photo was left alone.
  ///
  /// A pick is staged, never committed on tap — the page writes nothing, so
  /// the caller commits it alongside the other edits. Distinguishing "not
  /// touched" from "removed" needs two fields rather than one nullable, see
  /// [imageRemoved].
  final String? stagedImageFilename;

  /// Whether the user chose to REMOVE the existing photo.
  ///
  /// Separate from [stagedImageFilename] because a null filename is
  /// ambiguous on its own: it means both "no new pick" and "clear it". The
  /// removal is staged and takes effect on Save, per
  /// `edit_profile_screen_rules.md`.
  final bool imageRemoved;

  const EditProductResult({
    required this.displayName,
    required this.storeId,
    required this.categoryId,
    required this.unit,
    this.stagedImageFilename,
    this.imageRemoved = false,
  });
}
