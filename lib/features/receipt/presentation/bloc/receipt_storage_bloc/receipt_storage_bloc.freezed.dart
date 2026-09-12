// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_storage_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptStorageEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptStorageEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReceiptStorageEvent()';
}


}

/// @nodoc
class $ReceiptStorageEventCopyWith<$Res>  {
$ReceiptStorageEventCopyWith(ReceiptStorageEvent _, $Res Function(ReceiptStorageEvent) __);
}


/// Adds pattern-matching-related methods to [ReceiptStorageEvent].
extension ReceiptStorageEventPatterns on ReceiptStorageEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Load value)?  load,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Load value)  load,}){
final _that = this;
switch (_that) {
case _Load():
return load(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Load value)?  load,}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  load,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  load,}) {final _that = this;
switch (_that) {
case _Load():
return load();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  load,}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load();case _:
  return null;

}
}

}

/// @nodoc


class _Load implements ReceiptStorageEvent {
  const _Load();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Load);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReceiptStorageEvent.load()';
}


}




/// @nodoc
mixin _$ReceiptStorageState {

 EReceiptStorageStatus get status; ReceiptStorageInfo? get info; String get errorMessage;
/// Create a copy of ReceiptStorageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptStorageStateCopyWith<ReceiptStorageState> get copyWith => _$ReceiptStorageStateCopyWithImpl<ReceiptStorageState>(this as ReceiptStorageState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptStorageState&&(identical(other.status, status) || other.status == status)&&(identical(other.info, info) || other.info == info)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,info,errorMessage);

@override
String toString() {
  return 'ReceiptStorageState(status: $status, info: $info, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ReceiptStorageStateCopyWith<$Res>  {
  factory $ReceiptStorageStateCopyWith(ReceiptStorageState value, $Res Function(ReceiptStorageState) _then) = _$ReceiptStorageStateCopyWithImpl;
@useResult
$Res call({
 EReceiptStorageStatus status, ReceiptStorageInfo? info, String errorMessage
});




}
/// @nodoc
class _$ReceiptStorageStateCopyWithImpl<$Res>
    implements $ReceiptStorageStateCopyWith<$Res> {
  _$ReceiptStorageStateCopyWithImpl(this._self, this._then);

  final ReceiptStorageState _self;
  final $Res Function(ReceiptStorageState) _then;

/// Create a copy of ReceiptStorageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? info = freezed,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EReceiptStorageStatus,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as ReceiptStorageInfo?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptStorageState].
extension ReceiptStorageStatePatterns on ReceiptStorageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptStorageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptStorageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptStorageState value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptStorageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptStorageState value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptStorageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EReceiptStorageStatus status,  ReceiptStorageInfo? info,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptStorageState() when $default != null:
return $default(_that.status,_that.info,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EReceiptStorageStatus status,  ReceiptStorageInfo? info,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ReceiptStorageState():
return $default(_that.status,_that.info,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EReceiptStorageStatus status,  ReceiptStorageInfo? info,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptStorageState() when $default != null:
return $default(_that.status,_that.info,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptStorageState implements ReceiptStorageState {
  const _ReceiptStorageState({this.status = EReceiptStorageStatus.initial, this.info, this.errorMessage = ''});
  

@override@JsonKey() final  EReceiptStorageStatus status;
@override final  ReceiptStorageInfo? info;
@override@JsonKey() final  String errorMessage;

/// Create a copy of ReceiptStorageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptStorageStateCopyWith<_ReceiptStorageState> get copyWith => __$ReceiptStorageStateCopyWithImpl<_ReceiptStorageState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptStorageState&&(identical(other.status, status) || other.status == status)&&(identical(other.info, info) || other.info == info)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,info,errorMessage);

@override
String toString() {
  return 'ReceiptStorageState(status: $status, info: $info, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ReceiptStorageStateCopyWith<$Res> implements $ReceiptStorageStateCopyWith<$Res> {
  factory _$ReceiptStorageStateCopyWith(_ReceiptStorageState value, $Res Function(_ReceiptStorageState) _then) = __$ReceiptStorageStateCopyWithImpl;
@override @useResult
$Res call({
 EReceiptStorageStatus status, ReceiptStorageInfo? info, String errorMessage
});




}
/// @nodoc
class __$ReceiptStorageStateCopyWithImpl<$Res>
    implements _$ReceiptStorageStateCopyWith<$Res> {
  __$ReceiptStorageStateCopyWithImpl(this._self, this._then);

  final _ReceiptStorageState _self;
  final $Res Function(_ReceiptStorageState) _then;

/// Create a copy of ReceiptStorageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? info = freezed,Object? errorMessage = null,}) {
  return _then(_ReceiptStorageState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EReceiptStorageStatus,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as ReceiptStorageInfo?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
