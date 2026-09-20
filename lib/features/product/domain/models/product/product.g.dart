// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  normalizedName: json['normalizedName'] as String,
  displayName: json['displayName'] as String,
  aliases:
      (json['aliases'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  defaultCategoryId: json['defaultCategoryId'] as String?,
  defaultUnit:
      $enumDecodeNullable(_$EUnitEnumMap, json['defaultUnit']) ?? EUnit.piece,
  storeId: json['storeId'] as String?,
  linkedProductIds:
      (json['linkedProductIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  imageFilename: json['imageFilename'] as String?,
  imageUrl: json['imageUrl'] as String? ?? '',
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  syncStatus:
      $enumDecodeNullable(_$ESyncStatusEnumMap, json['syncStatus']) ??
      ESyncStatus.synced,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'normalizedName': instance.normalizedName,
  'displayName': instance.displayName,
  'aliases': instance.aliases,
  'defaultCategoryId': instance.defaultCategoryId,
  'defaultUnit': _$EUnitEnumMap[instance.defaultUnit]!,
  'storeId': instance.storeId,
  'linkedProductIds': instance.linkedProductIds,
  'imageFilename': instance.imageFilename,
  'imageUrl': instance.imageUrl,
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
