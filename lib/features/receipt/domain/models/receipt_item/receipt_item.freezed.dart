// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReceiptItem {

 String get id;/// Literal text as first captured (OCR output or manual entry).
/// NEVER overwritten after creation — see class doc.
 String get rawName;/// Cleaned/canonicalized name — may change as normalization improves or
/// the user renames the underlying product match.
 String get normalizedName; String? get productId; double get quantity; EUnit get unit; double? get unitPrice; double get lineTotal;/// Parser confidence in [0, 1] for this line's extraction.
 double get confidence; bool get isLowConfidence; bool get isManuallyAdded;/// Position on the receipt — preserves print order across
/// re-normalization or re-ordering elsewhere in the pipeline.
 int get lineIndex; DateTime get updatedAt; DateTime? get deletedAt; ESyncStatus get syncStatus;
/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptItemCopyWith<ReceiptItem> get copyWith => _$ReceiptItemCopyWithImpl<ReceiptItem>(this as ReceiptItem, _$identity);

  /// Serializes this ReceiptItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptItem&&(identical(other.id, id) || other.id == id)&&(identical(other.rawName, rawName) || other.rawName == rawName)&&(identical(other.normalizedName, normalizedName) || other.normalizedName == normalizedName)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.isLowConfidence, isLowConfidence) || other.isLowConfidence == isLowConfidence)&&(identical(other.isManuallyAdded, isManuallyAdded) || other.isManuallyAdded == isManuallyAdded)&&(identical(other.lineIndex, lineIndex) || other.lineIndex == lineIndex)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,rawName,normalizedName,productId,quantity,unit,unitPrice,lineTotal,confidence,isLowConfidence,isManuallyAdded,lineIndex,updatedAt,deletedAt,syncStatus);

@override
String toString() {
  return 'ReceiptItem(id: $id, rawName: $rawName, normalizedName: $normalizedName, productId: $productId, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, lineTotal: $lineTotal, confidence: $confidence, isLowConfidence: $isLowConfidence, isManuallyAdded: $isManuallyAdded, lineIndex: $lineIndex, updatedAt: $updatedAt, deletedAt: $deletedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $ReceiptItemCopyWith<$Res>  {
  factory $ReceiptItemCopyWith(ReceiptItem value, $Res Function(ReceiptItem) _then) = _$ReceiptItemCopyWithImpl;
@useResult
$Res call({
 String id, String rawName, String normalizedName, String? productId, double quantity, EUnit unit, double? unitPrice, double lineTotal, double confidence, bool isLowConfidence, bool isManuallyAdded, int lineIndex, DateTime updatedAt, DateTime? deletedAt, ESyncStatus syncStatus
});




}
/// @nodoc
class _$ReceiptItemCopyWithImpl<$Res>
    implements $ReceiptItemCopyWith<$Res> {
  _$ReceiptItemCopyWithImpl(this._self, this._then);

  final ReceiptItem _self;
  final $Res Function(ReceiptItem) _then;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rawName = null,Object? normalizedName = null,Object? productId = freezed,Object? quantity = null,Object? unit = null,Object? unitPrice = freezed,Object? lineTotal = null,Object? confidence = null,Object? isLowConfidence = null,Object? isManuallyAdded = null,Object? lineIndex = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rawName: null == rawName ? _self.rawName : rawName // ignore: cast_nullable_to_non_nullable
as String,normalizedName: null == normalizedName ? _self.normalizedName : normalizedName // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as EUnit,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as double,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,isLowConfidence: null == isLowConfidence ? _self.isLowConfidence : isLowConfidence // ignore: cast_nullable_to_non_nullable
as bool,isManuallyAdded: null == isManuallyAdded ? _self.isManuallyAdded : isManuallyAdded // ignore: cast_nullable_to_non_nullable
as bool,lineIndex: null == lineIndex ? _self.lineIndex : lineIndex // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as ESyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptItem].
extension ReceiptItemPatterns on ReceiptItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptItem value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String rawName,  String normalizedName,  String? productId,  double quantity,  EUnit unit,  double? unitPrice,  double lineTotal,  double confidence,  bool isLowConfidence,  bool isManuallyAdded,  int lineIndex,  DateTime updatedAt,  DateTime? deletedAt,  ESyncStatus syncStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
return $default(_that.id,_that.rawName,_that.normalizedName,_that.productId,_that.quantity,_that.unit,_that.unitPrice,_that.lineTotal,_that.confidence,_that.isLowConfidence,_that.isManuallyAdded,_that.lineIndex,_that.updatedAt,_that.deletedAt,_that.syncStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String rawName,  String normalizedName,  String? productId,  double quantity,  EUnit unit,  double? unitPrice,  double lineTotal,  double confidence,  bool isLowConfidence,  bool isManuallyAdded,  int lineIndex,  DateTime updatedAt,  DateTime? deletedAt,  ESyncStatus syncStatus)  $default,) {final _that = this;
switch (_that) {
case _ReceiptItem():
return $default(_that.id,_that.rawName,_that.normalizedName,_that.productId,_that.quantity,_that.unit,_that.unitPrice,_that.lineTotal,_that.confidence,_that.isLowConfidence,_that.isManuallyAdded,_that.lineIndex,_that.updatedAt,_that.deletedAt,_that.syncStatus);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String rawName,  String normalizedName,  String? productId,  double quantity,  EUnit unit,  double? unitPrice,  double lineTotal,  double confidence,  bool isLowConfidence,  bool isManuallyAdded,  int lineIndex,  DateTime updatedAt,  DateTime? deletedAt,  ESyncStatus syncStatus)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
return $default(_that.id,_that.rawName,_that.normalizedName,_that.productId,_that.quantity,_that.unit,_that.unitPrice,_that.lineTotal,_that.confidence,_that.isLowConfidence,_that.isManuallyAdded,_that.lineIndex,_that.updatedAt,_that.deletedAt,_that.syncStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptItem implements ReceiptItem {
  const _ReceiptItem({required this.id, required this.rawName, required this.normalizedName, this.productId, required this.quantity, this.unit = EUnit.piece, this.unitPrice, required this.lineTotal, required this.confidence, this.isLowConfidence = false, this.isManuallyAdded = false, required this.lineIndex, required this.updatedAt, this.deletedAt, this.syncStatus = ESyncStatus.synced});
  factory _ReceiptItem.fromJson(Map<String, dynamic> json) => _$ReceiptItemFromJson(json);

@override final  String id;
/// Literal text as first captured (OCR output or manual entry).
/// NEVER overwritten after creation — see class doc.
@override final  String rawName;
/// Cleaned/canonicalized name — may change as normalization improves or
/// the user renames the underlying product match.
@override final  String normalizedName;
@override final  String? productId;
@override final  double quantity;
@override@JsonKey() final  EUnit unit;
@override final  double? unitPrice;
@override final  double lineTotal;
/// Parser confidence in [0, 1] for this line's extraction.
@override final  double confidence;
@override@JsonKey() final  bool isLowConfidence;
@override@JsonKey() final  bool isManuallyAdded;
/// Position on the receipt — preserves print order across
/// re-normalization or re-ordering elsewhere in the pipeline.
@override final  int lineIndex;
@override final  DateTime updatedAt;
@override final  DateTime? deletedAt;
@override@JsonKey() final  ESyncStatus syncStatus;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptItemCopyWith<_ReceiptItem> get copyWith => __$ReceiptItemCopyWithImpl<_ReceiptItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptItem&&(identical(other.id, id) || other.id == id)&&(identical(other.rawName, rawName) || other.rawName == rawName)&&(identical(other.normalizedName, normalizedName) || other.normalizedName == normalizedName)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.isLowConfidence, isLowConfidence) || other.isLowConfidence == isLowConfidence)&&(identical(other.isManuallyAdded, isManuallyAdded) || other.isManuallyAdded == isManuallyAdded)&&(identical(other.lineIndex, lineIndex) || other.lineIndex == lineIndex)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,rawName,normalizedName,productId,quantity,unit,unitPrice,lineTotal,confidence,isLowConfidence,isManuallyAdded,lineIndex,updatedAt,deletedAt,syncStatus);

