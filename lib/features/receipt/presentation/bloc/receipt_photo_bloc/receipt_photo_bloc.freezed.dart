// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_photo_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptPhotoEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptPhotoEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReceiptPhotoEvent()';
}


}

/// @nodoc
class $ReceiptPhotoEventCopyWith<$Res>  {
$ReceiptPhotoEventCopyWith(ReceiptPhotoEvent _, $Res Function(ReceiptPhotoEvent) __);
}


/// Adds pattern-matching-related methods to [ReceiptPhotoEvent].
extension ReceiptPhotoEventPatterns on ReceiptPhotoEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Load value)?  load,TResult Function( _ReplaceFromFile value)?  replaceFromFile,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _ReplaceFromFile() when replaceFromFile != null:
return replaceFromFile(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Load value)  load,required TResult Function( _ReplaceFromFile value)  replaceFromFile,}){
final _that = this;
switch (_that) {
case _Load():
return load(_that);case _ReplaceFromFile():
return replaceFromFile(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Load value)?  load,TResult? Function( _ReplaceFromFile value)?  replaceFromFile,}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _ReplaceFromFile() when replaceFromFile != null:
return replaceFromFile(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String receiptId)?  load,TResult Function( File file)?  replaceFromFile,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that.receiptId);case _ReplaceFromFile() when replaceFromFile != null:
return replaceFromFile(_that.file);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String receiptId)  load,required TResult Function( File file)  replaceFromFile,}) {final _that = this;
switch (_that) {
case _Load():
return load(_that.receiptId);case _ReplaceFromFile():
return replaceFromFile(_that.file);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String receiptId)?  load,TResult? Function( File file)?  replaceFromFile,}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that.receiptId);case _ReplaceFromFile() when replaceFromFile != null:
return replaceFromFile(_that.file);case _:
  return null;

}
}

}

/// @nodoc


class _Load implements ReceiptPhotoEvent {
  const _Load(this.receiptId);
  

 final  String receiptId;

/// Create a copy of ReceiptPhotoEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadCopyWith<_Load> get copyWith => __$LoadCopyWithImpl<_Load>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Load&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId));
}


@override
int get hashCode => Object.hash(runtimeType,receiptId);

@override
String toString() {
  return 'ReceiptPhotoEvent.load(receiptId: $receiptId)';
}


}

