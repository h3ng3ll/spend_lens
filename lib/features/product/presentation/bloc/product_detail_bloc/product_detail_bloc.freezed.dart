// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_detail_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductDetailEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductDetailEvent()';
}


}

/// @nodoc
class $ProductDetailEventCopyWith<$Res>  {
$ProductDetailEventCopyWith(ProductDetailEvent _, $Res Function(ProductDetailEvent) __);
}


/// Adds pattern-matching-related methods to [ProductDetailEvent].
extension ProductDetailEventPatterns on ProductDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,TResult Function( _AddPrice value)?  addPrice,TResult Function( _UpdatePrice value)?  updatePrice,TResult Function( _DeletePrice value)?  deletePrice,TResult Function( _Rename value)?  rename,TResult Function( _SetCategory value)?  setCategory,TResult Function( _SetUnit value)?  setUnit,TResult Function( _SetStore value)?  setStore,TResult Function( _DeleteProduct value)?  deleteProduct,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _AddPrice() when addPrice != null:
return addPrice(_that);case _UpdatePrice() when updatePrice != null:
return updatePrice(_that);case _DeletePrice() when deletePrice != null:
return deletePrice(_that);case _Rename() when rename != null:
return rename(_that);case _SetCategory() when setCategory != null:
return setCategory(_that);case _SetUnit() when setUnit != null:
return setUnit(_that);case _SetStore() when setStore != null:
return setStore(_that);case _DeleteProduct() when deleteProduct != null:
return deleteProduct(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,required TResult Function( _AddPrice value)  addPrice,required TResult Function( _UpdatePrice value)  updatePrice,required TResult Function( _DeletePrice value)  deletePrice,required TResult Function( _Rename value)  rename,required TResult Function( _SetCategory value)  setCategory,required TResult Function( _SetUnit value)  setUnit,required TResult Function( _SetStore value)  setStore,required TResult Function( _DeleteProduct value)  deleteProduct,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);case _AddPrice():
return addPrice(_that);case _UpdatePrice():
return updatePrice(_that);case _DeletePrice():
return deletePrice(_that);case _Rename():
return rename(_that);case _SetCategory():
return setCategory(_that);case _SetUnit():
return setUnit(_that);case _SetStore():
return setStore(_that);case _DeleteProduct():
return deleteProduct(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,TResult? Function( _AddPrice value)?  addPrice,TResult? Function( _UpdatePrice value)?  updatePrice,TResult? Function( _DeletePrice value)?  deletePrice,TResult? Function( _Rename value)?  rename,TResult? Function( _SetCategory value)?  setCategory,TResult? Function( _SetUnit value)?  setUnit,TResult? Function( _SetStore value)?  setStore,TResult? Function( _DeleteProduct value)?  deleteProduct,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _AddPrice() when addPrice != null:
return addPrice(_that);case _UpdatePrice() when updatePrice != null:
return updatePrice(_that);case _DeletePrice() when deletePrice != null:
return deletePrice(_that);case _Rename() when rename != null:
return rename(_that);case _SetCategory() when setCategory != null:
return setCategory(_that);case _SetUnit() when setUnit != null:
return setUnit(_that);case _SetStore() when setStore != null:
return setStore(_that);case _DeleteProduct() when deleteProduct != null:
return deleteProduct(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  watch,TResult Function( double unitPrice,  DateTime observedAt,  String? storeId,  String currencyCode)?  addPrice,TResult Function( String observationId,  double unitPrice,  DateTime observedAt,  String? storeId)?  updatePrice,TResult Function( String observationId)?  deletePrice,TResult Function( String displayName)?  rename,TResult Function( String categoryId)?  setCategory,TResult Function( EUnit unit)?  setUnit,TResult Function( String? storeId)?  setStore,TResult Function()?  deleteProduct,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _AddPrice() when addPrice != null:
return addPrice(_that.unitPrice,_that.observedAt,_that.storeId,_that.currencyCode);case _UpdatePrice() when updatePrice != null:
return updatePrice(_that.observationId,_that.unitPrice,_that.observedAt,_that.storeId);case _DeletePrice() when deletePrice != null:
return deletePrice(_that.observationId);case _Rename() when rename != null:
return rename(_that.displayName);case _SetCategory() when setCategory != null:
return setCategory(_that.categoryId);case _SetUnit() when setUnit != null:
return setUnit(_that.unit);case _SetStore() when setStore != null:
return setStore(_that.storeId);case _DeleteProduct() when deleteProduct != null:
return deleteProduct();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  watch,required TResult Function( double unitPrice,  DateTime observedAt,  String? storeId,  String currencyCode)  addPrice,required TResult Function( String observationId,  double unitPrice,  DateTime observedAt,  String? storeId)  updatePrice,required TResult Function( String observationId)  deletePrice,required TResult Function( String displayName)  rename,required TResult Function( String categoryId)  setCategory,required TResult Function( EUnit unit)  setUnit,required TResult Function( String? storeId)  setStore,required TResult Function()  deleteProduct,}) {final _that = this;
switch (_that) {
case _Watch():
return watch();case _AddPrice():
return addPrice(_that.unitPrice,_that.observedAt,_that.storeId,_that.currencyCode);case _UpdatePrice():
return updatePrice(_that.observationId,_that.unitPrice,_that.observedAt,_that.storeId);case _DeletePrice():
return deletePrice(_that.observationId);case _Rename():
return rename(_that.displayName);case _SetCategory():
return setCategory(_that.categoryId);case _SetUnit():
return setUnit(_that.unit);case _SetStore():
return setStore(_that.storeId);case _DeleteProduct():
return deleteProduct();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  watch,TResult? Function( double unitPrice,  DateTime observedAt,  String? storeId,  String currencyCode)?  addPrice,TResult? Function( String observationId,  double unitPrice,  DateTime observedAt,  String? storeId)?  updatePrice,TResult? Function( String observationId)?  deletePrice,TResult? Function( String displayName)?  rename,TResult? Function( String categoryId)?  setCategory,TResult? Function( EUnit unit)?  setUnit,TResult? Function( String? storeId)?  setStore,TResult? Function()?  deleteProduct,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _AddPrice() when addPrice != null:
return addPrice(_that.unitPrice,_that.observedAt,_that.storeId,_that.currencyCode);case _UpdatePrice() when updatePrice != null:
return updatePrice(_that.observationId,_that.unitPrice,_that.observedAt,_that.storeId);case _DeletePrice() when deletePrice != null:
return deletePrice(_that.observationId);case _Rename() when rename != null:
return rename(_that.displayName);case _SetCategory() when setCategory != null:
return setCategory(_that.categoryId);case _SetUnit() when setUnit != null:
return setUnit(_that.unit);case _SetStore() when setStore != null:
return setStore(_that.storeId);case _DeleteProduct() when deleteProduct != null:
return deleteProduct();case _:
  return null;

}
}

}

