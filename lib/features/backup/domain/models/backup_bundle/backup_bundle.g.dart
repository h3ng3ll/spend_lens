// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_bundle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupBundle _$BackupBundleFromJson(Map<String, dynamic> json) =>
    _BackupBundle(
      schemaVersion: (json['schemaVersion'] as num).toInt(),
      exportedAt: DateTime.parse(json['exportedAt'] as String),
      receipts:
          (json['receipts'] as List<dynamic>?)
              ?.map((e) => Receipt.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Receipt>[],
      receiptItems:
          (json['receiptItems'] as List<dynamic>?)
              ?.map((e) => ReceiptItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ReceiptItem>[],
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Product>[],
      stores:
          (json['stores'] as List<dynamic>?)
              ?.map((e) => Store.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Store>[],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Category>[],
      expenses:
          (json['expenses'] as List<dynamic>?)
              ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Expense>[],
      priceObservations:
          (json['priceObservations'] as List<dynamic>?)
              ?.map((e) => PriceObservation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PriceObservation>[],
    );

Map<String, dynamic> _$BackupBundleToJson(_BackupBundle instance) =>
    <String, dynamic>{
      'schemaVersion': instance.schemaVersion,
      'exportedAt': instance.exportedAt.toIso8601String(),
      'receipts': instance.receipts,
      'receiptItems': instance.receiptItems,
      'products': instance.products,
      'stores': instance.stores,
      'categories': instance.categories,
      'expenses': instance.expenses,
      'priceObservations': instance.priceObservations,
    };
