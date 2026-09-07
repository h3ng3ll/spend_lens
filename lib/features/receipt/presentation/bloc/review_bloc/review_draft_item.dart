import '../../../../product/domain/models/product/e_unit.dart';

/// One staged, editable line on the Review screen — the UI-facing shape the
/// bloc holds BEFORE anything is written to Hive.
///
/// [rawName] mirrors `ReceiptItem.rawName` exactly and is NEVER reassigned
/// after creation (spec §11) — [name] is what the user edits/sees and what
/// eventually becomes `ReceiptItem.normalizedName`/`Product.displayName`.
class ReviewDraftItem {
  final String id;
  final String rawName;
  final String name;
  final double quantity;
  final EUnit unit;
  final double? unitPrice;
  final double lineTotal;
  final double confidence;
  final bool isLowConfidence;
  final bool isManuallyAdded;

  const ReviewDraftItem({
    required this.id,
    required this.rawName,
    required this.name,
    required this.quantity,
    required this.unit,
    this.unitPrice,
    required this.lineTotal,
    required this.confidence,
    this.isLowConfidence = false,
    this.isManuallyAdded = false,
  });

  ReviewDraftItem copyWith({
    String? name,
    double? quantity,
    EUnit? unit,
    double? unitPrice,
    double? lineTotal,
  }) {
    return ReviewDraftItem(
      id: id,
      rawName: rawName,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      confidence: confidence,
      isLowConfidence: isLowConfidence,
      isManuallyAdded: isManuallyAdded,
    );
  }
}
