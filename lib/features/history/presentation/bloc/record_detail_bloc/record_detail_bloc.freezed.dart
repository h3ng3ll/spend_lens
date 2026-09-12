// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_detail_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecordDetailEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordDetailEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RecordDetailEvent()';
}


}

/// @nodoc
class $RecordDetailEventCopyWith<$Res>  {
$RecordDetailEventCopyWith(RecordDetailEvent _, $Res Function(RecordDetailEvent) __);
}


/// Adds pattern-matching-related methods to [RecordDetailEvent].
extension RecordDetailEventPatterns on RecordDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,TResult Function( _DeleteRecord value)?  deleteRecord,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _DeleteRecord() when deleteRecord != null:
return deleteRecord(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,required TResult Function( _DeleteRecord value)  deleteRecord,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);case _DeleteRecord():
return deleteRecord(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,TResult? Function( _DeleteRecord value)?  deleteRecord,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _DeleteRecord() when deleteRecord != null:
return deleteRecord(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  watch,TResult Function()?  deleteRecord,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _DeleteRecord() when deleteRecord != null:
return deleteRecord();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  watch,required TResult Function()  deleteRecord,}) {final _that = this;
switch (_that) {
case _Watch():
return watch();case _DeleteRecord():
return deleteRecord();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  watch,TResult? Function()?  deleteRecord,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _DeleteRecord() when deleteRecord != null:
return deleteRecord();case _:
  return null;

}
}

}

/// @nodoc


class _Watch implements RecordDetailEvent {
  const _Watch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RecordDetailEvent.watch()';
}


}




/// @nodoc


class _DeleteRecord implements RecordDetailEvent {
  const _DeleteRecord();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteRecord);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RecordDetailEvent.deleteRecord()';
}


}




/// @nodoc
mixin _$RecordDetailState {

/// The record this screen was opened for.
///
/// Lives in STATE, not as a bloc field: a value the UI and the handlers
/// both need is state by definition, and a public field on the bloc is
/// invisible to `BlocBuilder`/`BlocSelector` and unreachable from
/// `bloc_test`'s state assertions. Seeded by the constructor, then never
/// reassigned — the screen is built per record (`registerFactory`
/// semantics) and a bloc instance never switches to a different one.
 String get recordId; ERecordDetailStatus get status; RecordDetailSnapshot? get snapshot; String get errorMessage;/// Whether the most recent `deleteRecord` write failed. A one-shot
/// signal for an error-toast listener — never read to derive displayed
/// state.
 bool get lastDeleteFailed;
/// Create a copy of RecordDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordDetailStateCopyWith<RecordDetailState> get copyWith => _$RecordDetailStateCopyWithImpl<RecordDetailState>(this as RecordDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordDetailState&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.status, status) || other.status == status)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastDeleteFailed, lastDeleteFailed) || other.lastDeleteFailed == lastDeleteFailed));
}


@override
int get hashCode => Object.hash(runtimeType,recordId,status,snapshot,errorMessage,lastDeleteFailed);

@override
String toString() {
  return 'RecordDetailState(recordId: $recordId, status: $status, snapshot: $snapshot, errorMessage: $errorMessage, lastDeleteFailed: $lastDeleteFailed)';
}


}

