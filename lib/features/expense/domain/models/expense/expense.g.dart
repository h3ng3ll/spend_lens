// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: json['id'] as String,
  amount: (json['amount'] as num).toDouble(),
  currencyCode: json['currencyCode'] as String,
  categoryId: json['categoryId'] as String,
  storeId: json['storeId'] as String?,
  note: json['note'] as String?,
  occurredAt: DateTime.parse(json['occurredAt'] as String),
  source:
      $enumDecodeNullable(_$EExpenseSourceEnumMap, json['source']) ??
      EExpenseSource.cash,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  syncStatus:
      $enumDecodeNullable(_$ESyncStatusEnumMap, json['syncStatus']) ??
      ESyncStatus.synced,
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'currencyCode': instance.currencyCode,
  'categoryId': instance.categoryId,
  'storeId': instance.storeId,
  'note': instance.note,
  'occurredAt': instance.occurredAt.toIso8601String(),
  'source': _$EExpenseSourceEnumMap[instance.source]!,
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'syncStatus': _$ESyncStatusEnumMap[instance.syncStatus]!,
};

const _$EExpenseSourceEnumMap = {
  EExpenseSource.receipt: 'receipt',
  EExpenseSource.cash: 'cash',
};

const _$ESyncStatusEnumMap = {
  ESyncStatus.synced: 'synced',
  ESyncStatus.pendingCreate: 'pendingCreate',
  ESyncStatus.pendingUpdate: 'pendingUpdate',
  ESyncStatus.pendingDelete: 'pendingDelete',
};
