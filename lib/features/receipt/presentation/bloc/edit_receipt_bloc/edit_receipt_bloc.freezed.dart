// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_receipt_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditReceiptEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditReceiptEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditReceiptEvent()';
}


}

/// @nodoc
class $EditReceiptEventCopyWith<$Res>  {
$EditReceiptEventCopyWith(EditReceiptEvent _, $Res Function(EditReceiptEvent) __);
}


/// Adds pattern-matching-related methods to [EditReceiptEvent].
extension EditReceiptEventPatterns on EditReceiptEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Load value)?  load,TResult Function( _PickStore value)?  pickStore,TResult Function( _SetStore value)?  setStore,TResult Function( _SetCategory value)?  setCategory,TResult Function( _SetPurchasedAt value)?  setPurchasedAt,TResult Function( _SetPrintedTotal value)?  setPrintedTotal,TResult Function( _UpdateItemName value)?  updateItemName,TResult Function( _CycleItemUnit value)?  cycleItemUnit,TResult Function( _UpdateItemQuantity value)?  updateItemQuantity,TResult Function( _UpdateItemPrice value)?  updateItemPrice,TResult Function( _RemoveItem value)?  removeItem,TResult Function( _AddItem value)?  addItem,TResult Function( _Save value)?  save,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _PickStore() when pickStore != null:
return pickStore(_that);case _SetStore() when setStore != null:
return setStore(_that);case _SetCategory() when setCategory != null:
return setCategory(_that);case _SetPurchasedAt() when setPurchasedAt != null:
return setPurchasedAt(_that);case _SetPrintedTotal() when setPrintedTotal != null:
return setPrintedTotal(_that);case _UpdateItemName() when updateItemName != null:
return updateItemName(_that);case _CycleItemUnit() when cycleItemUnit != null:
return cycleItemUnit(_that);case _UpdateItemQuantity() when updateItemQuantity != null:
return updateItemQuantity(_that);case _UpdateItemPrice() when updateItemPrice != null:
return updateItemPrice(_that);case _RemoveItem() when removeItem != null:
return removeItem(_that);case _AddItem() when addItem != null:
return addItem(_that);case _Save() when save != null:
return save(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Load value)  load,required TResult Function( _PickStore value)  pickStore,required TResult Function( _SetStore value)  setStore,required TResult Function( _SetCategory value)  setCategory,required TResult Function( _SetPurchasedAt value)  setPurchasedAt,required TResult Function( _SetPrintedTotal value)  setPrintedTotal,required TResult Function( _UpdateItemName value)  updateItemName,required TResult Function( _CycleItemUnit value)  cycleItemUnit,required TResult Function( _UpdateItemQuantity value)  updateItemQuantity,required TResult Function( _UpdateItemPrice value)  updateItemPrice,required TResult Function( _RemoveItem value)  removeItem,required TResult Function( _AddItem value)  addItem,required TResult Function( _Save value)  save,}){
final _that = this;
switch (_that) {
case _Load():
return load(_that);case _PickStore():
return pickStore(_that);case _SetStore():
return setStore(_that);case _SetCategory():
return setCategory(_that);case _SetPurchasedAt():
return setPurchasedAt(_that);case _SetPrintedTotal():
return setPrintedTotal(_that);case _UpdateItemName():
return updateItemName(_that);case _CycleItemUnit():
return cycleItemUnit(_that);case _UpdateItemQuantity():
return updateItemQuantity(_that);case _UpdateItemPrice():
return updateItemPrice(_that);case _RemoveItem():
return removeItem(_that);case _AddItem():
return addItem(_that);case _Save():
return save(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Load value)?  load,TResult? Function( _PickStore value)?  pickStore,TResult? Function( _SetStore value)?  setStore,TResult? Function( _SetCategory value)?  setCategory,TResult? Function( _SetPurchasedAt value)?  setPurchasedAt,TResult? Function( _SetPrintedTotal value)?  setPrintedTotal,TResult? Function( _UpdateItemName value)?  updateItemName,TResult? Function( _CycleItemUnit value)?  cycleItemUnit,TResult? Function( _UpdateItemQuantity value)?  updateItemQuantity,TResult? Function( _UpdateItemPrice value)?  updateItemPrice,TResult? Function( _RemoveItem value)?  removeItem,TResult? Function( _AddItem value)?  addItem,TResult? Function( _Save value)?  save,}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _PickStore() when pickStore != null:
return pickStore(_that);case _SetStore() when setStore != null:
return setStore(_that);case _SetCategory() when setCategory != null:
return setCategory(_that);case _SetPurchasedAt() when setPurchasedAt != null:
return setPurchasedAt(_that);case _SetPrintedTotal() when setPrintedTotal != null:
return setPrintedTotal(_that);case _UpdateItemName() when updateItemName != null:
return updateItemName(_that);case _CycleItemUnit() when cycleItemUnit != null:
return cycleItemUnit(_that);case _UpdateItemQuantity() when updateItemQuantity != null:
return updateItemQuantity(_that);case _UpdateItemPrice() when updateItemPrice != null:
return updateItemPrice(_that);case _RemoveItem() when removeItem != null:
return removeItem(_that);case _AddItem() when addItem != null:
return addItem(_that);case _Save() when save != null:
return save(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String receiptId)?  load,TResult Function( String storeId)?  pickStore,TResult Function( String storeId,  String storeName)?  setStore,TResult Function( String categoryId)?  setCategory,TResult Function( DateTime purchasedAt)?  setPurchasedAt,TResult Function( double? printedTotal)?  setPrintedTotal,TResult Function( String itemId,  String name)?  updateItemName,TResult Function( String itemId)?  cycleItemUnit,TResult Function( String itemId,  double quantity)?  updateItemQuantity,TResult Function( String itemId,  double lineTotal)?  updateItemPrice,TResult Function( String itemId)?  removeItem,TResult Function()?  addItem,TResult Function()?  save,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that.receiptId);case _PickStore() when pickStore != null:
return pickStore(_that.storeId);case _SetStore() when setStore != null:
return setStore(_that.storeId,_that.storeName);case _SetCategory() when setCategory != null:
return setCategory(_that.categoryId);case _SetPurchasedAt() when setPurchasedAt != null:
return setPurchasedAt(_that.purchasedAt);case _SetPrintedTotal() when setPrintedTotal != null:
return setPrintedTotal(_that.printedTotal);case _UpdateItemName() when updateItemName != null:
return updateItemName(_that.itemId,_that.name);case _CycleItemUnit() when cycleItemUnit != null:
return cycleItemUnit(_that.itemId);case _UpdateItemQuantity() when updateItemQuantity != null:
return updateItemQuantity(_that.itemId,_that.quantity);case _UpdateItemPrice() when updateItemPrice != null:
return updateItemPrice(_that.itemId,_that.lineTotal);case _RemoveItem() when removeItem != null:
return removeItem(_that.itemId);case _AddItem() when addItem != null:
return addItem();case _Save() when save != null:
return save();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String receiptId)  load,required TResult Function( String storeId)  pickStore,required TResult Function( String storeId,  String storeName)  setStore,required TResult Function( String categoryId)  setCategory,required TResult Function( DateTime purchasedAt)  setPurchasedAt,required TResult Function( double? printedTotal)  setPrintedTotal,required TResult Function( String itemId,  String name)  updateItemName,required TResult Function( String itemId)  cycleItemUnit,required TResult Function( String itemId,  double quantity)  updateItemQuantity,required TResult Function( String itemId,  double lineTotal)  updateItemPrice,required TResult Function( String itemId)  removeItem,required TResult Function()  addItem,required TResult Function()  save,}) {final _that = this;
switch (_that) {
case _Load():
return load(_that.receiptId);case _PickStore():
return pickStore(_that.storeId);case _SetStore():
return setStore(_that.storeId,_that.storeName);case _SetCategory():
return setCategory(_that.categoryId);case _SetPurchasedAt():
return setPurchasedAt(_that.purchasedAt);case _SetPrintedTotal():
return setPrintedTotal(_that.printedTotal);case _UpdateItemName():
return updateItemName(_that.itemId,_that.name);case _CycleItemUnit():
return cycleItemUnit(_that.itemId);case _UpdateItemQuantity():
return updateItemQuantity(_that.itemId,_that.quantity);case _UpdateItemPrice():
return updateItemPrice(_that.itemId,_that.lineTotal);case _RemoveItem():
return removeItem(_that.itemId);case _AddItem():
return addItem();case _Save():
return save();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String receiptId)?  load,TResult? Function( String storeId)?  pickStore,TResult? Function( String storeId,  String storeName)?  setStore,TResult? Function( String categoryId)?  setCategory,TResult? Function( DateTime purchasedAt)?  setPurchasedAt,TResult? Function( double? printedTotal)?  setPrintedTotal,TResult? Function( String itemId,  String name)?  updateItemName,TResult? Function( String itemId)?  cycleItemUnit,TResult? Function( String itemId,  double quantity)?  updateItemQuantity,TResult? Function( String itemId,  double lineTotal)?  updateItemPrice,TResult? Function( String itemId)?  removeItem,TResult? Function()?  addItem,TResult? Function()?  save,}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that.receiptId);case _PickStore() when pickStore != null:
return pickStore(_that.storeId);case _SetStore() when setStore != null:
return setStore(_that.storeId,_that.storeName);case _SetCategory() when setCategory != null:
return setCategory(_that.categoryId);case _SetPurchasedAt() when setPurchasedAt != null:
return setPurchasedAt(_that.purchasedAt);case _SetPrintedTotal() when setPrintedTotal != null:
return setPrintedTotal(_that.printedTotal);case _UpdateItemName() when updateItemName != null:
return updateItemName(_that.itemId,_that.name);case _CycleItemUnit() when cycleItemUnit != null:
return cycleItemUnit(_that.itemId);case _UpdateItemQuantity() when updateItemQuantity != null:
return updateItemQuantity(_that.itemId,_that.quantity);case _UpdateItemPrice() when updateItemPrice != null:
return updateItemPrice(_that.itemId,_that.lineTotal);case _RemoveItem() when removeItem != null:
return removeItem(_that.itemId);case _AddItem() when addItem != null:
return addItem();case _Save() when save != null:
return save();case _:
  return null;

}
}

}

