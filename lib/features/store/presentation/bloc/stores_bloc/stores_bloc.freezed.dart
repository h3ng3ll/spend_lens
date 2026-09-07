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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  watch,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  watch,}) {final _that = this;
switch (_that) {
case _Watch():
return watch();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  watch,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _:
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
mixin _$StoresState {

 EStoresStatus get status; List<Store> get stores; String get errorMessage;
/// Create a copy of StoresState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoresStateCopyWith<StoresState> get copyWith => _$StoresStateCopyWithImpl<StoresState>(this as StoresState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoresState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.stores, stores)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(stores),errorMessage);

@override
String toString() {
  return 'StoresState(status: $status, stores: $stores, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $StoresStateCopyWith<$Res>  {
  factory $StoresStateCopyWith(StoresState value, $Res Function(StoresState) _then) = _$StoresStateCopyWithImpl;
@useResult
$Res call({
 EStoresStatus status, List<Store> stores, String errorMessage
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
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? stores = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EStoresStatus,stores: null == stores ? _self.stores : stores // ignore: cast_nullable_to_non_nullable
as List<Store>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EStoresStatus status,  List<Store> stores,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoresState() when $default != null:
return $default(_that.status,_that.stores,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EStoresStatus status,  List<Store> stores,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _StoresState():
return $default(_that.status,_that.stores,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EStoresStatus status,  List<Store> stores,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _StoresState() when $default != null:
return $default(_that.status,_that.stores,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _StoresState implements StoresState {
  const _StoresState({this.status = EStoresStatus.initial, final  List<Store> stores = const <Store>[], this.errorMessage = ''}): _stores = stores;
  

@override@JsonKey() final  EStoresStatus status;
 final  List<Store> _stores;
@override@JsonKey() List<Store> get stores {
  if (_stores is EqualUnmodifiableListView) return _stores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stores);
}

@override@JsonKey() final  String errorMessage;

/// Create a copy of StoresState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoresStateCopyWith<_StoresState> get copyWith => __$StoresStateCopyWithImpl<_StoresState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoresState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._stores, _stores)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_stores),errorMessage);

@override
String toString() {
  return 'StoresState(status: $status, stores: $stores, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$StoresStateCopyWith<$Res> implements $StoresStateCopyWith<$Res> {
  factory _$StoresStateCopyWith(_StoresState value, $Res Function(_StoresState) _then) = __$StoresStateCopyWithImpl;
@override @useResult
$Res call({
 EStoresStatus status, List<Store> stores, String errorMessage
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
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? stores = null,Object? errorMessage = null,}) {
  return _then(_StoresState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EStoresStatus,stores: null == stores ? _self._stores : stores // ignore: cast_nullable_to_non_nullable
as List<Store>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
