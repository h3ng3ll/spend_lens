// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stores_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoresEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoresEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoresEvent()';
}


}

/// @nodoc
class $StoresEventCopyWith<$Res>  {
$StoresEventCopyWith(StoresEvent _, $Res Function(StoresEvent) __);
}


/// Adds pattern-matching-related methods to [StoresEvent].
extension StoresEventPatterns on StoresEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,TResult Function( _QuickCreate value)?  quickCreate,TResult Function( _Create value)?  create,TResult Function( _Delete value)?  delete,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _QuickCreate() when quickCreate != null:
return quickCreate(_that);case _Create() when create != null:
return create(_that);case _Delete() when delete != null:
return delete(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,required TResult Function( _QuickCreate value)  quickCreate,required TResult Function( _Create value)  create,required TResult Function( _Delete value)  delete,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);case _QuickCreate():
return quickCreate(_that);case _Create():
return create(_that);case _Delete():
return delete(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,TResult? Function( _QuickCreate value)?  quickCreate,TResult? Function( _Create value)?  create,TResult? Function( _Delete value)?  delete,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _QuickCreate() when quickCreate != null:
return quickCreate(_that);case _Create() when create != null:
return create(_that);case _Delete() when delete != null:
return delete(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  watch,TResult Function( String name)?  quickCreate,TResult Function( String name,  String receiptAlias,  EStoreType type)?  create,TResult Function( String storeId,  String uid)?  delete,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _QuickCreate() when quickCreate != null:
return quickCreate(_that.name);case _Create() when create != null:
return create(_that.name,_that.receiptAlias,_that.type);case _Delete() when delete != null:
return delete(_that.storeId,_that.uid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  watch,required TResult Function( String name)  quickCreate,required TResult Function( String name,  String receiptAlias,  EStoreType type)  create,required TResult Function( String storeId,  String uid)  delete,}) {final _that = this;
switch (_that) {
case _Watch():
return watch();case _QuickCreate():
return quickCreate(_that.name);case _Create():
return create(_that.name,_that.receiptAlias,_that.type);case _Delete():
return delete(_that.storeId,_that.uid);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  watch,TResult? Function( String name)?  quickCreate,TResult? Function( String name,  String receiptAlias,  EStoreType type)?  create,TResult? Function( String storeId,  String uid)?  delete,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _QuickCreate() when quickCreate != null:
return quickCreate(_that.name);case _Create() when create != null:
return create(_that.name,_that.receiptAlias,_that.type);case _Delete() when delete != null:
return delete(_that.storeId,_that.uid);case _:
  return null;

}
}

}

/// @nodoc


class _Watch implements StoresEvent {
  const _Watch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoresEvent.watch()';
}


}




/// @nodoc


class _QuickCreate implements StoresEvent {
  const _QuickCreate(this.name);
  

 final  String name;

/// Create a copy of StoresEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickCreateCopyWith<_QuickCreate> get copyWith => __$QuickCreateCopyWithImpl<_QuickCreate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickCreate&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'StoresEvent.quickCreate(name: $name)';
}


}

/// @nodoc
abstract mixin class _$QuickCreateCopyWith<$Res> implements $StoresEventCopyWith<$Res> {
  factory _$QuickCreateCopyWith(_QuickCreate value, $Res Function(_QuickCreate) _then) = __$QuickCreateCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class __$QuickCreateCopyWithImpl<$Res>
    implements _$QuickCreateCopyWith<$Res> {
  __$QuickCreateCopyWithImpl(this._self, this._then);

  final _QuickCreate _self;
  final $Res Function(_QuickCreate) _then;

/// Create a copy of StoresEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_QuickCreate(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Create implements StoresEvent {
  const _Create({required this.name, required this.receiptAlias, required this.type});
  

 final  String name;
 final  String receiptAlias;
 final  EStoreType type;

/// Create a copy of StoresEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateCopyWith<_Create> get copyWith => __$CreateCopyWithImpl<_Create>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Create&&(identical(other.name, name) || other.name == name)&&(identical(other.receiptAlias, receiptAlias) || other.receiptAlias == receiptAlias)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,name,receiptAlias,type);

@override
String toString() {
  return 'StoresEvent.create(name: $name, receiptAlias: $receiptAlias, type: $type)';
}


}

/// @nodoc
abstract mixin class _$CreateCopyWith<$Res> implements $StoresEventCopyWith<$Res> {
  factory _$CreateCopyWith(_Create value, $Res Function(_Create) _then) = __$CreateCopyWithImpl;
@useResult
$Res call({
 String name, String receiptAlias, EStoreType type
});




}
/// @nodoc
class __$CreateCopyWithImpl<$Res>
    implements _$CreateCopyWith<$Res> {
  __$CreateCopyWithImpl(this._self, this._then);

  final _Create _self;
  final $Res Function(_Create) _then;

/// Create a copy of StoresEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? receiptAlias = null,Object? type = null,}) {
  return _then(_Create(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,receiptAlias: null == receiptAlias ? _self.receiptAlias : receiptAlias // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EStoreType,
  ));
}


}

