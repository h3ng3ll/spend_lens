// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_observation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PriceObservation _$PriceObservationFromJson(Map<String, dynamic> json) =>
    _PriceObservation(
      id: json['id'] as String,
      productId: json['productId'] as String,
      storeId: json['storeId'] as String?,
      receiptId: json['receiptId'] as String?,
      observedAt: DateTime.parse(json['observedAt'] as String),
      comparableUnitPrice: (json['comparableUnitPrice'] as num).toDouble(),
      unit: $enumDecodeNullable(_$EUnitEnumMap, json['unit']) ?? EUnit.piece,
      currencyCode: json['currencyCode'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      syncStatus:
          $enumDecodeNullable(_$ESyncStatusEnumMap, json['syncStatus']) ??
          ESyncStatus.synced,
    );

Map<String, dynamic> _$PriceObservationToJson(_PriceObservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'storeId': instance.storeId,
      'receiptId': instance.receiptId,
      'observedAt': instance.observedAt.toIso8601String(),
      'comparableUnitPrice': instance.comparableUnitPrice,
      'unit': _$EUnitEnumMap[instance.unit]!,
      'currencyCode': instance.currencyCode,
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
