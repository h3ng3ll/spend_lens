// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'products_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductsEvent()';
}


}

/// @nodoc
class $ProductsEventCopyWith<$Res>  {
$ProductsEventCopyWith(ProductsEvent _, $Res Function(ProductsEvent) __);
}


/// Adds pattern-matching-related methods to [ProductsEvent].
extension ProductsEventPatterns on ProductsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,TResult Function( _QuickCreate value)?  quickCreate,TResult Function( _Create value)?  create,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _QuickCreate() when quickCreate != null:
return quickCreate(_that);case _Create() when create != null:
return create(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,required TResult Function( _QuickCreate value)  quickCreate,required TResult Function( _Create value)  create,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);case _QuickCreate():
return quickCreate(_that);case _Create():
return create(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,TResult? Function( _QuickCreate value)?  quickCreate,TResult? Function( _Create value)?  create,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _QuickCreate() when quickCreate != null:
return quickCreate(_that);case _Create() when create != null:
return create(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  watch,TResult Function( String name,  String? storeId)?  quickCreate,TResult Function( String name,  String? storeId,  String? categoryId,  EUnit unit,  double? firstPrice,  DateTime observedAt,  String currencyCode)?  create,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _QuickCreate() when quickCreate != null:
return quickCreate(_that.name,_that.storeId);case _Create() when create != null:
return create(_that.name,_that.storeId,_that.categoryId,_that.unit,_that.firstPrice,_that.observedAt,_that.currencyCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  watch,required TResult Function( String name,  String? storeId)  quickCreate,required TResult Function( String name,  String? storeId,  String? categoryId,  EUnit unit,  double? firstPrice,  DateTime observedAt,  String currencyCode)  create,}) {final _that = this;
switch (_that) {
case _Watch():
return watch();case _QuickCreate():
return quickCreate(_that.name,_that.storeId);case _Create():
return create(_that.name,_that.storeId,_that.categoryId,_that.unit,_that.firstPrice,_that.observedAt,_that.currencyCode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  watch,TResult? Function( String name,  String? storeId)?  quickCreate,TResult? Function( String name,  String? storeId,  String? categoryId,  EUnit unit,  double? firstPrice,  DateTime observedAt,  String currencyCode)?  create,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _QuickCreate() when quickCreate != null:
return quickCreate(_that.name,_that.storeId);case _Create() when create != null:
return create(_that.name,_that.storeId,_that.categoryId,_that.unit,_that.firstPrice,_that.observedAt,_that.currencyCode);case _:
  return null;

}
}

}

/// @nodoc


class _Watch implements ProductsEvent {
  const _Watch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductsEvent.watch()';
}


}




/// @nodoc


class _QuickCreate implements ProductsEvent {
  const _QuickCreate({required this.name, required this.storeId});
  

 final  String name;
 final  String? storeId;

/// Create a copy of ProductsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickCreateCopyWith<_QuickCreate> get copyWith => __$QuickCreateCopyWithImpl<_QuickCreate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickCreate&&(identical(other.name, name) || other.name == name)&&(identical(other.storeId, storeId) || other.storeId == storeId));
}


@override
int get hashCode => Object.hash(runtimeType,name,storeId);

@override
String toString() {
  return 'ProductsEvent.quickCreate(name: $name, storeId: $storeId)';
}


}

