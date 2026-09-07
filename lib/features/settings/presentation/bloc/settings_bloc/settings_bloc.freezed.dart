// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent()';
}


}

/// @nodoc
class $SettingsEventCopyWith<$Res>  {
$SettingsEventCopyWith(SettingsEvent _, $Res Function(SettingsEvent) __);
}


/// Adds pattern-matching-related methods to [SettingsEvent].
extension SettingsEventPatterns on SettingsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,TResult Function( _SetLocale value)?  setLocale,TResult Function( _SetCurrency value)?  setCurrency,TResult Function( _ToggleTheme value)?  toggleTheme,TResult Function( _CompleteOnboarding value)?  completeOnboarding,TResult Function( _ToggleFlashMode value)?  toggleFlashMode,TResult Function( _LoadRecordCount value)?  loadRecordCount,TResult Function( _DeleteAll value)?  deleteAll,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _SetLocale() when setLocale != null:
return setLocale(_that);case _SetCurrency() when setCurrency != null:
return setCurrency(_that);case _ToggleTheme() when toggleTheme != null:
return toggleTheme(_that);case _CompleteOnboarding() when completeOnboarding != null:
return completeOnboarding(_that);case _ToggleFlashMode() when toggleFlashMode != null:
return toggleFlashMode(_that);case _LoadRecordCount() when loadRecordCount != null:
return loadRecordCount(_that);case _DeleteAll() when deleteAll != null:
return deleteAll(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,required TResult Function( _SetLocale value)  setLocale,required TResult Function( _SetCurrency value)  setCurrency,required TResult Function( _ToggleTheme value)  toggleTheme,required TResult Function( _CompleteOnboarding value)  completeOnboarding,required TResult Function( _ToggleFlashMode value)  toggleFlashMode,required TResult Function( _LoadRecordCount value)  loadRecordCount,required TResult Function( _DeleteAll value)  deleteAll,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);case _SetLocale():
return setLocale(_that);case _SetCurrency():
return setCurrency(_that);case _ToggleTheme():
return toggleTheme(_that);case _CompleteOnboarding():
return completeOnboarding(_that);case _ToggleFlashMode():
return toggleFlashMode(_that);case _LoadRecordCount():
return loadRecordCount(_that);case _DeleteAll():
return deleteAll(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,TResult? Function( _SetLocale value)?  setLocale,TResult? Function( _SetCurrency value)?  setCurrency,TResult? Function( _ToggleTheme value)?  toggleTheme,TResult? Function( _CompleteOnboarding value)?  completeOnboarding,TResult? Function( _ToggleFlashMode value)?  toggleFlashMode,TResult? Function( _LoadRecordCount value)?  loadRecordCount,TResult? Function( _DeleteAll value)?  deleteAll,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _SetLocale() when setLocale != null:
return setLocale(_that);case _SetCurrency() when setCurrency != null:
return setCurrency(_that);case _ToggleTheme() when toggleTheme != null:
return toggleTheme(_that);case _CompleteOnboarding() when completeOnboarding != null:
return completeOnboarding(_that);case _ToggleFlashMode() when toggleFlashMode != null:
return toggleFlashMode(_that);case _LoadRecordCount() when loadRecordCount != null:
return loadRecordCount(_that);case _DeleteAll() when deleteAll != null:
return deleteAll(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  watch,TResult Function( String? code)?  setLocale,TResult Function( String code)?  setCurrency,TResult Function()?  toggleTheme,TResult Function()?  completeOnboarding,TResult Function()?  toggleFlashMode,TResult Function()?  loadRecordCount,TResult Function()?  deleteAll,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _SetLocale() when setLocale != null:
return setLocale(_that.code);case _SetCurrency() when setCurrency != null:
return setCurrency(_that.code);case _ToggleTheme() when toggleTheme != null:
return toggleTheme();case _CompleteOnboarding() when completeOnboarding != null:
return completeOnboarding();case _ToggleFlashMode() when toggleFlashMode != null:
return toggleFlashMode();case _LoadRecordCount() when loadRecordCount != null:
return loadRecordCount();case _DeleteAll() when deleteAll != null:
return deleteAll();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  watch,required TResult Function( String? code)  setLocale,required TResult Function( String code)  setCurrency,required TResult Function()  toggleTheme,required TResult Function()  completeOnboarding,required TResult Function()  toggleFlashMode,required TResult Function()  loadRecordCount,required TResult Function()  deleteAll,}) {final _that = this;
switch (_that) {
case _Watch():
return watch();case _SetLocale():
return setLocale(_that.code);case _SetCurrency():
return setCurrency(_that.code);case _ToggleTheme():
return toggleTheme();case _CompleteOnboarding():
return completeOnboarding();case _ToggleFlashMode():
return toggleFlashMode();case _LoadRecordCount():
return loadRecordCount();case _DeleteAll():
return deleteAll();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  watch,TResult? Function( String? code)?  setLocale,TResult? Function( String code)?  setCurrency,TResult? Function()?  toggleTheme,TResult? Function()?  completeOnboarding,TResult? Function()?  toggleFlashMode,TResult? Function()?  loadRecordCount,TResult? Function()?  deleteAll,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _SetLocale() when setLocale != null:
return setLocale(_that.code);case _SetCurrency() when setCurrency != null:
return setCurrency(_that.code);case _ToggleTheme() when toggleTheme != null:
return toggleTheme();case _CompleteOnboarding() when completeOnboarding != null:
return completeOnboarding();case _ToggleFlashMode() when toggleFlashMode != null:
return toggleFlashMode();case _LoadRecordCount() when loadRecordCount != null:
return loadRecordCount();case _DeleteAll() when deleteAll != null:
return deleteAll();case _:
  return null;

}
}

}

