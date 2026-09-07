// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Receipt {

 String get id; String? get storeId; DateTime get purchasedAt;/// The total as printed on the receipt, before reconciliation. `null`
/// when OCR could not find a total keyword line.
 double? get printedTotal;/// The sum of this receipt's [ReceiptItem] line totals — always
/// computed, never null, so a mismatch against [printedTotal] can be
/// detected by the reconciler (spec §45).
 double get itemsTotal; double? get discount; String get currencyCode; String? get categoryId;/// Filename only (see class doc) — never a full path.
 String? get imagePath; List<String> get itemIds;/// Whether the user has confirmed/accepted the reconciler's total-match
/// check (spec §45 — a mismatch WARNS but always allows saving).
 bool get isReconciled; DateTime get updatedAt; DateTime? get deletedAt; ESyncStatus get syncStatus;
/// Create a copy of Receipt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptCopyWith<Receipt> get copyWith => _$ReceiptCopyWithImpl<Receipt>(this as Receipt, _$identity);

  /// Serializes this Receipt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Receipt&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.purchasedAt, purchasedAt) || other.purchasedAt == purchasedAt)&&(identical(other.printedTotal, printedTotal) || other.printedTotal == printedTotal)&&(identical(other.itemsTotal, itemsTotal) || other.itemsTotal == itemsTotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&const DeepCollectionEquality().equals(other.itemIds, itemIds)&&(identical(other.isReconciled, isReconciled) || other.isReconciled == isReconciled)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,purchasedAt,printedTotal,itemsTotal,discount,currencyCode,categoryId,imagePath,const DeepCollectionEquality().hash(itemIds),isReconciled,updatedAt,deletedAt,syncStatus);

