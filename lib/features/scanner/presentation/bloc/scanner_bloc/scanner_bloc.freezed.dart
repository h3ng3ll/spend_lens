// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scanner_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScannerEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScannerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScannerEvent()';
}


}

/// @nodoc
class $ScannerEventCopyWith<$Res>  {
$ScannerEventCopyWith(ScannerEvent _, $Res Function(ScannerEvent) __);
}


/// Adds pattern-matching-related methods to [ScannerEvent].
extension ScannerEventPatterns on ScannerEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Reset value)?  reset,TResult Function( _Detected value)?  detected,TResult Function( _Capture value)?  capture,TResult Function( _CaptureCompleted value)?  captureCompleted,TResult Function( _ProcessingStepCompleted value)?  processingStepCompleted,TResult Function( _Failed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reset() when reset != null:
return reset(_that);case _Detected() when detected != null:
return detected(_that);case _Capture() when capture != null:
return capture(_that);case _CaptureCompleted() when captureCompleted != null:
return captureCompleted(_that);case _ProcessingStepCompleted() when processingStepCompleted != null:
return processingStepCompleted(_that);case _Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Reset value)  reset,required TResult Function( _Detected value)  detected,required TResult Function( _Capture value)  capture,required TResult Function( _CaptureCompleted value)  captureCompleted,required TResult Function( _ProcessingStepCompleted value)  processingStepCompleted,required TResult Function( _Failed value)  failed,}){
final _that = this;
switch (_that) {
case _Reset():
return reset(_that);case _Detected():
return detected(_that);case _Capture():
return capture(_that);case _CaptureCompleted():
return captureCompleted(_that);case _ProcessingStepCompleted():
return processingStepCompleted(_that);case _Failed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Reset value)?  reset,TResult? Function( _Detected value)?  detected,TResult? Function( _Capture value)?  capture,TResult? Function( _CaptureCompleted value)?  captureCompleted,TResult? Function( _ProcessingStepCompleted value)?  processingStepCompleted,TResult? Function( _Failed value)?  failed,}){
final _that = this;
switch (_that) {
case _Reset() when reset != null:
return reset(_that);case _Detected() when detected != null:
return detected(_that);case _Capture() when capture != null:
return capture(_that);case _CaptureCompleted() when captureCompleted != null:
return captureCompleted(_that);case _ProcessingStepCompleted() when processingStepCompleted != null:
return processingStepCompleted(_that);case _Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  reset,TResult Function( Rect bounds)?  detected,TResult Function()?  capture,TResult Function( Uint8List imageBytes)?  captureCompleted,TResult Function()?  processingStepCompleted,TResult Function( String reason)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reset() when reset != null:
return reset();case _Detected() when detected != null:
return detected(_that.bounds);case _Capture() when capture != null:
return capture();case _CaptureCompleted() when captureCompleted != null:
return captureCompleted(_that.imageBytes);case _ProcessingStepCompleted() when processingStepCompleted != null:
return processingStepCompleted();case _Failed() when failed != null:
return failed(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  reset,required TResult Function( Rect bounds)  detected,required TResult Function()  capture,required TResult Function( Uint8List imageBytes)  captureCompleted,required TResult Function()  processingStepCompleted,required TResult Function( String reason)  failed,}) {final _that = this;
switch (_that) {
case _Reset():
return reset();case _Detected():
return detected(_that.bounds);case _Capture():
return capture();case _CaptureCompleted():
return captureCompleted(_that.imageBytes);case _ProcessingStepCompleted():
return processingStepCompleted();case _Failed():
return failed(_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  reset,TResult? Function( Rect bounds)?  detected,TResult? Function()?  capture,TResult? Function( Uint8List imageBytes)?  captureCompleted,TResult? Function()?  processingStepCompleted,TResult? Function( String reason)?  failed,}) {final _that = this;
switch (_that) {
case _Reset() when reset != null:
return reset();case _Detected() when detected != null:
return detected(_that.bounds);case _Capture() when capture != null:
return capture();case _CaptureCompleted() when captureCompleted != null:
return captureCompleted(_that.imageBytes);case _ProcessingStepCompleted() when processingStepCompleted != null:
return processingStepCompleted();case _Failed() when failed != null:
return failed(_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _Reset implements ScannerEvent {
  const _Reset();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScannerEvent.reset()';
}


}




/// @nodoc


class _Detected implements ScannerEvent {
  const _Detected(this.bounds);
  

 final  Rect bounds;

/// Create a copy of ScannerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetectedCopyWith<_Detected> get copyWith => __$DetectedCopyWithImpl<_Detected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Detected&&(identical(other.bounds, bounds) || other.bounds == bounds));
}


@override
int get hashCode => Object.hash(runtimeType,bounds);

@override
String toString() {
  return 'ScannerEvent.detected(bounds: $bounds)';
}


}

/// @nodoc
abstract mixin class _$DetectedCopyWith<$Res> implements $ScannerEventCopyWith<$Res> {
  factory _$DetectedCopyWith(_Detected value, $Res Function(_Detected) _then) = __$DetectedCopyWithImpl;
@useResult
$Res call({
 Rect bounds
});




}
/// @nodoc
class __$DetectedCopyWithImpl<$Res>
    implements _$DetectedCopyWith<$Res> {
  __$DetectedCopyWithImpl(this._self, this._then);

  final _Detected _self;
  final $Res Function(_Detected) _then;

/// Create a copy of ScannerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bounds = null,}) {
  return _then(_Detected(
null == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as Rect,
  ));
}


}

/// @nodoc


class _Capture implements ScannerEvent {
  const _Capture();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Capture);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScannerEvent.capture()';
}


}