/// @nodoc


class _Watch implements SettingsEvent {
  const _Watch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent.watch()';
}


}




/// @nodoc


class _SetLocale implements SettingsEvent {
  const _SetLocale({required this.code});
  

 final  String? code;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetLocaleCopyWith<_SetLocale> get copyWith => __$SetLocaleCopyWithImpl<_SetLocale>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetLocale&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,code);

@override
String toString() {
  return 'SettingsEvent.setLocale(code: $code)';
}


}

/// @nodoc
abstract mixin class _$SetLocaleCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory _$SetLocaleCopyWith(_SetLocale value, $Res Function(_SetLocale) _then) = __$SetLocaleCopyWithImpl;
@useResult
$Res call({
 String? code
});




}
/// @nodoc
class __$SetLocaleCopyWithImpl<$Res>
    implements _$SetLocaleCopyWith<$Res> {
  __$SetLocaleCopyWithImpl(this._self, this._then);

  final _SetLocale _self;
  final $Res Function(_SetLocale) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = freezed,}) {
  return _then(_SetLocale(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _SetCurrency implements SettingsEvent {
  const _SetCurrency({required this.code});
  

 final  String code;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetCurrencyCopyWith<_SetCurrency> get copyWith => __$SetCurrencyCopyWithImpl<_SetCurrency>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetCurrency&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,code);

@override
String toString() {
  return 'SettingsEvent.setCurrency(code: $code)';
}


}

/// @nodoc
abstract mixin class _$SetCurrencyCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory _$SetCurrencyCopyWith(_SetCurrency value, $Res Function(_SetCurrency) _then) = __$SetCurrencyCopyWithImpl;
@useResult
$Res call({
 String code
});




}
/// @nodoc
class __$SetCurrencyCopyWithImpl<$Res>
    implements _$SetCurrencyCopyWith<$Res> {
  __$SetCurrencyCopyWithImpl(this._self, this._then);

  final _SetCurrency _self;
  final $Res Function(_SetCurrency) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(_SetCurrency(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ToggleTheme implements SettingsEvent {
  const _ToggleTheme();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleTheme);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent.toggleTheme()';
}


}




/// @nodoc


class _CompleteOnboarding implements SettingsEvent {
  const _CompleteOnboarding();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompleteOnboarding);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent.completeOnboarding()';
}


}




/// @nodoc


class _ToggleFlashMode implements SettingsEvent {
  const _ToggleFlashMode();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleFlashMode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent.toggleFlashMode()';
}


}




/// @nodoc


class _LoadRecordCount implements SettingsEvent {
  const _LoadRecordCount();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadRecordCount);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent.loadRecordCount()';
}


}




/// @nodoc