/// @nodoc


class _Watch implements ProductDetailEvent {
  const _Watch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductDetailEvent.watch()';
}


}




/// @nodoc


class _AddPrice implements ProductDetailEvent {
  const _AddPrice({required this.unitPrice, required this.observedAt, required this.storeId, required this.currencyCode});
  

 final  double unitPrice;
 final  DateTime observedAt;
 final  String? storeId;
 final  String currencyCode;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddPriceCopyWith<_AddPrice> get copyWith => __$AddPriceCopyWithImpl<_AddPrice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddPrice&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode));
}


@override
int get hashCode => Object.hash(runtimeType,unitPrice,observedAt,storeId,currencyCode);

@override
String toString() {
  return 'ProductDetailEvent.addPrice(unitPrice: $unitPrice, observedAt: $observedAt, storeId: $storeId, currencyCode: $currencyCode)';
}


}

/// @nodoc
abstract mixin class _$AddPriceCopyWith<$Res> implements $ProductDetailEventCopyWith<$Res> {
  factory _$AddPriceCopyWith(_AddPrice value, $Res Function(_AddPrice) _then) = __$AddPriceCopyWithImpl;
@useResult
$Res call({
 double unitPrice, DateTime observedAt, String? storeId, String currencyCode
});




}
/// @nodoc
class __$AddPriceCopyWithImpl<$Res>
    implements _$AddPriceCopyWith<$Res> {
  __$AddPriceCopyWithImpl(this._self, this._then);

  final _AddPrice _self;
  final $Res Function(_AddPrice) _then;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? unitPrice = null,Object? observedAt = null,Object? storeId = freezed,Object? currencyCode = null,}) {
  return _then(_AddPrice(
unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _UpdatePrice implements ProductDetailEvent {
  const _UpdatePrice({required this.observationId, required this.unitPrice, required this.observedAt, required this.storeId});
  

 final  String observationId;
 final  double unitPrice;
 final  DateTime observedAt;
 final  String? storeId;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatePriceCopyWith<_UpdatePrice> get copyWith => __$UpdatePriceCopyWithImpl<_UpdatePrice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdatePrice&&(identical(other.observationId, observationId) || other.observationId == observationId)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.storeId, storeId) || other.storeId == storeId));
}


