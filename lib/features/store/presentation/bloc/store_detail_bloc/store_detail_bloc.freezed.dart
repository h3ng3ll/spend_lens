// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_detail_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoreDetailEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreDetailEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoreDetailEvent()';
}


}

/// @nodoc
class $StoreDetailEventCopyWith<$Res>  {
$StoreDetailEventCopyWith(StoreDetailEvent _, $Res Function(StoreDetailEvent) __);
}


/// Adds pattern-matching-related methods to [StoreDetailEvent].
extension StoreDetailEventPatterns on StoreDetailEvent {
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


class _Watch implements StoreDetailEvent {
  const _Watch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoreDetailEvent.watch()';
}


}




/// @nodoc
mixin _$StoreDetailState {

 EStoreDetailStatus get status; StoreDetailSnapshot? get snapshot; String get errorMessage;
/// Create a copy of StoreDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreDetailStateCopyWith<StoreDetailState> get copyWith => _$StoreDetailStateCopyWithImpl<StoreDetailState>(this as StoreDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,snapshot,errorMessage);

@override
String toString() {
  return 'StoreDetailState(status: $status, snapshot: $snapshot, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $StoreDetailStateCopyWith<$Res>  {
  factory $StoreDetailStateCopyWith(StoreDetailState value, $Res Function(StoreDetailState) _then) = _$StoreDetailStateCopyWithImpl;
@useResult
$Res call({
 EStoreDetailStatus status, StoreDetailSnapshot? snapshot, String errorMessage
});




}
/// @nodoc
class _$StoreDetailStateCopyWithImpl<$Res>
    implements $StoreDetailStateCopyWith<$Res> {
  _$StoreDetailStateCopyWithImpl(this._self, this._then);

  final StoreDetailState _self;
  final $Res Function(StoreDetailState) _then;

/// Create a copy of StoreDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? snapshot = freezed,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EStoreDetailStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as StoreDetailSnapshot?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreDetailState].
extension StoreDetailStatePatterns on StoreDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreDetailState value)  $default,){
final _that = this;
switch (_that) {
case _StoreDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _StoreDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EStoreDetailStatus status,  StoreDetailSnapshot? snapshot,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreDetailState() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EStoreDetailStatus status,  StoreDetailSnapshot? snapshot,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _StoreDetailState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EStoreDetailStatus status,  StoreDetailSnapshot? snapshot,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _StoreDetailState() when $default != null:
return $default(_that.status,_that.snapshot,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _StoreDetailState implements StoreDetailState {
  const _StoreDetailState({this.status = EStoreDetailStatus.initial, this.snapshot, this.errorMessage = ''});
  

@override@JsonKey() final  EStoreDetailStatus status;
@override final  StoreDetailSnapshot? snapshot;
@override@JsonKey() final  String errorMessage;

/// Create a copy of StoreDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreDetailStateCopyWith<_StoreDetailState> get copyWith => __$StoreDetailStateCopyWithImpl<_StoreDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,snapshot,errorMessage);

@override
String toString() {
  return 'StoreDetailState(status: $status, snapshot: $snapshot, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$StoreDetailStateCopyWith<$Res> implements $StoreDetailStateCopyWith<$Res> {
  factory _$StoreDetailStateCopyWith(_StoreDetailState value, $Res Function(_StoreDetailState) _then) = __$StoreDetailStateCopyWithImpl;
@override @useResult
$Res call({
 EStoreDetailStatus status, StoreDetailSnapshot? snapshot, String errorMessage
});




}
/// @nodoc
class __$StoreDetailStateCopyWithImpl<$Res>
    implements _$StoreDetailStateCopyWith<$Res> {
  __$StoreDetailStateCopyWithImpl(this._self, this._then);

  final _StoreDetailState _self;
  final $Res Function(_StoreDetailState) _then;

/// Create a copy of StoreDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? snapshot = freezed,Object? errorMessage = null,}) {
  return _then(_StoreDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EStoreDetailStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as StoreDetailSnapshot?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