@override
String toString() {
  return 'Receipt(id: $id, storeId: $storeId, purchasedAt: $purchasedAt, printedTotal: $printedTotal, itemsTotal: $itemsTotal, discount: $discount, currencyCode: $currencyCode, categoryId: $categoryId, imagePath: $imagePath, itemIds: $itemIds, isReconciled: $isReconciled, updatedAt: $updatedAt, deletedAt: $deletedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $ReceiptCopyWith<$Res>  {
  factory $ReceiptCopyWith(Receipt value, $Res Function(Receipt) _then) = _$ReceiptCopyWithImpl;
@useResult
$Res call({
 String id, String? storeId, DateTime purchasedAt, double? printedTotal, double itemsTotal, double? discount, String currencyCode, String? categoryId, String? imagePath, List<String> itemIds, bool isReconciled, DateTime updatedAt, DateTime? deletedAt, ESyncStatus syncStatus
});




}
/// @nodoc
class _$ReceiptCopyWithImpl<$Res>
    implements $ReceiptCopyWith<$Res> {
  _$ReceiptCopyWithImpl(this._self, this._then);

  final Receipt _self;
  final $Res Function(Receipt) _then;

/// Create a copy of Receipt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeId = freezed,Object? purchasedAt = null,Object? printedTotal = freezed,Object? itemsTotal = null,Object? discount = freezed,Object? currencyCode = null,Object? categoryId = freezed,Object? imagePath = freezed,Object? itemIds = null,Object? isReconciled = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,purchasedAt: null == purchasedAt ? _self.purchasedAt : purchasedAt // ignore: cast_nullable_to_non_nullable
as DateTime,printedTotal: freezed == printedTotal ? _self.printedTotal : printedTotal // ignore: cast_nullable_to_non_nullable
as double?,itemsTotal: null == itemsTotal ? _self.itemsTotal : itemsTotal // ignore: cast_nullable_to_non_nullable
as double,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double?,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,itemIds: null == itemIds ? _self.itemIds : itemIds // ignore: cast_nullable_to_non_nullable
as List<String>,isReconciled: null == isReconciled ? _self.isReconciled : isReconciled // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as ESyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Receipt].
extension ReceiptPatterns on Receipt {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Receipt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Receipt() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Receipt value)  $default,){
final _that = this;
switch (_that) {
case _Receipt():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Receipt value)?  $default,){
final _that = this;
switch (_that) {
case _Receipt() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? storeId,  DateTime purchasedAt,  double? printedTotal,  double itemsTotal,  double? discount,  String currencyCode,  String? categoryId,  String? imagePath,  List<String> itemIds,  bool isReconciled,  DateTime updatedAt,  DateTime? deletedAt,  ESyncStatus syncStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Receipt() when $default != null:
return $default(_that.id,_that.storeId,_that.purchasedAt,_that.printedTotal,_that.itemsTotal,_that.discount,_that.currencyCode,_that.categoryId,_that.imagePath,_that.itemIds,_that.isReconciled,_that.updatedAt,_that.deletedAt,_that.syncStatus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? storeId,  DateTime purchasedAt,  double? printedTotal,  double itemsTotal,  double? discount,  String currencyCode,  String? categoryId,  String? imagePath,  List<String> itemIds,  bool isReconciled,  DateTime updatedAt,  DateTime? deletedAt,  ESyncStatus syncStatus)  $default,) {final _that = this;
switch (_that) {
case _Receipt():
return $default(_that.id,_that.storeId,_that.purchasedAt,_that.printedTotal,_that.itemsTotal,_that.discount,_that.currencyCode,_that.categoryId,_that.imagePath,_that.itemIds,_that.isReconciled,_that.updatedAt,_that.deletedAt,_that.syncStatus);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? storeId,  DateTime purchasedAt,  double? printedTotal,  double itemsTotal,  double? discount,  String currencyCode,  String? categoryId,  String? imagePath,  List<String> itemIds,  bool isReconciled,  DateTime updatedAt,  DateTime? deletedAt,  ESyncStatus syncStatus)?  $default,) {final _that = this;
switch (_that) {
case _Receipt() when $default != null:
return $default(_that.id,_that.storeId,_that.purchasedAt,_that.printedTotal,_that.itemsTotal,_that.discount,_that.currencyCode,_that.categoryId,_that.imagePath,_that.itemIds,_that.isReconciled,_that.updatedAt,_that.deletedAt,_that.syncStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Receipt implements Receipt {
  const _Receipt({required this.id, this.storeId, required this.purchasedAt, this.printedTotal, required this.itemsTotal, this.discount, required this.currencyCode, this.categoryId, this.imagePath, final  List<String> itemIds = const <String>[], this.isReconciled = false, required this.updatedAt, this.deletedAt, this.syncStatus = ESyncStatus.synced}): _itemIds = itemIds;
  factory _Receipt.fromJson(Map<String, dynamic> json) => _$ReceiptFromJson(json);

@override final  String id;
@override final  String? storeId;
@override final  DateTime purchasedAt;
/// The total as printed on the receipt, before reconciliation. `null`
/// when OCR could not find a total keyword line.
@override final  double? printedTotal;
/// The sum of this receipt's [ReceiptItem] line totals — always
/// computed, never null, so a mismatch against [printedTotal] can be
/// detected by the reconciler (spec §45).
@override final  double itemsTotal;
@override final  double? discount;
@override final  String currencyCode;
@override final  String? categoryId;
/// Filename only (see class doc) — never a full path.
@override final  String? imagePath;
 final  List<String> _itemIds;
@override@JsonKey() List<String> get itemIds {
  if (_itemIds is EqualUnmodifiableListView) return _itemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itemIds);
}

/// Whether the user has confirmed/accepted the reconciler's total-match
/// check (spec §45 — a mismatch WARNS but always allows saving).
@override@JsonKey() final  bool isReconciled;
@override final  DateTime updatedAt;
@override final  DateTime? deletedAt;
@override@JsonKey() final  ESyncStatus syncStatus;

/// Create a copy of Receipt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptCopyWith<_Receipt> get copyWith => __$ReceiptCopyWithImpl<_Receipt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Receipt&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.purchasedAt, purchasedAt) || other.purchasedAt == purchasedAt)&&(identical(other.printedTotal, printedTotal) || other.printedTotal == printedTotal)&&(identical(other.itemsTotal, itemsTotal) || other.itemsTotal == itemsTotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&const DeepCollectionEquality().equals(other._itemIds, _itemIds)&&(identical(other.isReconciled, isReconciled) || other.isReconciled == isReconciled)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,purchasedAt,printedTotal,itemsTotal,discount,currencyCode,categoryId,imagePath,const DeepCollectionEquality().hash(_itemIds),isReconciled,updatedAt,deletedAt,syncStatus);

@override
String toString() {
  return 'Receipt(id: $id, storeId: $storeId, purchasedAt: $purchasedAt, printedTotal: $printedTotal, itemsTotal: $itemsTotal, discount: $discount, currencyCode: $currencyCode, categoryId: $categoryId, imagePath: $imagePath, itemIds: $itemIds, isReconciled: $isReconciled, updatedAt: $updatedAt, deletedAt: $deletedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$ReceiptCopyWith<$Res> implements $ReceiptCopyWith<$Res> {
  factory _$ReceiptCopyWith(_Receipt value, $Res Function(_Receipt) _then) = __$ReceiptCopyWithImpl;
@override @useResult
$Res call({
 String id, String? storeId, DateTime purchasedAt, double? printedTotal, double itemsTotal, double? discount, String currencyCode, String? categoryId, String? imagePath, List<String> itemIds, bool isReconciled, DateTime updatedAt, DateTime? deletedAt, ESyncStatus syncStatus
});




}
/// @nodoc
class __$ReceiptCopyWithImpl<$Res>
    implements _$ReceiptCopyWith<$Res> {
  __$ReceiptCopyWithImpl(this._self, this._then);

  final _Receipt _self;
  final $Res Function(_Receipt) _then;

/// Create a copy of Receipt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeId = freezed,Object? purchasedAt = null,Object? printedTotal = freezed,Object? itemsTotal = null,Object? discount = freezed,Object? currencyCode = null,Object? categoryId = freezed,Object? imagePath = freezed,Object? itemIds = null,Object? isReconciled = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncStatus = null,}) {
  return _then(_Receipt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,purchasedAt: null == purchasedAt ? _self.purchasedAt : purchasedAt // ignore: cast_nullable_to_non_nullable
as DateTime,printedTotal: freezed == printedTotal ? _self.printedTotal : printedTotal // ignore: cast_nullable_to_non_nullable
as double?,itemsTotal: null == itemsTotal ? _self.itemsTotal : itemsTotal // ignore: cast_nullable_to_non_nullable
as double,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double?,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,itemIds: null == itemIds ? _self._itemIds : itemIds // ignore: cast_nullable_to_non_nullable
as List<String>,isReconciled: null == isReconciled ? _self.isReconciled : isReconciled // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as ESyncStatus,
  ));
}


}

// dart format on