@override
int get hashCode => Object.hash(runtimeType,observationId,unitPrice,observedAt,storeId);

@override
String toString() {
  return 'ProductDetailEvent.updatePrice(observationId: $observationId, unitPrice: $unitPrice, observedAt: $observedAt, storeId: $storeId)';
}


}

/// @nodoc
abstract mixin class _$UpdatePriceCopyWith<$Res> implements $ProductDetailEventCopyWith<$Res> {
  factory _$UpdatePriceCopyWith(_UpdatePrice value, $Res Function(_UpdatePrice) _then) = __$UpdatePriceCopyWithImpl;
@useResult
$Res call({
 String observationId, double unitPrice, DateTime observedAt, String? storeId
});




}
/// @nodoc
class __$UpdatePriceCopyWithImpl<$Res>
    implements _$UpdatePriceCopyWith<$Res> {
  __$UpdatePriceCopyWithImpl(this._self, this._then);

  final _UpdatePrice _self;
  final $Res Function(_UpdatePrice) _then;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? observationId = null,Object? unitPrice = null,Object? observedAt = null,Object? storeId = freezed,}) {
  return _then(_UpdatePrice(
observationId: null == observationId ? _self.observationId : observationId // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _DeletePrice implements ProductDetailEvent {
  const _DeletePrice(this.observationId);
  

 final  String observationId;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletePriceCopyWith<_DeletePrice> get copyWith => __$DeletePriceCopyWithImpl<_DeletePrice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletePrice&&(identical(other.observationId, observationId) || other.observationId == observationId));
}


@override
int get hashCode => Object.hash(runtimeType,observationId);

@override
String toString() {
  return 'ProductDetailEvent.deletePrice(observationId: $observationId)';
}


}

