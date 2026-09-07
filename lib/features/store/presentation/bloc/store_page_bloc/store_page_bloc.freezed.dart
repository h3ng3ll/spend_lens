// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_page_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StorePageEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorePageEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StorePageEvent()';
}


}

/// @nodoc
class $StorePageEventCopyWith<$Res>  {
$StorePageEventCopyWith(StorePageEvent _, $Res Function(StorePageEvent) __);
}


/// Adds pattern-matching-related methods to [StorePageEvent].
extension StorePageEventPatterns on StorePageEvent {
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


class _Watch implements StorePageEvent {
  const _Watch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StorePageEvent.watch()';
}


}




/// @nodoc
mixin _$StorePageState {

 EStorePageStatus get status; StorePageSnapshot? get snapshot; String get errorMessage;
/// Create a copy of StorePageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorePageStateCopyWith<StorePageState> get copyWith => _$StorePageStateCopyWithImpl<StorePageState>(this as StorePageState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorePageState&&(identical(other.status, status) || other.status == status)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,snapshot,errorMessage);

@override
String toString() {
  return 'StorePageState(status: $status, snapshot: $snapshot, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $StorePageStateCopyWith<$Res>  {
  factory $StorePageStateCopyWith(StorePageState value, $Res Function(StorePageState) _then) = _$StorePageStateCopyWithImpl;
@useResult
$Res call({
 EStorePageStatus status, StorePageSnapshot? snapshot, String errorMessage
});




}
/// @nodoc
class _$StorePageStateCopyWithImpl<$Res>
    implements $StorePageStateCopyWith<$Res> {
  _$StorePageStateCopyWithImpl(this._self, this._then);

  final StorePageState _self;
  final $Res Function(StorePageState) _then;

/// Create a copy of StorePageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? snapshot = freezed,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EStorePageStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as StorePageSnapshot?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StorePageState].
extension StorePageStatePatterns on StorePageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorePageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorePageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorePageState value)  $default,){
final _that = this;
switch (_that) {
case _StorePageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorePageState value)?  $default,){
final _that = this;
switch (_that) {
case _StorePageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EStorePageStatus status,  StorePageSnapshot? snapshot,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorePageState() when $default != null:
return $default(_that.status,_that.snapshot,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EStorePageStatus status,  StorePageSnapshot? snapshot,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _StorePageState():
return $default(_that.status,_that.snapshot,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EStorePageStatus status,  StorePageSnapshot? snapshot,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _StorePageState() when $default != null:
return $default(_that.status,_that.snapshot,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _StorePageState implements StorePageState {
  const _StorePageState({this.status = EStorePageStatus.initial, this.snapshot, this.errorMessage = ''});
  

@override@JsonKey() final  EStorePageStatus status;
@override final  StorePageSnapshot? snapshot;
@override@JsonKey() final  String errorMessage;

/// Create a copy of StorePageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorePageStateCopyWith<_StorePageState> get copyWith => __$StorePageStateCopyWithImpl<_StorePageState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorePageState&&(identical(other.status, status) || other.status == status)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,snapshot,errorMessage);

@override
String toString() {
  return 'StorePageState(status: $status, snapshot: $snapshot, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$StorePageStateCopyWith<$Res> implements $StorePageStateCopyWith<$Res> {
  factory _$StorePageStateCopyWith(_StorePageState value, $Res Function(_StorePageState) _then) = __$StorePageStateCopyWithImpl;
@override @useResult
$Res call({
 EStorePageStatus status, StorePageSnapshot? snapshot, String errorMessage
});




}
/// @nodoc
class __$StorePageStateCopyWithImpl<$Res>
    implements _$StorePageStateCopyWith<$Res> {
  __$StorePageStateCopyWithImpl(this._self, this._then);

  final _StorePageState _self;
  final $Res Function(_StorePageState) _then;

/// Create a copy of StorePageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? snapshot = freezed,Object? errorMessage = null,}) {
  return _then(_StorePageState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EStorePageStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as StorePageSnapshot?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