/// @nodoc


class _Load implements EditReceiptEvent {
  const _Load(this.receiptId);
  

 final  String receiptId;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadCopyWith<_Load> get copyWith => __$LoadCopyWithImpl<_Load>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Load&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId));
}


@override
int get hashCode => Object.hash(runtimeType,receiptId);

@override
String toString() {
  return 'EditReceiptEvent.load(receiptId: $receiptId)';
}


}

/// @nodoc
abstract mixin class _$LoadCopyWith<$Res> implements $EditReceiptEventCopyWith<$Res> {
  factory _$LoadCopyWith(_Load value, $Res Function(_Load) _then) = __$LoadCopyWithImpl;
@useResult
$Res call({
 String receiptId
});




}
/// @nodoc
class __$LoadCopyWithImpl<$Res>
    implements _$LoadCopyWith<$Res> {
  __$LoadCopyWithImpl(this._self, this._then);

  final _Load _self;
  final $Res Function(_Load) _then;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? receiptId = null,}) {
  return _then(_Load(
null == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PickStore implements EditReceiptEvent {
  const _PickStore(this.storeId);
  

 final  String storeId;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickStoreCopyWith<_PickStore> get copyWith => __$PickStoreCopyWithImpl<_PickStore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickStore&&(identical(other.storeId, storeId) || other.storeId == storeId));
}


@override
int get hashCode => Object.hash(runtimeType,storeId);

@override
String toString() {
  return 'EditReceiptEvent.pickStore(storeId: $storeId)';
}


}

/// @nodoc
abstract mixin class _$PickStoreCopyWith<$Res> implements $EditReceiptEventCopyWith<$Res> {
  factory _$PickStoreCopyWith(_PickStore value, $Res Function(_PickStore) _then) = __$PickStoreCopyWithImpl;
@useResult
$Res call({
 String storeId
});




}
/// @nodoc
class __$PickStoreCopyWithImpl<$Res>
    implements _$PickStoreCopyWith<$Res> {
  __$PickStoreCopyWithImpl(this._self, this._then);

  final _PickStore _self;
  final $Res Function(_PickStore) _then;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeId = null,}) {
  return _then(_PickStore(
null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SetStore implements EditReceiptEvent {
  const _SetStore(this.storeId, this.storeName);
  

 final  String storeId;
 final  String storeName;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetStoreCopyWith<_SetStore> get copyWith => __$SetStoreCopyWithImpl<_SetStore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetStore&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName));
}


@override
int get hashCode => Object.hash(runtimeType,storeId,storeName);

@override
String toString() {
  return 'EditReceiptEvent.setStore(storeId: $storeId, storeName: $storeName)';
}


}