/// @nodoc
abstract mixin class _$DeletePriceCopyWith<$Res> implements $ProductDetailEventCopyWith<$Res> {
  factory _$DeletePriceCopyWith(_DeletePrice value, $Res Function(_DeletePrice) _then) = __$DeletePriceCopyWithImpl;
@useResult
$Res call({
 String observationId
});




}
/// @nodoc
class __$DeletePriceCopyWithImpl<$Res>
    implements _$DeletePriceCopyWith<$Res> {
  __$DeletePriceCopyWithImpl(this._self, this._then);

  final _DeletePrice _self;
  final $Res Function(_DeletePrice) _then;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? observationId = null,}) {
  return _then(_DeletePrice(
null == observationId ? _self.observationId : observationId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Rename implements ProductDetailEvent {
  const _Rename(this.displayName);
  

 final  String displayName;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenameCopyWith<_Rename> get copyWith => __$RenameCopyWithImpl<_Rename>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Rename&&(identical(other.displayName, displayName) || other.displayName == displayName));
}


@override
int get hashCode => Object.hash(runtimeType,displayName);

@override
String toString() {
  return 'ProductDetailEvent.rename(displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$RenameCopyWith<$Res> implements $ProductDetailEventCopyWith<$Res> {
  factory _$RenameCopyWith(_Rename value, $Res Function(_Rename) _then) = __$RenameCopyWithImpl;
@useResult
$Res call({
 String displayName
});




}
/// @nodoc
class __$RenameCopyWithImpl<$Res>
    implements _$RenameCopyWith<$Res> {
  __$RenameCopyWithImpl(this._self, this._then);

  final _Rename _self;
  final $Res Function(_Rename) _then;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? displayName = null,}) {
  return _then(_Rename(
null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SetCategory implements ProductDetailEvent {
  const _SetCategory(this.categoryId);
  

 final  String categoryId;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetCategoryCopyWith<_SetCategory> get copyWith => __$SetCategoryCopyWithImpl<_SetCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetCategory&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId);

@override
String toString() {
  return 'ProductDetailEvent.setCategory(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$SetCategoryCopyWith<$Res> implements $ProductDetailEventCopyWith<$Res> {
  factory _$SetCategoryCopyWith(_SetCategory value, $Res Function(_SetCategory) _then) = __$SetCategoryCopyWithImpl;
@useResult
$Res call({
 String categoryId
});




}
/// @nodoc
class __$SetCategoryCopyWithImpl<$Res>
    implements _$SetCategoryCopyWith<$Res> {
  __$SetCategoryCopyWithImpl(this._self, this._then);

  final _SetCategory _self;
  final $Res Function(_SetCategory) _then;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = null,}) {
  return _then(_SetCategory(
null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SetUnit implements ProductDetailEvent {
  const _SetUnit(this.unit);
  

 final  EUnit unit;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetUnitCopyWith<_SetUnit> get copyWith => __$SetUnitCopyWithImpl<_SetUnit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetUnit&&(identical(other.unit, unit) || other.unit == unit));
}


@override
int get hashCode => Object.hash(runtimeType,unit);

@override
String toString() {
  return 'ProductDetailEvent.setUnit(unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$SetUnitCopyWith<$Res> implements $ProductDetailEventCopyWith<$Res> {
  factory _$SetUnitCopyWith(_SetUnit value, $Res Function(_SetUnit) _then) = __$SetUnitCopyWithImpl;
@useResult
$Res call({
 EUnit unit
});




}
/// @nodoc
class __$SetUnitCopyWithImpl<$Res>
    implements _$SetUnitCopyWith<$Res> {
  __$SetUnitCopyWithImpl(this._self, this._then);

  final _SetUnit _self;
  final $Res Function(_SetUnit) _then;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? unit = null,}) {
  return _then(_SetUnit(
null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as EUnit,
  ));
}


}

/// @nodoc


class _SetStore implements ProductDetailEvent {
  const _SetStore(this.storeId);
  

 final  String? storeId;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetStoreCopyWith<_SetStore> get copyWith => __$SetStoreCopyWithImpl<_SetStore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetStore&&(identical(other.storeId, storeId) || other.storeId == storeId));
}


@override
int get hashCode => Object.hash(runtimeType,storeId);

@override
String toString() {
  return 'ProductDetailEvent.setStore(storeId: $storeId)';
}


}

/// @nodoc
abstract mixin class _$SetStoreCopyWith<$Res> implements $ProductDetailEventCopyWith<$Res> {
  factory _$SetStoreCopyWith(_SetStore value, $Res Function(_SetStore) _then) = __$SetStoreCopyWithImpl;
@useResult
$Res call({
 String? storeId
});




}
/// @nodoc
class __$SetStoreCopyWithImpl<$Res>
    implements _$SetStoreCopyWith<$Res> {
  __$SetStoreCopyWithImpl(this._self, this._then);

  final _SetStore _self;
  final $Res Function(_SetStore) _then;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeId = freezed,}) {
  return _then(_SetStore(
freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _DeleteProduct implements ProductDetailEvent {
  const _DeleteProduct();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteProduct);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductDetailEvent.deleteProduct()';
}


}




/// @nodoc
mixin _$ProductDetailState {

 EProductDetailStatus get status; ProductDetailSnapshot? get snapshot; String get errorMessage;/// One-shot signal for the error toast.
 bool get lastWriteFailed;/// One-shot signal telling the page to pop after a delete.
 bool get isDeleted;
/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailStateCopyWith<ProductDetailState> get copyWith => _$ProductDetailStateCopyWithImpl<ProductDetailState>(this as ProductDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastWriteFailed, lastWriteFailed) || other.lastWriteFailed == lastWriteFailed)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}


@override
int get hashCode => Object.hash(runtimeType,status,snapshot,errorMessage,lastWriteFailed,isDeleted);

