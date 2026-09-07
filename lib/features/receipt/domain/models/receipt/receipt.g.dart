// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Receipt _$ReceiptFromJson(Map<String, dynamic> json) => _Receipt(
  id: json['id'] as String,
  storeId: json['storeId'] as String?,
  purchasedAt: DateTime.parse(json['purchasedAt'] as String),
  printedTotal: (json['printedTotal'] as num?)?.toDouble(),
  itemsTotal: (json['itemsTotal'] as num).toDouble(),
  discount: (json['discount'] as num?)?.toDouble(),
  currencyCode: json['currencyCode'] as String,
  categoryId: json['categoryId'] as String?,
  imagePath: json['imagePath'] as String?,
  itemIds:
      (json['itemIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  isReconciled: json['isReconciled'] as bool? ?? false,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  syncStatus:
      $enumDecodeNullable(_$ESyncStatusEnumMap, json['syncStatus']) ??
      ESyncStatus.synced,
);

Map<String, dynamic> _$ReceiptToJson(_Receipt instance) => <String, dynamic>{
  'id': instance.id,
  'storeId': instance.storeId,
  'purchasedAt': instance.purchasedAt.toIso8601String(),
  'printedTotal': instance.printedTotal,
  'itemsTotal': instance.itemsTotal,
  'discount': instance.discount,
  'currencyCode': instance.currencyCode,
  'categoryId': instance.categoryId,
  'imagePath': instance.imagePath,
  'itemIds': instance.itemIds,
  'isReconciled': instance.isReconciled,
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'syncStatus': _$ESyncStatusEnumMap[instance.syncStatus]!,
};

const _$ESyncStatusEnumMap = {
  ESyncStatus.synced: 'synced',
  ESyncStatus.pendingCreate: 'pendingCreate',
  ESyncStatus.pendingUpdate: 'pendingUpdate',
  ESyncStatus.pendingDelete: 'pendingDelete',
};
