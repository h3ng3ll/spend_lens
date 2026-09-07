// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_history_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PriceHistoryEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceHistoryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PriceHistoryEvent()';
}


}

/// @nodoc
class $PriceHistoryEventCopyWith<$Res>  {
$PriceHistoryEventCopyWith(PriceHistoryEvent _, $Res Function(PriceHistoryEvent) __);
}


/// Adds pattern-matching-related methods to [PriceHistoryEvent].
extension PriceHistoryEventPatterns on PriceHistoryEvent {
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


class _Watch implements PriceHistoryEvent {
  const _Watch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PriceHistoryEvent.watch()';
}


}




/// @nodoc
mixin _$PriceHistoryState {

 EPriceHistoryStatus get status; PriceHistorySnapshot? get snapshot; String get errorMessage;
/// Create a copy of PriceHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceHistoryStateCopyWith<PriceHistoryState> get copyWith => _$PriceHistoryStateCopyWithImpl<PriceHistoryState>(this as PriceHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceHistoryState&&(identical(other.status, status) || other.status == status)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,snapshot,errorMessage);

@override
String toString() {
  return 'PriceHistoryState(status: $status, snapshot: $snapshot, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PriceHistoryStateCopyWith<$Res>  {
  factory $PriceHistoryStateCopyWith(PriceHistoryState value, $Res Function(PriceHistoryState) _then) = _$PriceHistoryStateCopyWithImpl;
@useResult
$Res call({
 EPriceHistoryStatus status, PriceHistorySnapshot? snapshot, String errorMessage
});




}
/// @nodoc
class _$PriceHistoryStateCopyWithImpl<$Res>
    implements $PriceHistoryStateCopyWith<$Res> {
  _$PriceHistoryStateCopyWithImpl(this._self, this._then);

  final PriceHistoryState _self;
  final $Res Function(PriceHistoryState) _then;

/// Create a copy of PriceHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? snapshot = freezed,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EPriceHistoryStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as PriceHistorySnapshot?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceHistoryState].
extension PriceHistoryStatePatterns on PriceHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _PriceHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _PriceHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EPriceHistoryStatus status,  PriceHistorySnapshot? snapshot,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceHistoryState() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EPriceHistoryStatus status,  PriceHistorySnapshot? snapshot,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PriceHistoryState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EPriceHistoryStatus status,  PriceHistorySnapshot? snapshot,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PriceHistoryState() when $default != null:
return $default(_that.status,_that.snapshot,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PriceHistoryState implements PriceHistoryState {
  const _PriceHistoryState({this.status = EPriceHistoryStatus.initial, this.snapshot, this.errorMessage = ''});
  

@override@JsonKey() final  EPriceHistoryStatus status;
@override final  PriceHistorySnapshot? snapshot;
@override@JsonKey() final  String errorMessage;

/// Create a copy of PriceHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceHistoryStateCopyWith<_PriceHistoryState> get copyWith => __$PriceHistoryStateCopyWithImpl<_PriceHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceHistoryState&&(identical(other.status, status) || other.status == status)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,snapshot,errorMessage);

@override
String toString() {
  return 'PriceHistoryState(status: $status, snapshot: $snapshot, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PriceHistoryStateCopyWith<$Res> implements $PriceHistoryStateCopyWith<$Res> {
  factory _$PriceHistoryStateCopyWith(_PriceHistoryState value, $Res Function(_PriceHistoryState) _then) = __$PriceHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 EPriceHistoryStatus status, PriceHistorySnapshot? snapshot, String errorMessage
});




}
/// @nodoc
class __$PriceHistoryStateCopyWithImpl<$Res>
    implements _$PriceHistoryStateCopyWith<$Res> {
  __$PriceHistoryStateCopyWithImpl(this._self, this._then);

  final _PriceHistoryState _self;
  final $Res Function(_PriceHistoryState) _then;

/// Create a copy of PriceHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? snapshot = freezed,Object? errorMessage = null,}) {
  return _then(_PriceHistoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EPriceHistoryStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as PriceHistorySnapshot?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
