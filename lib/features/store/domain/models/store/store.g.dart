// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Store _$StoreFromJson(Map<String, dynamic> json) => _Store(
  id: json['id'] as String,
  name: json['name'] as String,
  receiptAliases:
      (json['receiptAliases'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  type:
      $enumDecodeNullable(_$EStoreTypeEnumMap, json['type']) ??
      EStoreType.other,
  logoFilename: json['logoFilename'] as String?,
  logoUrl: json['logoUrl'] as String? ?? '',
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  syncStatus:
      $enumDecodeNullable(_$ESyncStatusEnumMap, json['syncStatus']) ??
      ESyncStatus.synced,
);

Map<String, dynamic> _$StoreToJson(_Store instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'receiptAliases': instance.receiptAliases,
  'type': _$EStoreTypeEnumMap[instance.type]!,
  'logoFilename': instance.logoFilename,
  'logoUrl': instance.logoUrl,
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'syncStatus': _$ESyncStatusEnumMap[instance.syncStatus]!,
};

const _$EStoreTypeEnumMap = {
  EStoreType.supermarket: 'supermarket',
  EStoreType.market: 'market',
  EStoreType.pharmacy: 'pharmacy',
  EStoreType.cafe: 'cafe',
  EStoreType.store: 'store',
  EStoreType.other: 'other',
};

const _$ESyncStatusEnumMap = {
  ESyncStatus.synced: 'synced',
  ESyncStatus.pendingCreate: 'pendingCreate',
  ESyncStatus.pendingUpdate: 'pendingUpdate',
  ESyncStatus.pendingDelete: 'pendingDelete',
};