class _DeleteAll implements SettingsEvent {
  const _DeleteAll();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteAll);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent.deleteAll()';
}


}




/// @nodoc
mixin _$SettingsState {

 ESettingsStatus get status; AppSettings get settings; String get errorMessage;/// The current expenses+stores+categories count, for the delete-all
/// confirm dialog's `{n}` copy. `null` until `loadRecordCount` resolves.
 int? get recordCount;/// Whether the most recent `deleteAll` write failed. A one-shot signal
/// for an error-toast listener — never read to derive displayed state.
 bool get lastDeleteAllFailed;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.status, status) || other.status == status)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.recordCount, recordCount) || other.recordCount == recordCount)&&(identical(other.lastDeleteAllFailed, lastDeleteAllFailed) || other.lastDeleteAllFailed == lastDeleteAllFailed));
}


@override
int get hashCode => Object.hash(runtimeType,status,settings,errorMessage,recordCount,lastDeleteAllFailed);

@override
String toString() {
  return 'SettingsState(status: $status, settings: $settings, errorMessage: $errorMessage, recordCount: $recordCount, lastDeleteAllFailed: $lastDeleteAllFailed)';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 ESettingsStatus status, AppSettings settings, String errorMessage, int? recordCount, bool lastDeleteAllFailed
});


$AppSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? settings = null,Object? errorMessage = null,Object? recordCount = freezed,Object? lastDeleteAllFailed = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ESettingsStatus,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AppSettings,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,recordCount: freezed == recordCount ? _self.recordCount : recordCount // ignore: cast_nullable_to_non_nullable
as int?,lastDeleteAllFailed: null == lastDeleteAllFailed ? _self.lastDeleteAllFailed : lastDeleteAllFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<$Res> get settings {
  
  return $AppSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ESettingsStatus status,  AppSettings settings,  String errorMessage,  int? recordCount,  bool lastDeleteAllFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.status,_that.settings,_that.errorMessage,_that.recordCount,_that.lastDeleteAllFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ESettingsStatus status,  AppSettings settings,  String errorMessage,  int? recordCount,  bool lastDeleteAllFailed)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.status,_that.settings,_that.errorMessage,_that.recordCount,_that.lastDeleteAllFailed);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ESettingsStatus status,  AppSettings settings,  String errorMessage,  int? recordCount,  bool lastDeleteAllFailed)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.status,_that.settings,_that.errorMessage,_that.recordCount,_that.lastDeleteAllFailed);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({required this.status, required this.settings, this.errorMessage = '', this.recordCount, this.lastDeleteAllFailed = false});
  

@override final  ESettingsStatus status;
@override final  AppSettings settings;
@override@JsonKey() final  String errorMessage;
/// The current expenses+stores+categories count, for the delete-all
/// confirm dialog's `{n}` copy. `null` until `loadRecordCount` resolves.
@override final  int? recordCount;
/// Whether the most recent `deleteAll` write failed. A one-shot signal
/// for an error-toast listener — never read to derive displayed state.
@override@JsonKey() final  bool lastDeleteAllFailed;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.status, status) || other.status == status)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.recordCount, recordCount) || other.recordCount == recordCount)&&(identical(other.lastDeleteAllFailed, lastDeleteAllFailed) || other.lastDeleteAllFailed == lastDeleteAllFailed));
}


@override
int get hashCode => Object.hash(runtimeType,status,settings,errorMessage,recordCount,lastDeleteAllFailed);

@override
String toString() {
  return 'SettingsState(status: $status, settings: $settings, errorMessage: $errorMessage, recordCount: $recordCount, lastDeleteAllFailed: $lastDeleteAllFailed)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 ESettingsStatus status, AppSettings settings, String errorMessage, int? recordCount, bool lastDeleteAllFailed
});


@override $AppSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? settings = null,Object? errorMessage = null,Object? recordCount = freezed,Object? lastDeleteAllFailed = null,}) {
  return _then(_SettingsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ESettingsStatus,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AppSettings,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,recordCount: freezed == recordCount ? _self.recordCount : recordCount // ignore: cast_nullable_to_non_nullable
as int?,lastDeleteAllFailed: null == lastDeleteAllFailed ? _self.lastDeleteAllFailed : lastDeleteAllFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<$Res> get settings {
  
  return $AppSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
