// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReceiptItem _$ReceiptItemFromJson(Map<String, dynamic> json) => _ReceiptItem(
  id: json['id'] as String,
  rawName: json['rawName'] as String,
  normalizedName: json['normalizedName'] as String,
  productId: json['productId'] as String?,
  quantity: (json['quantity'] as num).toDouble(),
  unit: $enumDecodeNullable(_$EUnitEnumMap, json['unit']) ?? EUnit.piece,
  unitPrice: (json['unitPrice'] as num?)?.toDouble(),
  lineTotal: (json['lineTotal'] as num).toDouble(),
  confidence: (json['confidence'] as num).toDouble(),
  isLowConfidence: json['isLowConfidence'] as bool? ?? false,
  isManuallyAdded: json['isManuallyAdded'] as bool? ?? false,
  lineIndex: (json['lineIndex'] as num).toInt(),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  syncStatus:
      $enumDecodeNullable(_$ESyncStatusEnumMap, json['syncStatus']) ??
      ESyncStatus.synced,
);

Map<String, dynamic> _$ReceiptItemToJson(_ReceiptItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rawName': instance.rawName,
      'normalizedName': instance.normalizedName,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'unit': _$EUnitEnumMap[instance.unit]!,
      'unitPrice': instance.unitPrice,
      'lineTotal': instance.lineTotal,
      'confidence': instance.confidence,
      'isLowConfidence': instance.isLowConfidence,
      'isManuallyAdded': instance.isManuallyAdded,
      'lineIndex': instance.lineIndex,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'syncStatus': _$ESyncStatusEnumMap[instance.syncStatus]!,
    };

const _$EUnitEnumMap = {
  EUnit.piece: 'piece',
  EUnit.kilogram: 'kilogram',
  EUnit.liter: 'liter',
};

const _$ESyncStatusEnumMap = {
  ESyncStatus.synced: 'synced',
  ESyncStatus.pendingCreate: 'pendingCreate',
  ESyncStatus.pendingUpdate: 'pendingUpdate',
  ESyncStatus.pendingDelete: 'pendingDelete',
};
