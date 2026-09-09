// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncEvent()';
}


}

/// @nodoc
class $SyncEventCopyWith<$Res>  {
$SyncEventCopyWith(SyncEvent _, $Res Function(SyncEvent) __);
}


/// Adds pattern-matching-related methods to [SyncEvent].
extension SyncEventPatterns on SyncEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,TResult Function( _SyncNow value)?  syncNow,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _SyncNow() when syncNow != null:
return syncNow(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,required TResult Function( _SyncNow value)  syncNow,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);case _SyncNow():
return syncNow(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,TResult? Function( _SyncNow value)?  syncNow,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _SyncNow() when syncNow != null:
return syncNow(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  watch,TResult Function()?  syncNow,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _SyncNow() when syncNow != null:
return syncNow();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  watch,required TResult Function()  syncNow,}) {final _that = this;
switch (_that) {
case _Watch():
return watch();case _SyncNow():
return syncNow();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  watch,TResult? Function()?  syncNow,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _SyncNow() when syncNow != null:
return syncNow();case _:
  return null;

}
}

}

/// @nodoc


class _Watch implements SyncEvent {
  const _Watch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncEvent.watch()';
}


}




/// @nodoc


class _SyncNow implements SyncEvent {
  const _SyncNow();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncNow);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncEvent.syncNow()';
}


}




/// @nodoc
mixin _$SyncState {

 ESyncUiStatus get status; String get errorMessage;/// Rows awaiting upload, across all seven collections.
 int get pendingCount;/// When the last successful cycle finished. Null until one has.
 DateTime? get lastSyncedAt;/// Receipt-photo bytes this account occupies, measured from object
/// metadata — never estimated.
 int get usedBytes;/// The active tier's quota, so the bar has a denominator.
 int get quotaBytes; bool get isPremium;/// Whether the device currently has a network path.
 bool get isOnline;
/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStateCopyWith<SyncState> get copyWith => _$SyncStateCopyWithImpl<SyncState>(this as SyncState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt)&&(identical(other.usedBytes, usedBytes) || other.usedBytes == usedBytes)&&(identical(other.quotaBytes, quotaBytes) || other.quotaBytes == quotaBytes)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage,pendingCount,lastSyncedAt,usedBytes,quotaBytes,isPremium,isOnline);

@override
String toString() {
  return 'SyncState(status: $status, errorMessage: $errorMessage, pendingCount: $pendingCount, lastSyncedAt: $lastSyncedAt, usedBytes: $usedBytes, quotaBytes: $quotaBytes, isPremium: $isPremium, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class $SyncStateCopyWith<$Res>  {
  factory $SyncStateCopyWith(SyncState value, $Res Function(SyncState) _then) = _$SyncStateCopyWithImpl;
@useResult
$Res call({
 ESyncUiStatus status, String errorMessage, int pendingCount, DateTime? lastSyncedAt, int usedBytes, int quotaBytes, bool isPremium, bool isOnline
});




}
/// @nodoc
class _$SyncStateCopyWithImpl<$Res>
    implements $SyncStateCopyWith<$Res> {
  _$SyncStateCopyWithImpl(this._self, this._then);

  final SyncState _self;
  final $Res Function(SyncState) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? errorMessage = null,Object? pendingCount = null,Object? lastSyncedAt = freezed,Object? usedBytes = null,Object? quotaBytes = null,Object? isPremium = null,Object? isOnline = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ESyncUiStatus,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,usedBytes: null == usedBytes ? _self.usedBytes : usedBytes // ignore: cast_nullable_to_non_nullable
as int,quotaBytes: null == quotaBytes ? _self.quotaBytes : quotaBytes // ignore: cast_nullable_to_non_nullable
as int,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncState].
extension SyncStatePatterns on SyncState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncState value)  $default,){
final _that = this;
switch (_that) {
case _SyncState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncState value)?  $default,){
final _that = this;
switch (_that) {
case _SyncState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ESyncUiStatus status,  String errorMessage,  int pendingCount,  DateTime? lastSyncedAt,  int usedBytes,  int quotaBytes,  bool isPremium,  bool isOnline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that.status,_that.errorMessage,_that.pendingCount,_that.lastSyncedAt,_that.usedBytes,_that.quotaBytes,_that.isPremium,_that.isOnline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ESyncUiStatus status,  String errorMessage,  int pendingCount,  DateTime? lastSyncedAt,  int usedBytes,  int quotaBytes,  bool isPremium,  bool isOnline)  $default,) {final _that = this;
switch (_that) {
case _SyncState():
return $default(_that.status,_that.errorMessage,_that.pendingCount,_that.lastSyncedAt,_that.usedBytes,_that.quotaBytes,_that.isPremium,_that.isOnline);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ESyncUiStatus status,  String errorMessage,  int pendingCount,  DateTime? lastSyncedAt,  int usedBytes,  int quotaBytes,  bool isPremium,  bool isOnline)?  $default,) {final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that.status,_that.errorMessage,_that.pendingCount,_that.lastSyncedAt,_that.usedBytes,_that.quotaBytes,_that.isPremium,_that.isOnline);case _:
  return null;

}
}

}