/// @nodoc
abstract mixin class _$LoadCopyWith<$Res> implements $ReceiptPhotoEventCopyWith<$Res> {
  factory _$LoadCopyWith(_Load value, $Res Function(_Load) _then) = __$LoadCopyWithImpl;
@useResult
$Res call({
 String receiptId
});




}
/// @nodoc
class __$LoadCopyWithImpl<$Res>
    implements _$LoadCopyWith<$Res> {
  __$LoadCopyWithImpl(this._self, this._then);

  final _Load _self;
  final $Res Function(_Load) _then;

/// Create a copy of ReceiptPhotoEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? receiptId = null,}) {
  return _then(_Load(
null == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ReplaceFromFile implements ReceiptPhotoEvent {
  const _ReplaceFromFile(this.file);
  

 final  File file;

/// Create a copy of ReceiptPhotoEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReplaceFromFileCopyWith<_ReplaceFromFile> get copyWith => __$ReplaceFromFileCopyWithImpl<_ReplaceFromFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReplaceFromFile&&(identical(other.file, file) || other.file == file));
}


@override
int get hashCode => Object.hash(runtimeType,file);

@override
String toString() {
  return 'ReceiptPhotoEvent.replaceFromFile(file: $file)';
}


}

/// @nodoc
abstract mixin class _$ReplaceFromFileCopyWith<$Res> implements $ReceiptPhotoEventCopyWith<$Res> {
  factory _$ReplaceFromFileCopyWith(_ReplaceFromFile value, $Res Function(_ReplaceFromFile) _then) = __$ReplaceFromFileCopyWithImpl;
@useResult
$Res call({
 File file
});




}
/// @nodoc
class __$ReplaceFromFileCopyWithImpl<$Res>
    implements _$ReplaceFromFileCopyWith<$Res> {
  __$ReplaceFromFileCopyWithImpl(this._self, this._then);

  final _ReplaceFromFile _self;
  final $Res Function(_ReplaceFromFile) _then;

/// Create a copy of ReceiptPhotoEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = null,}) {
  return _then(_ReplaceFromFile(
null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as File,
  ));
}


}

/// @nodoc
mixin _$ReceiptPhotoState {

 EReceiptPhotoStatus get status; String? get receiptId;/// The FILENAME stored on `Receipt.imagePath`, never a full path — the
/// Documents directory it lives under is resolved at render time
/// because it changes across iOS reinstalls.
 String? get imagePath;
/// Create a copy of ReceiptPhotoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptPhotoStateCopyWith<ReceiptPhotoState> get copyWith => _$ReceiptPhotoStateCopyWithImpl<ReceiptPhotoState>(this as ReceiptPhotoState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptPhotoState&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}


@override
int get hashCode => Object.hash(runtimeType,status,receiptId,imagePath);

@override
String toString() {
  return 'ReceiptPhotoState(status: $status, receiptId: $receiptId, imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class $ReceiptPhotoStateCopyWith<$Res>  {
  factory $ReceiptPhotoStateCopyWith(ReceiptPhotoState value, $Res Function(ReceiptPhotoState) _then) = _$ReceiptPhotoStateCopyWithImpl;
@useResult
$Res call({
 EReceiptPhotoStatus status, String? receiptId, String? imagePath
});




}
/// @nodoc
class _$ReceiptPhotoStateCopyWithImpl<$Res>
    implements $ReceiptPhotoStateCopyWith<$Res> {
  _$ReceiptPhotoStateCopyWithImpl(this._self, this._then);

  final ReceiptPhotoState _self;
  final $Res Function(ReceiptPhotoState) _then;

/// Create a copy of ReceiptPhotoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? receiptId = freezed,Object? imagePath = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EReceiptPhotoStatus,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptPhotoState].
extension ReceiptPhotoStatePatterns on ReceiptPhotoState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptPhotoState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptPhotoState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptPhotoState value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptPhotoState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptPhotoState value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptPhotoState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EReceiptPhotoStatus status,  String? receiptId,  String? imagePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptPhotoState() when $default != null:
return $default(_that.status,_that.receiptId,_that.imagePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EReceiptPhotoStatus status,  String? receiptId,  String? imagePath)  $default,) {final _that = this;
switch (_that) {
case _ReceiptPhotoState():
return $default(_that.status,_that.receiptId,_that.imagePath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EReceiptPhotoStatus status,  String? receiptId,  String? imagePath)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptPhotoState() when $default != null:
return $default(_that.status,_that.receiptId,_that.imagePath);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptPhotoState implements ReceiptPhotoState {
  const _ReceiptPhotoState({this.status = EReceiptPhotoStatus.initial, this.receiptId, this.imagePath});
  

@override@JsonKey() final  EReceiptPhotoStatus status;
@override final  String? receiptId;
/// The FILENAME stored on `Receipt.imagePath`, never a full path — the
/// Documents directory it lives under is resolved at render time
/// because it changes across iOS reinstalls.
@override final  String? imagePath;

/// Create a copy of ReceiptPhotoState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptPhotoStateCopyWith<_ReceiptPhotoState> get copyWith => __$ReceiptPhotoStateCopyWithImpl<_ReceiptPhotoState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptPhotoState&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}


@override
int get hashCode => Object.hash(runtimeType,status,receiptId,imagePath);

@override
String toString() {
  return 'ReceiptPhotoState(status: $status, receiptId: $receiptId, imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class _$ReceiptPhotoStateCopyWith<$Res> implements $ReceiptPhotoStateCopyWith<$Res> {
  factory _$ReceiptPhotoStateCopyWith(_ReceiptPhotoState value, $Res Function(_ReceiptPhotoState) _then) = __$ReceiptPhotoStateCopyWithImpl;
@override @useResult
$Res call({
 EReceiptPhotoStatus status, String? receiptId, String? imagePath
});




}
/// @nodoc
class __$ReceiptPhotoStateCopyWithImpl<$Res>
    implements _$ReceiptPhotoStateCopyWith<$Res> {
  __$ReceiptPhotoStateCopyWithImpl(this._self, this._then);

  final _ReceiptPhotoState _self;
  final $Res Function(_ReceiptPhotoState) _then;

/// Create a copy of ReceiptPhotoState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? receiptId = freezed,Object? imagePath = freezed,}) {
  return _then(_ReceiptPhotoState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EReceiptPhotoStatus,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
