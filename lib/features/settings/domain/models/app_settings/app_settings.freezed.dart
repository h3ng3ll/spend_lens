// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettings {

/// `null` = follow the device locale. Never defaulted to a concrete
/// language code.
 String? get localeCode;/// ISO 4217 currency code used for totals/analytics display. Receipts
/// keep their own printed currency regardless of this setting
/// (design_spendlens.md §4 "no conversion" resolution) — this is
/// display-only.
 String get currencyCode; EAppThemeMode get themeMode;/// Whether the user has completed onboarding (M10). Read by the
/// splash → onboarding/home redirect once the router lands (M5).
 bool get onboardingCompleted;/// The scanner's persisted camera-flash preference (M7).
 EFlashMode get flashMode;/// design_spendlens.md §7 — set `true` by "Delete all records"; the
/// seed guard checks `isEmpty && !dataCleared` so a deliberately
/// emptied app never silently repopulates. Any restore path sets this
/// back to `false`.
 bool get dataCleared;/// Pull cursor: the newest `updatedAt` this device has already pulled,
/// as an ISO-8601 string. Null until the first sync.
///
/// Field index 6, APPENDED (the doc comment above: this file only ever
/// grows trailing fields). Sync STATE, not synced data — `AppSettings`
/// itself is deliberately excluded from record sync, since locale, theme
/// and flash mode are per-device preferences.
///
/// A String rather than a DateTime so it is compared exactly as
/// Firestore stores and orders `updatedAt`, with no parse/format round
/// trip that could drift the boundary and skip a record.
 String? get lastSyncedAt;/// Whether this device has run the one-time unfiltered pull that
/// recovers documents written without an `updatedAt` field.
///
/// Field index 7, APPENDED (see the doc comment above — trailing only).
///
/// Those documents predate `updatedAt` being stamped on every save.
/// Firestore EXCLUDES a document missing the field from any query that
/// orders or filters on it, silently and without error, so an
/// incremental pull (`where('updatedAt' > cursor)`) can never see them:
/// they were stranded on the server permanently, invisible to every
/// device, and no ordinary sync would ever ask for them again.
///
/// A one-shot unfiltered fetch repairs that. Flagged rather than
/// repeated because it reads every collection whole — acceptable once
/// per install, wasteful every cycle.
 bool get legacyPullCompleted;/// Whether the one-shot per-store product split has run on this device.
///
/// Products gained an owning `storeId`, but every product created before
/// that stayed null — "general purpose" — and nothing in the UI could
/// assign one. Such a product is listed under EVERY store it was ever
/// bought at and shows every store's prices on one page, which is not
/// what a per-store product model means.
///
/// `SplitLegacyProductsUseCase` repairs that once: a legacy product whose
/// prices span N stores becomes N products, one per store. Flagged rather
/// than repeated because it reads and rewrites whole collections —
/// acceptable once per install, wasteful every launch. The use case is
/// idempotent regardless (it skips products that already own a store), so
/// this flag is an optimisation, not the correctness guarantee.
 bool get productsSplitCompleted;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.localeCode, localeCode) || other.localeCode == localeCode)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.flashMode, flashMode) || other.flashMode == flashMode)&&(identical(other.dataCleared, dataCleared) || other.dataCleared == dataCleared)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt)&&(identical(other.legacyPullCompleted, legacyPullCompleted) || other.legacyPullCompleted == legacyPullCompleted)&&(identical(other.productsSplitCompleted, productsSplitCompleted) || other.productsSplitCompleted == productsSplitCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,localeCode,currencyCode,themeMode,onboardingCompleted,flashMode,dataCleared,lastSyncedAt,legacyPullCompleted,productsSplitCompleted);

