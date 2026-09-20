// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compare_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CompareEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompareEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompareEvent()';
}


}

/// @nodoc
class $CompareEventCopyWith<$Res>  {
$CompareEventCopyWith(CompareEvent _, $Res Function(CompareEvent) __);
}


/// Adds pattern-matching-related methods to [CompareEvent].
extension CompareEventPatterns on CompareEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,TResult Function( _SelectLeft value)?  selectLeftStore,TResult Function( _SelectRight value)?  selectRightStore,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _SelectLeft() when selectLeftStore != null:
return selectLeftStore(_that);case _SelectRight() when selectRightStore != null:
return selectRightStore(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,required TResult Function( _SelectLeft value)  selectLeftStore,required TResult Function( _SelectRight value)  selectRightStore,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);case _SelectLeft():
return selectLeftStore(_that);case _SelectRight():
return selectRightStore(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,TResult? Function( _SelectLeft value)?  selectLeftStore,TResult? Function( _SelectRight value)?  selectRightStore,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _SelectLeft() when selectLeftStore != null:
return selectLeftStore(_that);case _SelectRight() when selectRightStore != null:
return selectRightStore(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  watch,TResult Function( String storeId)?  selectLeftStore,TResult Function( String storeId)?  selectRightStore,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _SelectLeft() when selectLeftStore != null:
return selectLeftStore(_that.storeId);case _SelectRight() when selectRightStore != null:
return selectRightStore(_that.storeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  watch,required TResult Function( String storeId)  selectLeftStore,required TResult Function( String storeId)  selectRightStore,}) {final _that = this;
switch (_that) {
case _Watch():
return watch();case _SelectLeft():
return selectLeftStore(_that.storeId);case _SelectRight():
return selectRightStore(_that.storeId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  watch,TResult? Function( String storeId)?  selectLeftStore,TResult? Function( String storeId)?  selectRightStore,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _SelectLeft() when selectLeftStore != null:
return selectLeftStore(_that.storeId);case _SelectRight() when selectRightStore != null:
return selectRightStore(_that.storeId);case _:
  return null;

}
}

}

/// @nodoc


class _Watch implements CompareEvent {
  const _Watch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompareEvent.watch()';
}


}




/// @nodoc


class _SelectLeft implements CompareEvent {
  const _SelectLeft(this.storeId);
  

 final  String storeId;

/// Create a copy of CompareEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectLeftCopyWith<_SelectLeft> get copyWith => __$SelectLeftCopyWithImpl<_SelectLeft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectLeft&&(identical(other.storeId, storeId) || other.storeId == storeId));
}


@override
int get hashCode => Object.hash(runtimeType,storeId);

@override
String toString() {
  return 'CompareEvent.selectLeftStore(storeId: $storeId)';
}


}