/// @nodoc
abstract mixin class _$SetStoreCopyWith<$Res> implements $EditReceiptEventCopyWith<$Res> {
  factory _$SetStoreCopyWith(_SetStore value, $Res Function(_SetStore) _then) = __$SetStoreCopyWithImpl;
@useResult
$Res call({
 String storeId, String storeName
});




}
/// @nodoc
class __$SetStoreCopyWithImpl<$Res>
    implements _$SetStoreCopyWith<$Res> {
  __$SetStoreCopyWithImpl(this._self, this._then);

  final _SetStore _self;
  final $Res Function(_SetStore) _then;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeId = null,Object? storeName = null,}) {
  return _then(_SetStore(
null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SetCategory implements EditReceiptEvent {
  const _SetCategory(this.categoryId);
  

 final  String categoryId;

/// Create a copy of EditReceiptEvent
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
  return 'EditReceiptEvent.setCategory(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$SetCategoryCopyWith<$Res> implements $EditReceiptEventCopyWith<$Res> {
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

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = null,}) {
  return _then(_SetCategory(
null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SetPurchasedAt implements EditReceiptEvent {
  const _SetPurchasedAt(this.purchasedAt);
  

 final  DateTime purchasedAt;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetPurchasedAtCopyWith<_SetPurchasedAt> get copyWith => __$SetPurchasedAtCopyWithImpl<_SetPurchasedAt>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetPurchasedAt&&(identical(other.purchasedAt, purchasedAt) || other.purchasedAt == purchasedAt));
}


@override
int get hashCode => Object.hash(runtimeType,purchasedAt);

@override
String toString() {
  return 'EditReceiptEvent.setPurchasedAt(purchasedAt: $purchasedAt)';
}


}

/// @nodoc
abstract mixin class _$SetPurchasedAtCopyWith<$Res> implements $EditReceiptEventCopyWith<$Res> {
  factory _$SetPurchasedAtCopyWith(_SetPurchasedAt value, $Res Function(_SetPurchasedAt) _then) = __$SetPurchasedAtCopyWithImpl;
@useResult
$Res call({
 DateTime purchasedAt
});




}
/// @nodoc
class __$SetPurchasedAtCopyWithImpl<$Res>
    implements _$SetPurchasedAtCopyWith<$Res> {
  __$SetPurchasedAtCopyWithImpl(this._self, this._then);

  final _SetPurchasedAt _self;
  final $Res Function(_SetPurchasedAt) _then;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? purchasedAt = null,}) {
  return _then(_SetPurchasedAt(
null == purchasedAt ? _self.purchasedAt : purchasedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class _SetPrintedTotal implements EditReceiptEvent {
  const _SetPrintedTotal(this.printedTotal);
  

 final  double? printedTotal;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetPrintedTotalCopyWith<_SetPrintedTotal> get copyWith => __$SetPrintedTotalCopyWithImpl<_SetPrintedTotal>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetPrintedTotal&&(identical(other.printedTotal, printedTotal) || other.printedTotal == printedTotal));
}


@override
int get hashCode => Object.hash(runtimeType,printedTotal);

@override
String toString() {
  return 'EditReceiptEvent.setPrintedTotal(printedTotal: $printedTotal)';
}


}

/// @nodoc
abstract mixin class _$SetPrintedTotalCopyWith<$Res> implements $EditReceiptEventCopyWith<$Res> {
  factory _$SetPrintedTotalCopyWith(_SetPrintedTotal value, $Res Function(_SetPrintedTotal) _then) = __$SetPrintedTotalCopyWithImpl;
@useResult
$Res call({
 double? printedTotal
});




}
/// @nodoc
class __$SetPrintedTotalCopyWithImpl<$Res>
    implements _$SetPrintedTotalCopyWith<$Res> {
  __$SetPrintedTotalCopyWithImpl(this._self, this._then);

  final _SetPrintedTotal _self;
  final $Res Function(_SetPrintedTotal) _then;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? printedTotal = freezed,}) {
  return _then(_SetPrintedTotal(
freezed == printedTotal ? _self.printedTotal : printedTotal // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc


class _UpdateItemName implements EditReceiptEvent {
  const _UpdateItemName(this.itemId, this.name);
  

 final  String itemId;
 final  String name;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateItemNameCopyWith<_UpdateItemName> get copyWith => __$UpdateItemNameCopyWithImpl<_UpdateItemName>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateItemName&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,name);

@override
String toString() {
  return 'EditReceiptEvent.updateItemName(itemId: $itemId, name: $name)';
}


}

/// @nodoc
abstract mixin class _$UpdateItemNameCopyWith<$Res> implements $EditReceiptEventCopyWith<$Res> {
  factory _$UpdateItemNameCopyWith(_UpdateItemName value, $Res Function(_UpdateItemName) _then) = __$UpdateItemNameCopyWithImpl;
@useResult
$Res call({
 String itemId, String name
});




}
/// @nodoc
class __$UpdateItemNameCopyWithImpl<$Res>
    implements _$UpdateItemNameCopyWith<$Res> {
  __$UpdateItemNameCopyWithImpl(this._self, this._then);

  final _UpdateItemName _self;
  final $Res Function(_UpdateItemName) _then;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? name = null,}) {
  return _then(_UpdateItemName(
null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _CycleItemUnit implements EditReceiptEvent {
  const _CycleItemUnit(this.itemId);
  

 final  String itemId;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CycleItemUnitCopyWith<_CycleItemUnit> get copyWith => __$CycleItemUnitCopyWithImpl<_CycleItemUnit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CycleItemUnit&&(identical(other.itemId, itemId) || other.itemId == itemId));
}


@override
int get hashCode => Object.hash(runtimeType,itemId);

@override
String toString() {
  return 'EditReceiptEvent.cycleItemUnit(itemId: $itemId)';
}


}

/// @nodoc
abstract mixin class _$CycleItemUnitCopyWith<$Res> implements $EditReceiptEventCopyWith<$Res> {
  factory _$CycleItemUnitCopyWith(_CycleItemUnit value, $Res Function(_CycleItemUnit) _then) = __$CycleItemUnitCopyWithImpl;
@useResult
$Res call({
 String itemId
});




}
/// @nodoc
class __$CycleItemUnitCopyWithImpl<$Res>
    implements _$CycleItemUnitCopyWith<$Res> {
  __$CycleItemUnitCopyWithImpl(this._self, this._then);

  final _CycleItemUnit _self;
  final $Res Function(_CycleItemUnit) _then;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,}) {
  return _then(_CycleItemUnit(
null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _UpdateItemQuantity implements EditReceiptEvent {
  const _UpdateItemQuantity(this.itemId, this.quantity);
  

 final  String itemId;
 final  double quantity;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateItemQuantityCopyWith<_UpdateItemQuantity> get copyWith => __$UpdateItemQuantityCopyWithImpl<_UpdateItemQuantity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateItemQuantity&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,quantity);

@override
String toString() {
  return 'EditReceiptEvent.updateItemQuantity(itemId: $itemId, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$UpdateItemQuantityCopyWith<$Res> implements $EditReceiptEventCopyWith<$Res> {
  factory _$UpdateItemQuantityCopyWith(_UpdateItemQuantity value, $Res Function(_UpdateItemQuantity) _then) = __$UpdateItemQuantityCopyWithImpl;
@useResult
$Res call({
 String itemId, double quantity
});




}
/// @nodoc
class __$UpdateItemQuantityCopyWithImpl<$Res>
    implements _$UpdateItemQuantityCopyWith<$Res> {
  __$UpdateItemQuantityCopyWithImpl(this._self, this._then);

  final _UpdateItemQuantity _self;
  final $Res Function(_UpdateItemQuantity) _then;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? quantity = null,}) {
  return _then(_UpdateItemQuantity(
null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _UpdateItemPrice implements EditReceiptEvent {
  const _UpdateItemPrice(this.itemId, this.lineTotal);
  

 final  String itemId;
 final  double lineTotal;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateItemPriceCopyWith<_UpdateItemPrice> get copyWith => __$UpdateItemPriceCopyWithImpl<_UpdateItemPrice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateItemPrice&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,lineTotal);

@override
String toString() {
  return 'EditReceiptEvent.updateItemPrice(itemId: $itemId, lineTotal: $lineTotal)';
}


}

/// @nodoc
abstract mixin class _$UpdateItemPriceCopyWith<$Res> implements $EditReceiptEventCopyWith<$Res> {
  factory _$UpdateItemPriceCopyWith(_UpdateItemPrice value, $Res Function(_UpdateItemPrice) _then) = __$UpdateItemPriceCopyWithImpl;
@useResult
$Res call({
 String itemId, double lineTotal
});




}
/// @nodoc
class __$UpdateItemPriceCopyWithImpl<$Res>
    implements _$UpdateItemPriceCopyWith<$Res> {
  __$UpdateItemPriceCopyWithImpl(this._self, this._then);

  final _UpdateItemPrice _self;
  final $Res Function(_UpdateItemPrice) _then;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? lineTotal = null,}) {
  return _then(_UpdateItemPrice(
null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _RemoveItem implements EditReceiptEvent {
  const _RemoveItem(this.itemId);
  

 final  String itemId;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveItemCopyWith<_RemoveItem> get copyWith => __$RemoveItemCopyWithImpl<_RemoveItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveItem&&(identical(other.itemId, itemId) || other.itemId == itemId));
}


@override
int get hashCode => Object.hash(runtimeType,itemId);

@override
String toString() {
  return 'EditReceiptEvent.removeItem(itemId: $itemId)';
}


}

/// @nodoc
abstract mixin class _$RemoveItemCopyWith<$Res> implements $EditReceiptEventCopyWith<$Res> {
  factory _$RemoveItemCopyWith(_RemoveItem value, $Res Function(_RemoveItem) _then) = __$RemoveItemCopyWithImpl;
@useResult
$Res call({
 String itemId
});




}
/// @nodoc
class __$RemoveItemCopyWithImpl<$Res>
    implements _$RemoveItemCopyWith<$Res> {
  __$RemoveItemCopyWithImpl(this._self, this._then);

  final _RemoveItem _self;
  final $Res Function(_RemoveItem) _then;

/// Create a copy of EditReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,}) {
  return _then(_RemoveItem(
null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AddItem implements EditReceiptEvent {
  const _AddItem();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddItem);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditReceiptEvent.addItem()';
}


}




/// @nodoc


class _Save implements EditReceiptEvent {
  const _Save();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Save);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditReceiptEvent.save()';
}


}




/// @nodoc
mixin _$EditReceiptState {

 EEditReceiptStatus get status; String? get receiptId; String? get storeId; String get storeName;/// Whether [storeId] came from an explicit user pick rather than an
/// auto-match. Carried onto the draft so the save path can decide
/// whether learning an alias from this receipt is justified.
 bool get isStoreUserPicked;/// The receipt's category. Seeded from `Receipt.categoryId` on load and
/// written back on save, which `CreateExpenseFromReceiptUseCase` then
/// mirrors onto the `Expense` — so the record-detail screen's category
/// chip follows an edit made here.
 String? get categoryId; DateTime? get purchasedAt; double? get printedTotal; List<EditDraftItem> get items; bool get matchesTotal; String? get errorMessage;
/// Create a copy of EditReceiptState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditReceiptStateCopyWith<EditReceiptState> get copyWith => _$EditReceiptStateCopyWithImpl<EditReceiptState>(this as EditReceiptState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditReceiptState&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.isStoreUserPicked, isStoreUserPicked) || other.isStoreUserPicked == isStoreUserPicked)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.purchasedAt, purchasedAt) || other.purchasedAt == purchasedAt)&&(identical(other.printedTotal, printedTotal) || other.printedTotal == printedTotal)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.matchesTotal, matchesTotal) || other.matchesTotal == matchesTotal)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,receiptId,storeId,storeName,isStoreUserPicked,categoryId,purchasedAt,printedTotal,const DeepCollectionEquality().hash(items),matchesTotal,errorMessage);

@override
String toString() {
  return 'EditReceiptState(status: $status, receiptId: $receiptId, storeId: $storeId, storeName: $storeName, isStoreUserPicked: $isStoreUserPicked, categoryId: $categoryId, purchasedAt: $purchasedAt, printedTotal: $printedTotal, items: $items, matchesTotal: $matchesTotal, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $EditReceiptStateCopyWith<$Res>  {
  factory $EditReceiptStateCopyWith(EditReceiptState value, $Res Function(EditReceiptState) _then) = _$EditReceiptStateCopyWithImpl;
@useResult
$Res call({
 EEditReceiptStatus status, String? receiptId, String? storeId, String storeName, bool isStoreUserPicked, String? categoryId, DateTime? purchasedAt, double? printedTotal, List<EditDraftItem> items, bool matchesTotal, String? errorMessage
});




}
/// @nodoc
class _$EditReceiptStateCopyWithImpl<$Res>
    implements $EditReceiptStateCopyWith<$Res> {
  _$EditReceiptStateCopyWithImpl(this._self, this._then);

  final EditReceiptState _self;
  final $Res Function(EditReceiptState) _then;

/// Create a copy of EditReceiptState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? receiptId = freezed,Object? storeId = freezed,Object? storeName = null,Object? isStoreUserPicked = null,Object? categoryId = freezed,Object? purchasedAt = freezed,Object? printedTotal = freezed,Object? items = null,Object? matchesTotal = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EEditReceiptStatus,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,isStoreUserPicked: null == isStoreUserPicked ? _self.isStoreUserPicked : isStoreUserPicked // ignore: cast_nullable_to_non_nullable
as bool,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,purchasedAt: freezed == purchasedAt ? _self.purchasedAt : purchasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,printedTotal: freezed == printedTotal ? _self.printedTotal : printedTotal // ignore: cast_nullable_to_non_nullable
as double?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<EditDraftItem>,matchesTotal: null == matchesTotal ? _self.matchesTotal : matchesTotal // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EditReceiptState].
extension EditReceiptStatePatterns on EditReceiptState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditReceiptState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditReceiptState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditReceiptState value)  $default,){
final _that = this;
switch (_that) {
case _EditReceiptState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditReceiptState value)?  $default,){
final _that = this;
switch (_that) {
case _EditReceiptState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EEditReceiptStatus status,  String? receiptId,  String? storeId,  String storeName,  bool isStoreUserPicked,  String? categoryId,  DateTime? purchasedAt,  double? printedTotal,  List<EditDraftItem> items,  bool matchesTotal,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditReceiptState() when $default != null:
return $default(_that.status,_that.receiptId,_that.storeId,_that.storeName,_that.isStoreUserPicked,_that.categoryId,_that.purchasedAt,_that.printedTotal,_that.items,_that.matchesTotal,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EEditReceiptStatus status,  String? receiptId,  String? storeId,  String storeName,  bool isStoreUserPicked,  String? categoryId,  DateTime? purchasedAt,  double? printedTotal,  List<EditDraftItem> items,  bool matchesTotal,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _EditReceiptState():
return $default(_that.status,_that.receiptId,_that.storeId,_that.storeName,_that.isStoreUserPicked,_that.categoryId,_that.purchasedAt,_that.printedTotal,_that.items,_that.matchesTotal,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EEditReceiptStatus status,  String? receiptId,  String? storeId,  String storeName,  bool isStoreUserPicked,  String? categoryId,  DateTime? purchasedAt,  double? printedTotal,  List<EditDraftItem> items,  bool matchesTotal,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _EditReceiptState() when $default != null:
return $default(_that.status,_that.receiptId,_that.storeId,_that.storeName,_that.isStoreUserPicked,_that.categoryId,_that.purchasedAt,_that.printedTotal,_that.items,_that.matchesTotal,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _EditReceiptState implements EditReceiptState {
  const _EditReceiptState({this.status = EEditReceiptStatus.initial, this.receiptId, this.storeId, this.storeName = '', this.isStoreUserPicked = false, this.categoryId, this.purchasedAt, this.printedTotal, final  List<EditDraftItem> items = const <EditDraftItem>[], this.matchesTotal = true, this.errorMessage}): _items = items;
  

@override@JsonKey() final  EEditReceiptStatus status;
@override final  String? receiptId;
@override final  String? storeId;
@override@JsonKey() final  String storeName;
/// Whether [storeId] came from an explicit user pick rather than an
/// auto-match. Carried onto the draft so the save path can decide
/// whether learning an alias from this receipt is justified.
@override@JsonKey() final  bool isStoreUserPicked;
/// The receipt's category. Seeded from `Receipt.categoryId` on load and
/// written back on save, which `CreateExpenseFromReceiptUseCase` then
/// mirrors onto the `Expense` — so the record-detail screen's category
/// chip follows an edit made here.
@override final  String? categoryId;
@override final  DateTime? purchasedAt;
@override final  double? printedTotal;
 final  List<EditDraftItem> _items;
@override@JsonKey() List<EditDraftItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool matchesTotal;
@override final  String? errorMessage;

/// Create a copy of EditReceiptState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditReceiptStateCopyWith<_EditReceiptState> get copyWith => __$EditReceiptStateCopyWithImpl<_EditReceiptState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditReceiptState&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.isStoreUserPicked, isStoreUserPicked) || other.isStoreUserPicked == isStoreUserPicked)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.purchasedAt, purchasedAt) || other.purchasedAt == purchasedAt)&&(identical(other.printedTotal, printedTotal) || other.printedTotal == printedTotal)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.matchesTotal, matchesTotal) || other.matchesTotal == matchesTotal)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,receiptId,storeId,storeName,isStoreUserPicked,categoryId,purchasedAt,printedTotal,const DeepCollectionEquality().hash(_items),matchesTotal,errorMessage);

@override
String toString() {
  return 'EditReceiptState(status: $status, receiptId: $receiptId, storeId: $storeId, storeName: $storeName, isStoreUserPicked: $isStoreUserPicked, categoryId: $categoryId, purchasedAt: $purchasedAt, printedTotal: $printedTotal, items: $items, matchesTotal: $matchesTotal, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$EditReceiptStateCopyWith<$Res> implements $EditReceiptStateCopyWith<$Res> {
  factory _$EditReceiptStateCopyWith(_EditReceiptState value, $Res Function(_EditReceiptState) _then) = __$EditReceiptStateCopyWithImpl;
@override @useResult
$Res call({
 EEditReceiptStatus status, String? receiptId, String? storeId, String storeName, bool isStoreUserPicked, String? categoryId, DateTime? purchasedAt, double? printedTotal, List<EditDraftItem> items, bool matchesTotal, String? errorMessage
});




}
/// @nodoc
class __$EditReceiptStateCopyWithImpl<$Res>
    implements _$EditReceiptStateCopyWith<$Res> {
  __$EditReceiptStateCopyWithImpl(this._self, this._then);

  final _EditReceiptState _self;
  final $Res Function(_EditReceiptState) _then;

/// Create a copy of EditReceiptState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? receiptId = freezed,Object? storeId = freezed,Object? storeName = null,Object? isStoreUserPicked = null,Object? categoryId = freezed,Object? purchasedAt = freezed,Object? printedTotal = freezed,Object? items = null,Object? matchesTotal = null,Object? errorMessage = freezed,}) {
  return _then(_EditReceiptState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EEditReceiptStatus,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,isStoreUserPicked: null == isStoreUserPicked ? _self.isStoreUserPicked : isStoreUserPicked // ignore: cast_nullable_to_non_nullable
as bool,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,purchasedAt: freezed == purchasedAt ? _self.purchasedAt : purchasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,printedTotal: freezed == printedTotal ? _self.printedTotal : printedTotal // ignore: cast_nullable_to_non_nullable
as double?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<EditDraftItem>,matchesTotal: null == matchesTotal ? _self.matchesTotal : matchesTotal // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