@override
String toString() {
  return 'AppSettings(localeCode: $localeCode, currencyCode: $currencyCode, themeMode: $themeMode, onboardingCompleted: $onboardingCompleted, flashMode: $flashMode, dataCleared: $dataCleared, lastSyncedAt: $lastSyncedAt, legacyPullCompleted: $legacyPullCompleted, productsSplitCompleted: $productsSplitCompleted)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 String? localeCode, String currencyCode, EAppThemeMode themeMode, bool onboardingCompleted, EFlashMode flashMode, bool dataCleared, String? lastSyncedAt, bool legacyPullCompleted, bool productsSplitCompleted
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? localeCode = freezed,Object? currencyCode = null,Object? themeMode = null,Object? onboardingCompleted = null,Object? flashMode = null,Object? dataCleared = null,Object? lastSyncedAt = freezed,Object? legacyPullCompleted = null,Object? productsSplitCompleted = null,}) {
  return _then(_self.copyWith(
localeCode: freezed == localeCode ? _self.localeCode : localeCode // ignore: cast_nullable_to_non_nullable
as String?,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as EAppThemeMode,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,flashMode: null == flashMode ? _self.flashMode : flashMode // ignore: cast_nullable_to_non_nullable
as EFlashMode,dataCleared: null == dataCleared ? _self.dataCleared : dataCleared // ignore: cast_nullable_to_non_nullable
as bool,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as String?,legacyPullCompleted: null == legacyPullCompleted ? _self.legacyPullCompleted : legacyPullCompleted // ignore: cast_nullable_to_non_nullable
as bool,productsSplitCompleted: null == productsSplitCompleted ? _self.productsSplitCompleted : productsSplitCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? localeCode,  String currencyCode,  EAppThemeMode themeMode,  bool onboardingCompleted,  EFlashMode flashMode,  bool dataCleared,  String? lastSyncedAt,  bool legacyPullCompleted,  bool productsSplitCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.localeCode,_that.currencyCode,_that.themeMode,_that.onboardingCompleted,_that.flashMode,_that.dataCleared,_that.lastSyncedAt,_that.legacyPullCompleted,_that.productsSplitCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? localeCode,  String currencyCode,  EAppThemeMode themeMode,  bool onboardingCompleted,  EFlashMode flashMode,  bool dataCleared,  String? lastSyncedAt,  bool legacyPullCompleted,  bool productsSplitCompleted)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.localeCode,_that.currencyCode,_that.themeMode,_that.onboardingCompleted,_that.flashMode,_that.dataCleared,_that.lastSyncedAt,_that.legacyPullCompleted,_that.productsSplitCompleted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? localeCode,  String currencyCode,  EAppThemeMode themeMode,  bool onboardingCompleted,  EFlashMode flashMode,  bool dataCleared,  String? lastSyncedAt,  bool legacyPullCompleted,  bool productsSplitCompleted)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.localeCode,_that.currencyCode,_that.themeMode,_that.onboardingCompleted,_that.flashMode,_that.dataCleared,_that.lastSyncedAt,_that.legacyPullCompleted,_that.productsSplitCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettings implements AppSettings {
  const _AppSettings({this.localeCode, this.currencyCode = 'MDL', this.themeMode = EAppThemeMode.system, this.onboardingCompleted = false, this.flashMode = EFlashMode.auto, this.dataCleared = false, this.lastSyncedAt, this.legacyPullCompleted = false, this.productsSplitCompleted = false});
  factory _AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

/// `null` = follow the device locale. Never defaulted to a concrete
/// language code.
@override final  String? localeCode;
/// ISO 4217 currency code used for totals/analytics display. Receipts
/// keep their own printed currency regardless of this setting
/// (design_spendlens.md §4 "no conversion" resolution) — this is
/// display-only.
@override@JsonKey() final  String currencyCode;
@override@JsonKey() final  EAppThemeMode themeMode;
/// Whether the user has completed onboarding (M10). Read by the
/// splash → onboarding/home redirect once the router lands (M5).
@override@JsonKey() final  bool onboardingCompleted;
/// The scanner's persisted camera-flash preference (M7).
@override@JsonKey() final  EFlashMode flashMode;
/// design_spendlens.md §7 — set `true` by "Delete all records"; the
/// seed guard checks `isEmpty && !dataCleared` so a deliberately
/// emptied app never silently repopulates. Any restore path sets this
/// back to `false`.
@override@JsonKey() final  bool dataCleared;
/// Pull cursor: the newest `updatedAt` this device has already pulled,
/// as an ISO-8601 string. Null until the first sync.
///
/// Field index 6, APPENDED (the doc comment above: this file only ever
/// grows trailing fields). Sync STATE, not synced data — `AppSettings`
/// itself is deliberately excluded from record sync, since locale, theme
/// and flash mode are per-device preferences.
///
/// A String rather than a DateTime so it is compared exactly as
/// Firestore stores and orders `updatedAt`, with no parse/format round
/// trip that could drift the boundary and skip a record.
@override final  String? lastSyncedAt;
/// Whether this device has run the one-time unfiltered pull that
/// recovers documents written without an `updatedAt` field.
///
/// Field index 7, APPENDED (see the doc comment above — trailing only).
///
/// Those documents predate `updatedAt` being stamped on every save.
/// Firestore EXCLUDES a document missing the field from any query that
/// orders or filters on it, silently and without error, so an
/// incremental pull (`where('updatedAt' > cursor)`) can never see them:
/// they were stranded on the server permanently, invisible to every
/// device, and no ordinary sync would ever ask for them again.
///
/// A one-shot unfiltered fetch repairs that. Flagged rather than
/// repeated because it reads every collection whole — acceptable once
/// per install, wasteful every cycle.
@override@JsonKey() final  bool legacyPullCompleted;
/// Whether the one-shot per-store product split has run on this device.
///
/// Products gained an owning `storeId`, but every product created before
/// that stayed null — "general purpose" — and nothing in the UI could
/// assign one. Such a product is listed under EVERY store it was ever
/// bought at and shows every store's prices on one page, which is not
/// what a per-store product model means.
///
/// `SplitLegacyProductsUseCase` repairs that once: a legacy product whose
/// prices span N stores becomes N products, one per store. Flagged rather
/// than repeated because it reads and rewrites whole collections —
/// acceptable once per install, wasteful every launch. The use case is
/// idempotent regardless (it skips products that already own a store), so
/// this flag is an optimisation, not the correctness guarantee.
@override@JsonKey() final  bool productsSplitCompleted;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.localeCode, localeCode) || other.localeCode == localeCode)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.flashMode, flashMode) || other.flashMode == flashMode)&&(identical(other.dataCleared, dataCleared) || other.dataCleared == dataCleared)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt)&&(identical(other.legacyPullCompleted, legacyPullCompleted) || other.legacyPullCompleted == legacyPullCompleted)&&(identical(other.productsSplitCompleted, productsSplitCompleted) || other.productsSplitCompleted == productsSplitCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,localeCode,currencyCode,themeMode,onboardingCompleted,flashMode,dataCleared,lastSyncedAt,legacyPullCompleted,productsSplitCompleted);