/// @nodoc


class _SyncState implements SyncState {
  const _SyncState({this.status = ESyncUiStatus.disabled, this.errorMessage = '', this.pendingCount = 0, this.lastSyncedAt, this.usedBytes = 0, this.quotaBytes = AppLimits.freeCloudQuotaBytes, this.isPremium = false, this.isOnline = true});
  

@override@JsonKey() final  ESyncUiStatus status;
@override@JsonKey() final  String errorMessage;
/// Rows awaiting upload, across all seven collections.
@override@JsonKey() final  int pendingCount;
/// When the last successful cycle finished. Null until one has.
@override final  DateTime? lastSyncedAt;
/// Receipt-photo bytes this account occupies, measured from object
/// metadata — never estimated.
@override@JsonKey() final  int usedBytes;
/// The active tier's quota, so the bar has a denominator.
@override@JsonKey() final  int quotaBytes;
@override@JsonKey() final  bool isPremium;
/// Whether the device currently has a network path.
@override@JsonKey() final  bool isOnline;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncStateCopyWith<_SyncState> get copyWith => __$SyncStateCopyWithImpl<_SyncState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt)&&(identical(other.usedBytes, usedBytes) || other.usedBytes == usedBytes)&&(identical(other.quotaBytes, quotaBytes) || other.quotaBytes == quotaBytes)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage,pendingCount,lastSyncedAt,usedBytes,quotaBytes,isPremium,isOnline);

@override
String toString() {
  return 'SyncState(status: $status, errorMessage: $errorMessage, pendingCount: $pendingCount, lastSyncedAt: $lastSyncedAt, usedBytes: $usedBytes, quotaBytes: $quotaBytes, isPremium: $isPremium, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class _$SyncStateCopyWith<$Res> implements $SyncStateCopyWith<$Res> {
  factory _$SyncStateCopyWith(_SyncState value, $Res Function(_SyncState) _then) = __$SyncStateCopyWithImpl;
@override @useResult
$Res call({
 ESyncUiStatus status, String errorMessage, int pendingCount, DateTime? lastSyncedAt, int usedBytes, int quotaBytes, bool isPremium, bool isOnline
});




}
/// @nodoc
class __$SyncStateCopyWithImpl<$Res>
    implements _$SyncStateCopyWith<$Res> {
  __$SyncStateCopyWithImpl(this._self, this._then);

  final _SyncState _self;
  final $Res Function(_SyncState) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? errorMessage = null,Object? pendingCount = null,Object? lastSyncedAt = freezed,Object? usedBytes = null,Object? quotaBytes = null,Object? isPremium = null,Object? isOnline = null,}) {
  return _then(_SyncState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ESyncUiStatus,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,usedBytes: null == usedBytes ? _self.usedBytes : usedBytes // ignore: cast_nullable_to_non_nullable
as int,quotaBytes: null == quotaBytes ? _self.quotaBytes : quotaBytes // ignore: cast_nullable_to_non_nullable
as int,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