@override
String toString() {
  return 'ProductDetailState(status: $status, snapshot: $snapshot, errorMessage: $errorMessage, lastWriteFailed: $lastWriteFailed, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class $ProductDetailStateCopyWith<$Res>  {
  factory $ProductDetailStateCopyWith(ProductDetailState value, $Res Function(ProductDetailState) _then) = _$ProductDetailStateCopyWithImpl;
@useResult
$Res call({
 EProductDetailStatus status, ProductDetailSnapshot? snapshot, String errorMessage, bool lastWriteFailed, bool isDeleted
});




}
/// @nodoc
class _$ProductDetailStateCopyWithImpl<$Res>
    implements $ProductDetailStateCopyWith<$Res> {
  _$ProductDetailStateCopyWithImpl(this._self, this._then);

  final ProductDetailState _self;
  final $Res Function(ProductDetailState) _then;

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? snapshot = freezed,Object? errorMessage = null,Object? lastWriteFailed = null,Object? isDeleted = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EProductDetailStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as ProductDetailSnapshot?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,lastWriteFailed: null == lastWriteFailed ? _self.lastWriteFailed : lastWriteFailed // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductDetailState].
extension ProductDetailStatePatterns on ProductDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDetailState value)  $default,){
final _that = this;
switch (_that) {
case _ProductDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EProductDetailStatus status,  ProductDetailSnapshot? snapshot,  String errorMessage,  bool lastWriteFailed,  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductDetailState() when $default != null:
return $default(_that.status,_that.snapshot,_that.errorMessage,_that.lastWriteFailed,_that.isDeleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EProductDetailStatus status,  ProductDetailSnapshot? snapshot,  String errorMessage,  bool lastWriteFailed,  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _ProductDetailState():
return $default(_that.status,_that.snapshot,_that.errorMessage,_that.lastWriteFailed,_that.isDeleted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EProductDetailStatus status,  ProductDetailSnapshot? snapshot,  String errorMessage,  bool lastWriteFailed,  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _ProductDetailState() when $default != null:
return $default(_that.status,_that.snapshot,_that.errorMessage,_that.lastWriteFailed,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc


class _ProductDetailState implements ProductDetailState {
  const _ProductDetailState({this.status = EProductDetailStatus.initial, this.snapshot, this.errorMessage = '', this.lastWriteFailed = false, this.isDeleted = false});
  

@override@JsonKey() final  EProductDetailStatus status;
@override final  ProductDetailSnapshot? snapshot;
@override@JsonKey() final  String errorMessage;
/// One-shot signal for the error toast.
@override@JsonKey() final  bool lastWriteFailed;
/// One-shot signal telling the page to pop after a delete.
@override@JsonKey() final  bool isDeleted;

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDetailStateCopyWith<_ProductDetailState> get copyWith => __$ProductDetailStateCopyWithImpl<_ProductDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastWriteFailed, lastWriteFailed) || other.lastWriteFailed == lastWriteFailed)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}


@override
int get hashCode => Object.hash(runtimeType,status,snapshot,errorMessage,lastWriteFailed,isDeleted);

@override
String toString() {
  return 'ProductDetailState(status: $status, snapshot: $snapshot, errorMessage: $errorMessage, lastWriteFailed: $lastWriteFailed, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$ProductDetailStateCopyWith<$Res> implements $ProductDetailStateCopyWith<$Res> {
  factory _$ProductDetailStateCopyWith(_ProductDetailState value, $Res Function(_ProductDetailState) _then) = __$ProductDetailStateCopyWithImpl;
@override @useResult
$Res call({
 EProductDetailStatus status, ProductDetailSnapshot? snapshot, String errorMessage, bool lastWriteFailed, bool isDeleted
});




}
/// @nodoc
class __$ProductDetailStateCopyWithImpl<$Res>
    implements _$ProductDetailStateCopyWith<$Res> {
  __$ProductDetailStateCopyWithImpl(this._self, this._then);

  final _ProductDetailState _self;
  final $Res Function(_ProductDetailState) _then;

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? snapshot = freezed,Object? errorMessage = null,Object? lastWriteFailed = null,Object? isDeleted = null,}) {
  return _then(_ProductDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EProductDetailStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as ProductDetailSnapshot?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,lastWriteFailed: null == lastWriteFailed ? _self.lastWriteFailed : lastWriteFailed // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