/// @nodoc
abstract mixin class _$QuickCreateCopyWith<$Res> implements $ProductsEventCopyWith<$Res> {
  factory _$QuickCreateCopyWith(_QuickCreate value, $Res Function(_QuickCreate) _then) = __$QuickCreateCopyWithImpl;
@useResult
$Res call({
 String name, String? storeId
});




}
/// @nodoc
class __$QuickCreateCopyWithImpl<$Res>
    implements _$QuickCreateCopyWith<$Res> {
  __$QuickCreateCopyWithImpl(this._self, this._then);

  final _QuickCreate _self;
  final $Res Function(_QuickCreate) _then;

/// Create a copy of ProductsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? storeId = freezed,}) {
  return _then(_QuickCreate(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Create implements ProductsEvent {
  const _Create({required this.name, required this.storeId, required this.categoryId, required this.unit, required this.firstPrice, required this.observedAt, required this.currencyCode});
  

 final  String name;
 final  String? storeId;
 final  String? categoryId;
 final  EUnit unit;
 final  double? firstPrice;
 final  DateTime observedAt;
 final  String currencyCode;

/// Create a copy of ProductsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateCopyWith<_Create> get copyWith => __$CreateCopyWithImpl<_Create>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Create&&(identical(other.name, name) || other.name == name)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.firstPrice, firstPrice) || other.firstPrice == firstPrice)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode));
}


@override
int get hashCode => Object.hash(runtimeType,name,storeId,categoryId,unit,firstPrice,observedAt,currencyCode);

@override
String toString() {
  return 'ProductsEvent.create(name: $name, storeId: $storeId, categoryId: $categoryId, unit: $unit, firstPrice: $firstPrice, observedAt: $observedAt, currencyCode: $currencyCode)';
}


}

/// @nodoc
abstract mixin class _$CreateCopyWith<$Res> implements $ProductsEventCopyWith<$Res> {
  factory _$CreateCopyWith(_Create value, $Res Function(_Create) _then) = __$CreateCopyWithImpl;
@useResult
$Res call({
 String name, String? storeId, String? categoryId, EUnit unit, double? firstPrice, DateTime observedAt, String currencyCode
});




}
/// @nodoc
class __$CreateCopyWithImpl<$Res>
    implements _$CreateCopyWith<$Res> {
  __$CreateCopyWithImpl(this._self, this._then);

  final _Create _self;
  final $Res Function(_Create) _then;

/// Create a copy of ProductsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? storeId = freezed,Object? categoryId = freezed,Object? unit = null,Object? firstPrice = freezed,Object? observedAt = null,Object? currencyCode = null,}) {
  return _then(_Create(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as EUnit,firstPrice: freezed == firstPrice ? _self.firstPrice : firstPrice // ignore: cast_nullable_to_non_nullable
as double?,observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ProductsState {

 EProductsStatus get status; List<Product> get products; String get errorMessage;/// One-shot pop signal: the picker/create screen closes with this id.
 String? get lastCreatedId;/// One-shot error signal for the write-failure toast.
 bool get lastWriteFailed;
/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductsStateCopyWith<ProductsState> get copyWith => _$ProductsStateCopyWithImpl<ProductsState>(this as ProductsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.products, products)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastCreatedId, lastCreatedId) || other.lastCreatedId == lastCreatedId)&&(identical(other.lastWriteFailed, lastWriteFailed) || other.lastWriteFailed == lastWriteFailed));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(products),errorMessage,lastCreatedId,lastWriteFailed);

@override
String toString() {
  return 'ProductsState(status: $status, products: $products, errorMessage: $errorMessage, lastCreatedId: $lastCreatedId, lastWriteFailed: $lastWriteFailed)';
}


}

/// @nodoc
abstract mixin class $ProductsStateCopyWith<$Res>  {
  factory $ProductsStateCopyWith(ProductsState value, $Res Function(ProductsState) _then) = _$ProductsStateCopyWithImpl;
@useResult
$Res call({
 EProductsStatus status, List<Product> products, String errorMessage, String? lastCreatedId, bool lastWriteFailed
});




}
/// @nodoc
class _$ProductsStateCopyWithImpl<$Res>
    implements $ProductsStateCopyWith<$Res> {
  _$ProductsStateCopyWithImpl(this._self, this._then);

  final ProductsState _self;
  final $Res Function(ProductsState) _then;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? products = null,Object? errorMessage = null,Object? lastCreatedId = freezed,Object? lastWriteFailed = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EProductsStatus,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,lastCreatedId: freezed == lastCreatedId ? _self.lastCreatedId : lastCreatedId // ignore: cast_nullable_to_non_nullable
as String?,lastWriteFailed: null == lastWriteFailed ? _self.lastWriteFailed : lastWriteFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductsState].
extension ProductsStatePatterns on ProductsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductsState value)  $default,){
final _that = this;
switch (_that) {
case _ProductsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductsState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EProductsStatus status,  List<Product> products,  String errorMessage,  String? lastCreatedId,  bool lastWriteFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductsState() when $default != null:
return $default(_that.status,_that.products,_that.errorMessage,_that.lastCreatedId,_that.lastWriteFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EProductsStatus status,  List<Product> products,  String errorMessage,  String? lastCreatedId,  bool lastWriteFailed)  $default,) {final _that = this;
switch (_that) {
case _ProductsState():
return $default(_that.status,_that.products,_that.errorMessage,_that.lastCreatedId,_that.lastWriteFailed);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EProductsStatus status,  List<Product> products,  String errorMessage,  String? lastCreatedId,  bool lastWriteFailed)?  $default,) {final _that = this;
switch (_that) {
case _ProductsState() when $default != null:
return $default(_that.status,_that.products,_that.errorMessage,_that.lastCreatedId,_that.lastWriteFailed);case _:
  return null;

}
}

}

/// @nodoc


class _ProductsState implements ProductsState {
  const _ProductsState({this.status = EProductsStatus.initial, final  List<Product> products = const <Product>[], this.errorMessage = '', this.lastCreatedId, this.lastWriteFailed = false}): _products = products;
  

@override@JsonKey() final  EProductsStatus status;
 final  List<Product> _products;
@override@JsonKey() List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

@override@JsonKey() final  String errorMessage;
/// One-shot pop signal: the picker/create screen closes with this id.
@override final  String? lastCreatedId;
/// One-shot error signal for the write-failure toast.
@override@JsonKey() final  bool lastWriteFailed;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductsStateCopyWith<_ProductsState> get copyWith => __$ProductsStateCopyWithImpl<_ProductsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._products, _products)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastCreatedId, lastCreatedId) || other.lastCreatedId == lastCreatedId)&&(identical(other.lastWriteFailed, lastWriteFailed) || other.lastWriteFailed == lastWriteFailed));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_products),errorMessage,lastCreatedId,lastWriteFailed);

@override
String toString() {
  return 'ProductsState(status: $status, products: $products, errorMessage: $errorMessage, lastCreatedId: $lastCreatedId, lastWriteFailed: $lastWriteFailed)';
}


}

/// @nodoc
abstract mixin class _$ProductsStateCopyWith<$Res> implements $ProductsStateCopyWith<$Res> {
  factory _$ProductsStateCopyWith(_ProductsState value, $Res Function(_ProductsState) _then) = __$ProductsStateCopyWithImpl;
@override @useResult
$Res call({
 EProductsStatus status, List<Product> products, String errorMessage, String? lastCreatedId, bool lastWriteFailed
});




}
/// @nodoc
class __$ProductsStateCopyWithImpl<$Res>
    implements _$ProductsStateCopyWith<$Res> {
  __$ProductsStateCopyWithImpl(this._self, this._then);

  final _ProductsState _self;
  final $Res Function(_ProductsState) _then;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? products = null,Object? errorMessage = null,Object? lastCreatedId = freezed,Object? lastWriteFailed = null,}) {
  return _then(_ProductsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EProductsStatus,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,lastCreatedId: freezed == lastCreatedId ? _self.lastCreatedId : lastCreatedId // ignore: cast_nullable_to_non_nullable
as String?,lastWriteFailed: null == lastWriteFailed ? _self.lastWriteFailed : lastWriteFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