@override
String toString() {
  return 'AppSettings(localeCode: $localeCode, currencyCode: $currencyCode, themeMode: $themeMode, onboardingCompleted: $onboardingCompleted, flashMode: $flashMode, dataCleared: $dataCleared, lastSyncedAt: $lastSyncedAt, legacyPullCompleted: $legacyPullCompleted, productsSplitCompleted: $productsSplitCompleted)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 String? localeCode, String currencyCode, EAppThemeMode themeMode, bool onboardingCompleted, EFlashMode flashMode, bool dataCleared, String? lastSyncedAt, bool legacyPullCompleted, bool productsSplitCompleted
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? localeCode = freezed,Object? currencyCode = null,Object? themeMode = null,Object? onboardingCompleted = null,Object? flashMode = null,Object? dataCleared = null,Object? lastSyncedAt = freezed,Object? legacyPullCompleted = null,Object? productsSplitCompleted = null,}) {
  return _then(_AppSettings(
localeCode: freezed == localeCode ? _self.localeCode : localeCode // ignore: cast_nullable_to_non_nullable
as String?,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as EAppThemeMode,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,flashMode: null == flashMode ? _self.flashMode : flashMode // ignore: cast_nullable_to_non_nullable
as EFlashMode,dataCleared: null == dataCleared ? _self.dataCleared : dataCleared // ignore: cast_nullable_to_non_nullable
as bool,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as String?,legacyPullCompleted: null == legacyPullCompleted ? _self.legacyPullCompleted : legacyPullCompleted // ignore: cast_nullable_to_non_nullable
as bool,productsSplitCompleted: null == productsSplitCompleted ? _self.productsSplitCompleted : productsSplitCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
