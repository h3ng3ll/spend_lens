import '../../../../product/domain/models/product/e_unit.dart';

/// One editable line on the Edit-receipt screen.
///
/// [rawName] mirrors the underlying `ReceiptItem.rawName` and is NEVER
/// reassigned by any edit here (spec §11) — [name] is the editable field.
class EditDraftItem {
  final String id;
  final String rawName;
  final String name;
  final double quantity;
  final EUnit unit;
  final double lineTotal;

  /// The product the user PINNED to this line via the picker, overriding
  /// whatever the normalizer would have matched.
  ///
  /// Null means "let the normalizer decide at save". Once set it can be
  /// replaced by another pick but never cleared — `copyWith` uses
  /// `?? this.productId`, so passing null leaves it — which is deliberate:
  /// there is no "un-pick" affordance, and an accidental clear would
  /// silently hand the line back to a matcher the user already corrected.
  final String? productId;

  const EditDraftItem({
    required this.id,
    required this.rawName,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.lineTotal,
    this.productId,
  });

  EditDraftItem copyWith({
    String? name,
    double? quantity,
    EUnit? unit,
    double? lineTotal,
    String? productId,
  }) {
    return EditDraftItem(
      id: id,
      rawName: rawName,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      lineTotal: lineTotal ?? this.lineTotal,
      productId: productId ?? this.productId,
    );
  }
}