@override
String toString() {
  return 'ReceiptItem(id: $id, rawName: $rawName, normalizedName: $normalizedName, productId: $productId, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, lineTotal: $lineTotal, confidence: $confidence, isLowConfidence: $isLowConfidence, isManuallyAdded: $isManuallyAdded, lineIndex: $lineIndex, updatedAt: $updatedAt, deletedAt: $deletedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$ReceiptItemCopyWith<$Res> implements $ReceiptItemCopyWith<$Res> {
  factory _$ReceiptItemCopyWith(_ReceiptItem value, $Res Function(_ReceiptItem) _then) = __$ReceiptItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String rawName, String normalizedName, String? productId, double quantity, EUnit unit, double? unitPrice, double lineTotal, double confidence, bool isLowConfidence, bool isManuallyAdded, int lineIndex, DateTime updatedAt, DateTime? deletedAt, ESyncStatus syncStatus
});




}
/// @nodoc
class __$ReceiptItemCopyWithImpl<$Res>
    implements _$ReceiptItemCopyWith<$Res> {
  __$ReceiptItemCopyWithImpl(this._self, this._then);

  final _ReceiptItem _self;
  final $Res Function(_ReceiptItem) _then;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rawName = null,Object? normalizedName = null,Object? productId = freezed,Object? quantity = null,Object? unit = null,Object? unitPrice = freezed,Object? lineTotal = null,Object? confidence = null,Object? isLowConfidence = null,Object? isManuallyAdded = null,Object? lineIndex = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncStatus = null,}) {
  return _then(_ReceiptItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rawName: null == rawName ? _self.rawName : rawName // ignore: cast_nullable_to_non_nullable
as String,normalizedName: null == normalizedName ? _self.normalizedName : normalizedName // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as EUnit,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as double,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,isLowConfidence: null == isLowConfidence ? _self.isLowConfidence : isLowConfidence // ignore: cast_nullable_to_non_nullable
as bool,isManuallyAdded: null == isManuallyAdded ? _self.isManuallyAdded : isManuallyAdded // ignore: cast_nullable_to_non_nullable
as bool,lineIndex: null == lineIndex ? _self.lineIndex : lineIndex // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as ESyncStatus,
  ));
}


}

// dart format on
