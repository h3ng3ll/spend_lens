// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  name: json['name'] as String,
  colorHex: json['colorHex'] as String,
  isBuiltIn: json['isBuiltIn'] as bool,
  keywords:
      (json['keywords'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  syncStatus:
      $enumDecodeNullable(_$ESyncStatusEnumMap, json['syncStatus']) ??
      ESyncStatus.synced,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'colorHex': instance.colorHex,
  'isBuiltIn': instance.isBuiltIn,
  'keywords': instance.keywords,
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
