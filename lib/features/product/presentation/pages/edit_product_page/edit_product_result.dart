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

  const EditProductResult({
    required this.displayName,
    required this.storeId,
    required this.categoryId,
    required this.unit,
  });
}