/// @nodoc


class _CaptureCompleted implements ScannerEvent {
  const _CaptureCompleted(this.imageBytes);
  

 final  Uint8List imageBytes;

/// Create a copy of ScannerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaptureCompletedCopyWith<_CaptureCompleted> get copyWith => __$CaptureCompletedCopyWithImpl<_CaptureCompleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaptureCompleted&&const DeepCollectionEquality().equals(other.imageBytes, imageBytes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(imageBytes));

@override
String toString() {
  return 'ScannerEvent.captureCompleted(imageBytes: $imageBytes)';
}


}

/// @nodoc
abstract mixin class _$CaptureCompletedCopyWith<$Res> implements $ScannerEventCopyWith<$Res> {
  factory _$CaptureCompletedCopyWith(_CaptureCompleted value, $Res Function(_CaptureCompleted) _then) = __$CaptureCompletedCopyWithImpl;
@useResult
$Res call({
 Uint8List imageBytes
});




}
/// @nodoc
class __$CaptureCompletedCopyWithImpl<$Res>
    implements _$CaptureCompletedCopyWith<$Res> {
  __$CaptureCompletedCopyWithImpl(this._self, this._then);

  final _CaptureCompleted _self;
  final $Res Function(_CaptureCompleted) _then;

/// Create a copy of ScannerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? imageBytes = null,}) {
  return _then(_CaptureCompleted(
null == imageBytes ? _self.imageBytes : imageBytes // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}


}

/// @nodoc


class _ProcessingStepCompleted implements ScannerEvent {
  const _ProcessingStepCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProcessingStepCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScannerEvent.processingStepCompleted()';
}


}




/// @nodoc


class _Failed implements ScannerEvent {
  const _Failed(this.reason);
  

 final  String reason;

/// Create a copy of ScannerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailedCopyWith<_Failed> get copyWith => __$FailedCopyWithImpl<_Failed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failed&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'ScannerEvent.failed(reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$FailedCopyWith<$Res> implements $ScannerEventCopyWith<$Res> {
  factory _$FailedCopyWith(_Failed value, $Res Function(_Failed) _then) = __$FailedCopyWithImpl;
@useResult
$Res call({
 String reason
});




}
/// @nodoc
class __$FailedCopyWithImpl<$Res>
    implements _$FailedCopyWith<$Res> {
  __$FailedCopyWithImpl(this._self, this._then);

  final _Failed _self;
  final $Res Function(_Failed) _then;

/// Create a copy of ScannerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(_Failed(
null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ScannerState {

 EScannerStatus get status;/// The detector's last real bounding box, painted as the corner overlay.
/// `null` while [status] is `searching` (nothing found yet).
 Rect? get detectedBounds;/// Which of the 4 processing steps has COMPLETED (0..4). The UI reads
/// this to render each step row as done / in-progress / pending — never
/// a fake percentage, since [design_spendlens.md §8] the four labels
/// report genuine pipeline progress.
 int get processingStep; String get errorMessage;
/// Create a copy of ScannerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScannerStateCopyWith<ScannerState> get copyWith => _$ScannerStateCopyWithImpl<ScannerState>(this as ScannerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScannerState&&(identical(other.status, status) || other.status == status)&&(identical(other.detectedBounds, detectedBounds) || other.detectedBounds == detectedBounds)&&(identical(other.processingStep, processingStep) || other.processingStep == processingStep)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,detectedBounds,processingStep,errorMessage);

@override
String toString() {
  return 'ScannerState(status: $status, detectedBounds: $detectedBounds, processingStep: $processingStep, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ScannerStateCopyWith<$Res>  {
  factory $ScannerStateCopyWith(ScannerState value, $Res Function(ScannerState) _then) = _$ScannerStateCopyWithImpl;
@useResult
$Res call({
 EScannerStatus status, Rect? detectedBounds, int processingStep, String errorMessage
});




}
/// @nodoc
class _$ScannerStateCopyWithImpl<$Res>
    implements $ScannerStateCopyWith<$Res> {
  _$ScannerStateCopyWithImpl(this._self, this._then);

  final ScannerState _self;
  final $Res Function(ScannerState) _then;

/// Create a copy of ScannerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? detectedBounds = freezed,Object? processingStep = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EScannerStatus,detectedBounds: freezed == detectedBounds ? _self.detectedBounds : detectedBounds // ignore: cast_nullable_to_non_nullable
as Rect?,processingStep: null == processingStep ? _self.processingStep : processingStep // ignore: cast_nullable_to_non_nullable
as int,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScannerState].
extension ScannerStatePatterns on ScannerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScannerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScannerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScannerState value)  $default,){
final _that = this;
switch (_that) {
case _ScannerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScannerState value)?  $default,){
final _that = this;
switch (_that) {
case _ScannerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EScannerStatus status,  Rect? detectedBounds,  int processingStep,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScannerState() when $default != null:
return $default(_that.status,_that.detectedBounds,_that.processingStep,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EScannerStatus status,  Rect? detectedBounds,  int processingStep,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ScannerState():
return $default(_that.status,_that.detectedBounds,_that.processingStep,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EScannerStatus status,  Rect? detectedBounds,  int processingStep,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ScannerState() when $default != null:
return $default(_that.status,_that.detectedBounds,_that.processingStep,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ScannerState implements ScannerState {
  const _ScannerState({this.status = EScannerStatus.searching, this.detectedBounds, this.processingStep = 0, this.errorMessage = ''});
  

@override@JsonKey() final  EScannerStatus status;
/// The detector's last real bounding box, painted as the corner overlay.
/// `null` while [status] is `searching` (nothing found yet).
@override final  Rect? detectedBounds;
/// Which of the 4 processing steps has COMPLETED (0..4). The UI reads
/// this to render each step row as done / in-progress / pending — never
/// a fake percentage, since [design_spendlens.md §8] the four labels
/// report genuine pipeline progress.
@override@JsonKey() final  int processingStep;
@override@JsonKey() final  String errorMessage;

/// Create a copy of ScannerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScannerStateCopyWith<_ScannerState> get copyWith => __$ScannerStateCopyWithImpl<_ScannerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScannerState&&(identical(other.status, status) || other.status == status)&&(identical(other.detectedBounds, detectedBounds) || other.detectedBounds == detectedBounds)&&(identical(other.processingStep, processingStep) || other.processingStep == processingStep)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,detectedBounds,processingStep,errorMessage);

@override
String toString() {
  return 'ScannerState(status: $status, detectedBounds: $detectedBounds, processingStep: $processingStep, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ScannerStateCopyWith<$Res> implements $ScannerStateCopyWith<$Res> {
  factory _$ScannerStateCopyWith(_ScannerState value, $Res Function(_ScannerState) _then) = __$ScannerStateCopyWithImpl;
@override @useResult
$Res call({
 EScannerStatus status, Rect? detectedBounds, int processingStep, String errorMessage
});




}
/// @nodoc
class __$ScannerStateCopyWithImpl<$Res>
    implements _$ScannerStateCopyWith<$Res> {
  __$ScannerStateCopyWithImpl(this._self, this._then);

  final _ScannerState _self;
  final $Res Function(_ScannerState) _then;

/// Create a copy of ScannerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? detectedBounds = freezed,Object? processingStep = null,Object? errorMessage = null,}) {
  return _then(_ScannerState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EScannerStatus,detectedBounds: freezed == detectedBounds ? _self.detectedBounds : detectedBounds // ignore: cast_nullable_to_non_nullable
as Rect?,processingStep: null == processingStep ? _self.processingStep : processingStep // ignore: cast_nullable_to_non_nullable
as int,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