/// @nodoc
abstract mixin class $RecordDetailStateCopyWith<$Res>  {
  factory $RecordDetailStateCopyWith(RecordDetailState value, $Res Function(RecordDetailState) _then) = _$RecordDetailStateCopyWithImpl;
@useResult
$Res call({
 String recordId, ERecordDetailStatus status, RecordDetailSnapshot? snapshot, String errorMessage, bool lastDeleteFailed
});




}
/// @nodoc
class _$RecordDetailStateCopyWithImpl<$Res>
    implements $RecordDetailStateCopyWith<$Res> {
  _$RecordDetailStateCopyWithImpl(this._self, this._then);

  final RecordDetailState _self;
  final $Res Function(RecordDetailState) _then;

/// Create a copy of RecordDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recordId = null,Object? status = null,Object? snapshot = freezed,Object? errorMessage = null,Object? lastDeleteFailed = null,}) {
  return _then(_self.copyWith(
recordId: null == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ERecordDetailStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as RecordDetailSnapshot?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,lastDeleteFailed: null == lastDeleteFailed ? _self.lastDeleteFailed : lastDeleteFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecordDetailState].
extension RecordDetailStatePatterns on RecordDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordDetailState value)  $default,){
final _that = this;
switch (_that) {
case _RecordDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _RecordDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String recordId,  ERecordDetailStatus status,  RecordDetailSnapshot? snapshot,  String errorMessage,  bool lastDeleteFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordDetailState() when $default != null:
return $default(_that.recordId,_that.status,_that.snapshot,_that.errorMessage,_that.lastDeleteFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String recordId,  ERecordDetailStatus status,  RecordDetailSnapshot? snapshot,  String errorMessage,  bool lastDeleteFailed)  $default,) {final _that = this;
switch (_that) {
case _RecordDetailState():
return $default(_that.recordId,_that.status,_that.snapshot,_that.errorMessage,_that.lastDeleteFailed);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String recordId,  ERecordDetailStatus status,  RecordDetailSnapshot? snapshot,  String errorMessage,  bool lastDeleteFailed)?  $default,) {final _that = this;
switch (_that) {
case _RecordDetailState() when $default != null:
return $default(_that.recordId,_that.status,_that.snapshot,_that.errorMessage,_that.lastDeleteFailed);case _:
  return null;

}
}

}

/// @nodoc


class _RecordDetailState implements RecordDetailState {
  const _RecordDetailState({this.recordId = '', this.status = ERecordDetailStatus.initial, this.snapshot, this.errorMessage = '', this.lastDeleteFailed = false});
  

/// The record this screen was opened for.
///
/// Lives in STATE, not as a bloc field: a value the UI and the handlers
/// both need is state by definition, and a public field on the bloc is
/// invisible to `BlocBuilder`/`BlocSelector` and unreachable from
/// `bloc_test`'s state assertions. Seeded by the constructor, then never
/// reassigned — the screen is built per record (`registerFactory`
/// semantics) and a bloc instance never switches to a different one.
@override@JsonKey() final  String recordId;
@override@JsonKey() final  ERecordDetailStatus status;
@override final  RecordDetailSnapshot? snapshot;
@override@JsonKey() final  String errorMessage;
/// Whether the most recent `deleteRecord` write failed. A one-shot
/// signal for an error-toast listener — never read to derive displayed
/// state.
@override@JsonKey() final  bool lastDeleteFailed;

/// Create a copy of RecordDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordDetailStateCopyWith<_RecordDetailState> get copyWith => __$RecordDetailStateCopyWithImpl<_RecordDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordDetailState&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.status, status) || other.status == status)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastDeleteFailed, lastDeleteFailed) || other.lastDeleteFailed == lastDeleteFailed));
}


@override
int get hashCode => Object.hash(runtimeType,recordId,status,snapshot,errorMessage,lastDeleteFailed);

@override
String toString() {
  return 'RecordDetailState(recordId: $recordId, status: $status, snapshot: $snapshot, errorMessage: $errorMessage, lastDeleteFailed: $lastDeleteFailed)';
}


}

/// @nodoc
abstract mixin class _$RecordDetailStateCopyWith<$Res> implements $RecordDetailStateCopyWith<$Res> {
  factory _$RecordDetailStateCopyWith(_RecordDetailState value, $Res Function(_RecordDetailState) _then) = __$RecordDetailStateCopyWithImpl;
@override @useResult
$Res call({
 String recordId, ERecordDetailStatus status, RecordDetailSnapshot? snapshot, String errorMessage, bool lastDeleteFailed
});




}
/// @nodoc
class __$RecordDetailStateCopyWithImpl<$Res>
    implements _$RecordDetailStateCopyWith<$Res> {
  __$RecordDetailStateCopyWithImpl(this._self, this._then);

  final _RecordDetailState _self;
  final $Res Function(_RecordDetailState) _then;

/// Create a copy of RecordDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recordId = null,Object? status = null,Object? snapshot = freezed,Object? errorMessage = null,Object? lastDeleteFailed = null,}) {
  return _then(_RecordDetailState(
recordId: null == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ERecordDetailStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as RecordDetailSnapshot?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,lastDeleteFailed: null == lastDeleteFailed ? _self.lastDeleteFailed : lastDeleteFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