/// @nodoc


class _Delete implements StoresEvent {
  const _Delete(this.storeId, {required this.uid});
  

 final  String storeId;
 final  String uid;

/// Create a copy of StoresEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteCopyWith<_Delete> get copyWith => __$DeleteCopyWithImpl<_Delete>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Delete&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.uid, uid) || other.uid == uid));
}


@override
int get hashCode => Object.hash(runtimeType,storeId,uid);

@override
String toString() {
  return 'StoresEvent.delete(storeId: $storeId, uid: $uid)';
}


}

/// @nodoc
abstract mixin class _$DeleteCopyWith<$Res> implements $StoresEventCopyWith<$Res> {
  factory _$DeleteCopyWith(_Delete value, $Res Function(_Delete) _then) = __$DeleteCopyWithImpl;
@useResult
$Res call({
 String storeId, String uid
});




}
/// @nodoc
class __$DeleteCopyWithImpl<$Res>
    implements _$DeleteCopyWith<$Res> {
  __$DeleteCopyWithImpl(this._self, this._then);

  final _Delete _self;
  final $Res Function(_Delete) _then;

/// Create a copy of StoresEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeId = null,Object? uid = null,}) {
  return _then(_Delete(
null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$StoresState {

 EStoresStatus get status; List<Store> get stores; String get errorMessage;/// The id of the store most recently created by `quickCreate`/`create`.
/// A one-shot signal a `BlocListener` consumes to pop the picker/create
/// screen with the new id — never read to derive displayed state.
 String? get lastCreatedId;/// Whether the most recent write (quickCreate/create/delete) failed. A
/// one-shot signal for an error-toast listener — never read to derive
/// displayed state.
 bool get lastWriteFailed;
/// Create a copy of StoresState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoresStateCopyWith<StoresState> get copyWith => _$StoresStateCopyWithImpl<StoresState>(this as StoresState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoresState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.stores, stores)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastCreatedId, lastCreatedId) || other.lastCreatedId == lastCreatedId)&&(identical(other.lastWriteFailed, lastWriteFailed) || other.lastWriteFailed == lastWriteFailed));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(stores),errorMessage,lastCreatedId,lastWriteFailed);

@override
String toString() {
  return 'StoresState(status: $status, stores: $stores, errorMessage: $errorMessage, lastCreatedId: $lastCreatedId, lastWriteFailed: $lastWriteFailed)';
}


}

/// @nodoc
abstract mixin class $StoresStateCopyWith<$Res>  {
  factory $StoresStateCopyWith(StoresState value, $Res Function(StoresState) _then) = _$StoresStateCopyWithImpl;
@useResult
$Res call({
 EStoresStatus status, List<Store> stores, String errorMessage, String? lastCreatedId, bool lastWriteFailed
});




}
/// @nodoc
class _$StoresStateCopyWithImpl<$Res>
    implements $StoresStateCopyWith<$Res> {
  _$StoresStateCopyWithImpl(this._self, this._then);

  final StoresState _self;
  final $Res Function(StoresState) _then;

/// Create a copy of StoresState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? stores = null,Object? errorMessage = null,Object? lastCreatedId = freezed,Object? lastWriteFailed = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EStoresStatus,stores: null == stores ? _self.stores : stores // ignore: cast_nullable_to_non_nullable
as List<Store>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,lastCreatedId: freezed == lastCreatedId ? _self.lastCreatedId : lastCreatedId // ignore: cast_nullable_to_non_nullable
as String?,lastWriteFailed: null == lastWriteFailed ? _self.lastWriteFailed : lastWriteFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StoresState].
extension StoresStatePatterns on StoresState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoresState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoresState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoresState value)  $default,){
final _that = this;
switch (_that) {
case _StoresState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoresState value)?  $default,){
final _that = this;
switch (_that) {
case _StoresState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EStoresStatus status,  List<Store> stores,  String errorMessage,  String? lastCreatedId,  bool lastWriteFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoresState() when $default != null:
return $default(_that.status,_that.stores,_that.errorMessage,_that.lastCreatedId,_that.lastWriteFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EStoresStatus status,  List<Store> stores,  String errorMessage,  String? lastCreatedId,  bool lastWriteFailed)  $default,) {final _that = this;
switch (_that) {
case _StoresState():
return $default(_that.status,_that.stores,_that.errorMessage,_that.lastCreatedId,_that.lastWriteFailed);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EStoresStatus status,  List<Store> stores,  String errorMessage,  String? lastCreatedId,  bool lastWriteFailed)?  $default,) {final _that = this;
switch (_that) {
case _StoresState() when $default != null:
return $default(_that.status,_that.stores,_that.errorMessage,_that.lastCreatedId,_that.lastWriteFailed);case _:
  return null;

}
}

}

/// @nodoc


class _StoresState implements StoresState {
  const _StoresState({this.status = EStoresStatus.initial, final  List<Store> stores = const <Store>[], this.errorMessage = '', this.lastCreatedId, this.lastWriteFailed = false}): _stores = stores;
  

@override@JsonKey() final  EStoresStatus status;
 final  List<Store> _stores;
@override@JsonKey() List<Store> get stores {
  if (_stores is EqualUnmodifiableListView) return _stores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stores);
}

@override@JsonKey() final  String errorMessage;
/// The id of the store most recently created by `quickCreate`/`create`.
/// A one-shot signal a `BlocListener` consumes to pop the picker/create
/// screen with the new id — never read to derive displayed state.
@override final  String? lastCreatedId;
/// Whether the most recent write (quickCreate/create/delete) failed. A
/// one-shot signal for an error-toast listener — never read to derive
/// displayed state.
@override@JsonKey() final  bool lastWriteFailed;

/// Create a copy of StoresState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoresStateCopyWith<_StoresState> get copyWith => __$StoresStateCopyWithImpl<_StoresState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoresState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._stores, _stores)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastCreatedId, lastCreatedId) || other.lastCreatedId == lastCreatedId)&&(identical(other.lastWriteFailed, lastWriteFailed) || other.lastWriteFailed == lastWriteFailed));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_stores),errorMessage,lastCreatedId,lastWriteFailed);

@override
String toString() {
  return 'StoresState(status: $status, stores: $stores, errorMessage: $errorMessage, lastCreatedId: $lastCreatedId, lastWriteFailed: $lastWriteFailed)';
}


}

/// @nodoc
abstract mixin class _$StoresStateCopyWith<$Res> implements $StoresStateCopyWith<$Res> {
  factory _$StoresStateCopyWith(_StoresState value, $Res Function(_StoresState) _then) = __$StoresStateCopyWithImpl;
@override @useResult
$Res call({
 EStoresStatus status, List<Store> stores, String errorMessage, String? lastCreatedId, bool lastWriteFailed
});




}
/// @nodoc
class __$StoresStateCopyWithImpl<$Res>
    implements _$StoresStateCopyWith<$Res> {
  __$StoresStateCopyWithImpl(this._self, this._then);

  final _StoresState _self;
  final $Res Function(_StoresState) _then;

/// Create a copy of StoresState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? stores = null,Object? errorMessage = null,Object? lastCreatedId = freezed,Object? lastWriteFailed = null,}) {
  return _then(_StoresState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EStoresStatus,stores: null == stores ? _self._stores : stores // ignore: cast_nullable_to_non_nullable
as List<Store>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,lastCreatedId: freezed == lastCreatedId ? _self.lastCreatedId : lastCreatedId // ignore: cast_nullable_to_non_nullable
as String?,lastWriteFailed: null == lastWriteFailed ? _self.lastWriteFailed : lastWriteFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
