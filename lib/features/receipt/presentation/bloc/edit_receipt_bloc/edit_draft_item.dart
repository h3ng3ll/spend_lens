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

  const EditDraftItem({
    required this.id,
    required this.rawName,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.lineTotal,
  });

  EditDraftItem copyWith({
    String? name,
    double? quantity,
    double? lineTotal,
  }) {
    return EditDraftItem(
      id: id,
      rawName: rawName,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit,
      lineTotal: lineTotal ?? this.lineTotal,
    );
  }
}