/// @nodoc
abstract mixin class _$SelectLeftCopyWith<$Res> implements $CompareEventCopyWith<$Res> {
  factory _$SelectLeftCopyWith(_SelectLeft value, $Res Function(_SelectLeft) _then) = __$SelectLeftCopyWithImpl;
@useResult
$Res call({
 String storeId
});




}
/// @nodoc
class __$SelectLeftCopyWithImpl<$Res>
    implements _$SelectLeftCopyWith<$Res> {
  __$SelectLeftCopyWithImpl(this._self, this._then);

  final _SelectLeft _self;
  final $Res Function(_SelectLeft) _then;

/// Create a copy of CompareEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeId = null,}) {
  return _then(_SelectLeft(
null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SelectRight implements CompareEvent {
  const _SelectRight(this.storeId);
  

 final  String storeId;

/// Create a copy of CompareEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectRightCopyWith<_SelectRight> get copyWith => __$SelectRightCopyWithImpl<_SelectRight>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectRight&&(identical(other.storeId, storeId) || other.storeId == storeId));
}


@override
int get hashCode => Object.hash(runtimeType,storeId);

@override
String toString() {
  return 'CompareEvent.selectRightStore(storeId: $storeId)';
}


}

/// @nodoc
abstract mixin class _$SelectRightCopyWith<$Res> implements $CompareEventCopyWith<$Res> {
  factory _$SelectRightCopyWith(_SelectRight value, $Res Function(_SelectRight) _then) = __$SelectRightCopyWithImpl;
@useResult
$Res call({
 String storeId
});




}
/// @nodoc
class __$SelectRightCopyWithImpl<$Res>
    implements _$SelectRightCopyWith<$Res> {
  __$SelectRightCopyWithImpl(this._self, this._then);

  final _SelectRight _self;
  final $Res Function(_SelectRight) _then;

/// Create a copy of CompareEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeId = null,}) {
  return _then(_SelectRight(
null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$CompareState {

 ECompareStatus get status; CompareSnapshot? get snapshot;/// The two stores being compared. These are USER SELECTIONS, not derived
/// data, so they are legitimate state — unlike the per-column product
/// lists, which are recomputed in the widget layer.
 String? get leftStoreId; String? get rightStoreId; String get errorMessage;
/// Create a copy of CompareState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompareStateCopyWith<CompareState> get copyWith => _$CompareStateCopyWithImpl<CompareState>(this as CompareState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompareState&&(identical(other.status, status) || other.status == status)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.leftStoreId, leftStoreId) || other.leftStoreId == leftStoreId)&&(identical(other.rightStoreId, rightStoreId) || other.rightStoreId == rightStoreId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,snapshot,leftStoreId,rightStoreId,errorMessage);

@override
String toString() {
  return 'CompareState(status: $status, snapshot: $snapshot, leftStoreId: $leftStoreId, rightStoreId: $rightStoreId, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $CompareStateCopyWith<$Res>  {
  factory $CompareStateCopyWith(CompareState value, $Res Function(CompareState) _then) = _$CompareStateCopyWithImpl;
@useResult
$Res call({
 ECompareStatus status, CompareSnapshot? snapshot, String? leftStoreId, String? rightStoreId, String errorMessage
});




}
/// @nodoc
class _$CompareStateCopyWithImpl<$Res>
    implements $CompareStateCopyWith<$Res> {
  _$CompareStateCopyWithImpl(this._self, this._then);

  final CompareState _self;
  final $Res Function(CompareState) _then;

/// Create a copy of CompareState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? snapshot = freezed,Object? leftStoreId = freezed,Object? rightStoreId = freezed,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ECompareStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as CompareSnapshot?,leftStoreId: freezed == leftStoreId ? _self.leftStoreId : leftStoreId // ignore: cast_nullable_to_non_nullable
as String?,rightStoreId: freezed == rightStoreId ? _self.rightStoreId : rightStoreId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CompareState].
extension CompareStatePatterns on CompareState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompareState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompareState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompareState value)  $default,){
final _that = this;
switch (_that) {
case _CompareState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompareState value)?  $default,){
final _that = this;
switch (_that) {
case _CompareState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ECompareStatus status,  CompareSnapshot? snapshot,  String? leftStoreId,  String? rightStoreId,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompareState() when $default != null:
return $default(_that.status,_that.snapshot,_that.leftStoreId,_that.rightStoreId,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ECompareStatus status,  CompareSnapshot? snapshot,  String? leftStoreId,  String? rightStoreId,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _CompareState():
return $default(_that.status,_that.snapshot,_that.leftStoreId,_that.rightStoreId,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ECompareStatus status,  CompareSnapshot? snapshot,  String? leftStoreId,  String? rightStoreId,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _CompareState() when $default != null:
return $default(_that.status,_that.snapshot,_that.leftStoreId,_that.rightStoreId,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _CompareState implements CompareState {
  const _CompareState({this.status = ECompareStatus.initial, this.snapshot, this.leftStoreId, this.rightStoreId, this.errorMessage = ''});
  

@override@JsonKey() final  ECompareStatus status;
@override final  CompareSnapshot? snapshot;
/// The two stores being compared. These are USER SELECTIONS, not derived
/// data, so they are legitimate state — unlike the per-column product
/// lists, which are recomputed in the widget layer.
@override final  String? leftStoreId;
@override final  String? rightStoreId;
@override@JsonKey() final  String errorMessage;

/// Create a copy of CompareState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompareStateCopyWith<_CompareState> get copyWith => __$CompareStateCopyWithImpl<_CompareState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompareState&&(identical(other.status, status) || other.status == status)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.leftStoreId, leftStoreId) || other.leftStoreId == leftStoreId)&&(identical(other.rightStoreId, rightStoreId) || other.rightStoreId == rightStoreId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,snapshot,leftStoreId,rightStoreId,errorMessage);

@override
String toString() {
  return 'CompareState(status: $status, snapshot: $snapshot, leftStoreId: $leftStoreId, rightStoreId: $rightStoreId, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$CompareStateCopyWith<$Res> implements $CompareStateCopyWith<$Res> {
  factory _$CompareStateCopyWith(_CompareState value, $Res Function(_CompareState) _then) = __$CompareStateCopyWithImpl;
@override @useResult
$Res call({
 ECompareStatus status, CompareSnapshot? snapshot, String? leftStoreId, String? rightStoreId, String errorMessage
});




}
/// @nodoc
class __$CompareStateCopyWithImpl<$Res>
    implements _$CompareStateCopyWith<$Res> {
  __$CompareStateCopyWithImpl(this._self, this._then);

  final _CompareState _self;
  final $Res Function(_CompareState) _then;

/// Create a copy of CompareState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? snapshot = freezed,Object? leftStoreId = freezed,Object? rightStoreId = freezed,Object? errorMessage = null,}) {
  return _then(_CompareState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ECompareStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as CompareSnapshot?,leftStoreId: freezed == leftStoreId ? _self.leftStoreId : leftStoreId // ignore: cast_nullable_to_non_nullable
as String?,rightStoreId: freezed == rightStoreId ? _self.rightStoreId : rightStoreId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
