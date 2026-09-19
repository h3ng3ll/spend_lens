// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_store_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditStoreEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditStoreEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditStoreEvent()';
}


}

/// @nodoc
class $EditStoreEventCopyWith<$Res>  {
$EditStoreEventCopyWith(EditStoreEvent _, $Res Function(EditStoreEvent) __);
}


/// Adds pattern-matching-related methods to [EditStoreEvent].
extension EditStoreEventPatterns on EditStoreEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _NameChanged value)?  nameChanged,TResult Function( _LogoPickStarted value)?  logoPickStarted,TResult Function( _LogoPickEnded value)?  logoPickEnded,TResult Function( _LogoPicked value)?  logoPicked,TResult Function( _LogoRemoved value)?  logoRemoved,TResult Function( _Save value)?  save,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _NameChanged() when nameChanged != null:
return nameChanged(_that);case _LogoPickStarted() when logoPickStarted != null:
return logoPickStarted(_that);case _LogoPickEnded() when logoPickEnded != null:
return logoPickEnded(_that);case _LogoPicked() when logoPicked != null:
return logoPicked(_that);case _LogoRemoved() when logoRemoved != null:
return logoRemoved(_that);case _Save() when save != null:
return save(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _NameChanged value)  nameChanged,required TResult Function( _LogoPickStarted value)  logoPickStarted,required TResult Function( _LogoPickEnded value)  logoPickEnded,required TResult Function( _LogoPicked value)  logoPicked,required TResult Function( _LogoRemoved value)  logoRemoved,required TResult Function( _Save value)  save,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _NameChanged():
return nameChanged(_that);case _LogoPickStarted():
return logoPickStarted(_that);case _LogoPickEnded():
return logoPickEnded(_that);case _LogoPicked():
return logoPicked(_that);case _LogoRemoved():
return logoRemoved(_that);case _Save():
return save(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _NameChanged value)?  nameChanged,TResult? Function( _LogoPickStarted value)?  logoPickStarted,TResult? Function( _LogoPickEnded value)?  logoPickEnded,TResult? Function( _LogoPicked value)?  logoPicked,TResult? Function( _LogoRemoved value)?  logoRemoved,TResult? Function( _Save value)?  save,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _NameChanged() when nameChanged != null:
return nameChanged(_that);case _LogoPickStarted() when logoPickStarted != null:
return logoPickStarted(_that);case _LogoPickEnded() when logoPickEnded != null:
return logoPickEnded(_that);case _LogoPicked() when logoPicked != null:
return logoPicked(_that);case _LogoRemoved() when logoRemoved != null:
return logoRemoved(_that);case _Save() when save != null:
return save(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String storeId)?  started,TResult Function( String value)?  nameChanged,TResult Function()?  logoPickStarted,TResult Function()?  logoPickEnded,TResult Function( String sourcePath)?  logoPicked,TResult Function()?  logoRemoved,TResult Function( String uid)?  save,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.storeId);case _NameChanged() when nameChanged != null:
return nameChanged(_that.value);case _LogoPickStarted() when logoPickStarted != null:
return logoPickStarted();case _LogoPickEnded() when logoPickEnded != null:
return logoPickEnded();case _LogoPicked() when logoPicked != null:
return logoPicked(_that.sourcePath);case _LogoRemoved() when logoRemoved != null:
return logoRemoved();case _Save() when save != null:
return save(_that.uid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String storeId)  started,required TResult Function( String value)  nameChanged,required TResult Function()  logoPickStarted,required TResult Function()  logoPickEnded,required TResult Function( String sourcePath)  logoPicked,required TResult Function()  logoRemoved,required TResult Function( String uid)  save,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.storeId);case _NameChanged():
return nameChanged(_that.value);case _LogoPickStarted():
return logoPickStarted();case _LogoPickEnded():
return logoPickEnded();case _LogoPicked():
return logoPicked(_that.sourcePath);case _LogoRemoved():
return logoRemoved();case _Save():
return save(_that.uid);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String storeId)?  started,TResult? Function( String value)?  nameChanged,TResult? Function()?  logoPickStarted,TResult? Function()?  logoPickEnded,TResult? Function( String sourcePath)?  logoPicked,TResult? Function()?  logoRemoved,TResult? Function( String uid)?  save,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.storeId);case _NameChanged() when nameChanged != null:
return nameChanged(_that.value);case _LogoPickStarted() when logoPickStarted != null:
return logoPickStarted();case _LogoPickEnded() when logoPickEnded != null:
return logoPickEnded();case _LogoPicked() when logoPicked != null:
return logoPicked(_that.sourcePath);case _LogoRemoved() when logoRemoved != null:
return logoRemoved();case _Save() when save != null:
return save(_that.uid);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements EditStoreEvent {
  const _Started(this.storeId);
  

 final  String storeId;

/// Create a copy of EditStoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedCopyWith<_Started> get copyWith => __$StartedCopyWithImpl<_Started>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started&&(identical(other.storeId, storeId) || other.storeId == storeId));
}


@override
int get hashCode => Object.hash(runtimeType,storeId);

@override
String toString() {
  return 'EditStoreEvent.started(storeId: $storeId)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $EditStoreEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 String storeId
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of EditStoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeId = null,}) {
  return _then(_Started(
null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _NameChanged implements EditStoreEvent {
  const _NameChanged(this.value);
  

 final  String value;

/// Create a copy of EditStoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NameChangedCopyWith<_NameChanged> get copyWith => __$NameChangedCopyWithImpl<_NameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NameChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'EditStoreEvent.nameChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class _$NameChangedCopyWith<$Res> implements $EditStoreEventCopyWith<$Res> {
  factory _$NameChangedCopyWith(_NameChanged value, $Res Function(_NameChanged) _then) = __$NameChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class __$NameChangedCopyWithImpl<$Res>
    implements _$NameChangedCopyWith<$Res> {
  __$NameChangedCopyWithImpl(this._self, this._then);

  final _NameChanged _self;
  final $Res Function(_NameChanged) _then;

/// Create a copy of EditStoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_NameChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LogoPickStarted implements EditStoreEvent {
  const _LogoPickStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogoPickStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditStoreEvent.logoPickStarted()';
}


}




/// @nodoc


class _LogoPickEnded implements EditStoreEvent {
  const _LogoPickEnded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogoPickEnded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditStoreEvent.logoPickEnded()';
}


}




/// @nodoc


class _LogoPicked implements EditStoreEvent {
  const _LogoPicked(this.sourcePath);
  

 final  String sourcePath;

/// Create a copy of EditStoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogoPickedCopyWith<_LogoPicked> get copyWith => __$LogoPickedCopyWithImpl<_LogoPicked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogoPicked&&(identical(other.sourcePath, sourcePath) || other.sourcePath == sourcePath));
}


@override
int get hashCode => Object.hash(runtimeType,sourcePath);

@override
String toString() {
  return 'EditStoreEvent.logoPicked(sourcePath: $sourcePath)';
}


}

/// @nodoc
abstract mixin class _$LogoPickedCopyWith<$Res> implements $EditStoreEventCopyWith<$Res> {
  factory _$LogoPickedCopyWith(_LogoPicked value, $Res Function(_LogoPicked) _then) = __$LogoPickedCopyWithImpl;
@useResult
$Res call({
 String sourcePath
});




}
/// @nodoc
class __$LogoPickedCopyWithImpl<$Res>
    implements _$LogoPickedCopyWith<$Res> {
  __$LogoPickedCopyWithImpl(this._self, this._then);

  final _LogoPicked _self;
  final $Res Function(_LogoPicked) _then;

/// Create a copy of EditStoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sourcePath = null,}) {
  return _then(_LogoPicked(
null == sourcePath ? _self.sourcePath : sourcePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LogoRemoved implements EditStoreEvent {
  const _LogoRemoved();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogoRemoved);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditStoreEvent.logoRemoved()';
}


}




/// @nodoc


class _Save implements EditStoreEvent {
  const _Save({this.uid = ''});
  

@JsonKey() final  String uid;

/// Create a copy of EditStoreEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveCopyWith<_Save> get copyWith => __$SaveCopyWithImpl<_Save>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Save&&(identical(other.uid, uid) || other.uid == uid));
}


@override
int get hashCode => Object.hash(runtimeType,uid);

@override
String toString() {
  return 'EditStoreEvent.save(uid: $uid)';
}


}

/// @nodoc
abstract mixin class _$SaveCopyWith<$Res> implements $EditStoreEventCopyWith<$Res> {
  factory _$SaveCopyWith(_Save value, $Res Function(_Save) _then) = __$SaveCopyWithImpl;
@useResult
$Res call({
 String uid
});




}
/// @nodoc
class __$SaveCopyWithImpl<$Res>
    implements _$SaveCopyWith<$Res> {
  __$SaveCopyWithImpl(this._self, this._then);

  final _Save _self;
  final $Res Function(_Save) _then;

/// Create a copy of EditStoreEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uid = null,}) {
  return _then(_Save(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$EditStoreState {

 EEditStoreStatus get status;/// The record as loaded, carrying `id`/`type`/`receiptAliases`/`logoUrl`.
/// The editable fields are held separately below so the form can be
/// compared against this to detect real changes.
///
/// Null until `_Started` resolves it. Nullable rather than defaulted to a
/// placeholder because `Store.updatedAt` is a required `DateTime`, which
/// cannot exist in a `const` default — and a non-const default would be a
/// fake record the save path could mistake for a real one.
 Store? get store; String get name;/// FILENAME of what the logo currently LOOKS like on screen — the stored
/// image, the staged pick, or empty after a staged removal.
///
/// Never the bytes. A `Uint8List` here would put `DeepCollectionEquality`
/// in the generated `==`/`hashCode` on a state that re-emits every
/// keystroke, and the raw bytes in `toString()`. See `AvatarImageStore`
/// for the two defects that combination already caused in this app.
 String get logoFilename;/// Whether [logoFilename] points at a newly picked image awaiting Save.
///
/// Distinct from the filename so Save knows whether there is anything to
/// UPLOAD, rather than re-uploading the unchanged stored image every time.
 bool get hasPickedLogo;/// Staged removal, applied on Save — never committed on tap.
 bool get logoRemoved;/// Whether an image is being fetched from the OS picker and read into
/// memory.
///
/// Covers the gap between the source sheet closing and the picked bytes
/// arriving: the picker itself, plus the staging copy of a multi-megabyte
/// photo. Without it the logo sits unchanged with no feedback for
/// seconds, which reads as a tap that did nothing.
 bool get isPickingLogo;/// Whether the save is currently in its UPLOAD phase.
///
/// Separate from [status] so the progress indicator can sit on the logo
/// itself. Uploading an image is the slow, network-bound part and the one
/// worth reporting; writing a name is instant and local.
 bool get isUploadingLogo;
/// Create a copy of EditStoreState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditStoreStateCopyWith<EditStoreState> get copyWith => _$EditStoreStateCopyWithImpl<EditStoreState>(this as EditStoreState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditStoreState&&(identical(other.status, status) || other.status == status)&&(identical(other.store, store) || other.store == store)&&(identical(other.name, name) || other.name == name)&&(identical(other.logoFilename, logoFilename) || other.logoFilename == logoFilename)&&(identical(other.hasPickedLogo, hasPickedLogo) || other.hasPickedLogo == hasPickedLogo)&&(identical(other.logoRemoved, logoRemoved) || other.logoRemoved == logoRemoved)&&(identical(other.isPickingLogo, isPickingLogo) || other.isPickingLogo == isPickingLogo)&&(identical(other.isUploadingLogo, isUploadingLogo) || other.isUploadingLogo == isUploadingLogo));
}


@override
int get hashCode => Object.hash(runtimeType,status,store,name,logoFilename,hasPickedLogo,logoRemoved,isPickingLogo,isUploadingLogo);

@override
String toString() {
  return 'EditStoreState(status: $status, store: $store, name: $name, logoFilename: $logoFilename, hasPickedLogo: $hasPickedLogo, logoRemoved: $logoRemoved, isPickingLogo: $isPickingLogo, isUploadingLogo: $isUploadingLogo)';
}


}

/// @nodoc
abstract mixin class $EditStoreStateCopyWith<$Res>  {
  factory $EditStoreStateCopyWith(EditStoreState value, $Res Function(EditStoreState) _then) = _$EditStoreStateCopyWithImpl;
@useResult
$Res call({
 EEditStoreStatus status, Store? store, String name, String logoFilename, bool hasPickedLogo, bool logoRemoved, bool isPickingLogo, bool isUploadingLogo
});


$StoreCopyWith<$Res>? get store;

}
/// @nodoc
class _$EditStoreStateCopyWithImpl<$Res>
    implements $EditStoreStateCopyWith<$Res> {
  _$EditStoreStateCopyWithImpl(this._self, this._then);

  final EditStoreState _self;
  final $Res Function(EditStoreState) _then;

/// Create a copy of EditStoreState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? store = freezed,Object? name = null,Object? logoFilename = null,Object? hasPickedLogo = null,Object? logoRemoved = null,Object? isPickingLogo = null,Object? isUploadingLogo = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EEditStoreStatus,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as Store?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logoFilename: null == logoFilename ? _self.logoFilename : logoFilename // ignore: cast_nullable_to_non_nullable
as String,hasPickedLogo: null == hasPickedLogo ? _self.hasPickedLogo : hasPickedLogo // ignore: cast_nullable_to_non_nullable
as bool,logoRemoved: null == logoRemoved ? _self.logoRemoved : logoRemoved // ignore: cast_nullable_to_non_nullable
as bool,isPickingLogo: null == isPickingLogo ? _self.isPickingLogo : isPickingLogo // ignore: cast_nullable_to_non_nullable
as bool,isUploadingLogo: null == isUploadingLogo ? _self.isUploadingLogo : isUploadingLogo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of EditStoreState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreCopyWith<$Res>? get store {
    if (_self.store == null) {
    return null;
  }

  return $StoreCopyWith<$Res>(_self.store!, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditStoreState].
extension EditStoreStatePatterns on EditStoreState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditStoreState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditStoreState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditStoreState value)  $default,){
final _that = this;
switch (_that) {
case _EditStoreState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditStoreState value)?  $default,){
final _that = this;
switch (_that) {
case _EditStoreState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EEditStoreStatus status,  Store? store,  String name,  String logoFilename,  bool hasPickedLogo,  bool logoRemoved,  bool isPickingLogo,  bool isUploadingLogo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditStoreState() when $default != null:
return $default(_that.status,_that.store,_that.name,_that.logoFilename,_that.hasPickedLogo,_that.logoRemoved,_that.isPickingLogo,_that.isUploadingLogo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EEditStoreStatus status,  Store? store,  String name,  String logoFilename,  bool hasPickedLogo,  bool logoRemoved,  bool isPickingLogo,  bool isUploadingLogo)  $default,) {final _that = this;
switch (_that) {
case _EditStoreState():
return $default(_that.status,_that.store,_that.name,_that.logoFilename,_that.hasPickedLogo,_that.logoRemoved,_that.isPickingLogo,_that.isUploadingLogo);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EEditStoreStatus status,  Store? store,  String name,  String logoFilename,  bool hasPickedLogo,  bool logoRemoved,  bool isPickingLogo,  bool isUploadingLogo)?  $default,) {final _that = this;
switch (_that) {
case _EditStoreState() when $default != null:
return $default(_that.status,_that.store,_that.name,_that.logoFilename,_that.hasPickedLogo,_that.logoRemoved,_that.isPickingLogo,_that.isUploadingLogo);case _:
  return null;

}
}

}

/// @nodoc


class _EditStoreState implements EditStoreState {
  const _EditStoreState({this.status = EEditStoreStatus.loading, this.store, this.name = '', this.logoFilename = '', this.hasPickedLogo = false, this.logoRemoved = false, this.isPickingLogo = false, this.isUploadingLogo = false});
  

@override@JsonKey() final  EEditStoreStatus status;
/// The record as loaded, carrying `id`/`type`/`receiptAliases`/`logoUrl`.
/// The editable fields are held separately below so the form can be
/// compared against this to detect real changes.
///
/// Null until `_Started` resolves it. Nullable rather than defaulted to a
/// placeholder because `Store.updatedAt` is a required `DateTime`, which
/// cannot exist in a `const` default — and a non-const default would be a
/// fake record the save path could mistake for a real one.
@override final  Store? store;
@override@JsonKey() final  String name;
/// FILENAME of what the logo currently LOOKS like on screen — the stored
/// image, the staged pick, or empty after a staged removal.
///
/// Never the bytes. A `Uint8List` here would put `DeepCollectionEquality`
/// in the generated `==`/`hashCode` on a state that re-emits every
/// keystroke, and the raw bytes in `toString()`. See `AvatarImageStore`
/// for the two defects that combination already caused in this app.
@override@JsonKey() final  String logoFilename;
/// Whether [logoFilename] points at a newly picked image awaiting Save.
///
/// Distinct from the filename so Save knows whether there is anything to
/// UPLOAD, rather than re-uploading the unchanged stored image every time.
@override@JsonKey() final  bool hasPickedLogo;
/// Staged removal, applied on Save — never committed on tap.
@override@JsonKey() final  bool logoRemoved;
/// Whether an image is being fetched from the OS picker and read into
/// memory.
///
/// Covers the gap between the source sheet closing and the picked bytes
/// arriving: the picker itself, plus the staging copy of a multi-megabyte
/// photo. Without it the logo sits unchanged with no feedback for
/// seconds, which reads as a tap that did nothing.
@override@JsonKey() final  bool isPickingLogo;
/// Whether the save is currently in its UPLOAD phase.
///
/// Separate from [status] so the progress indicator can sit on the logo
/// itself. Uploading an image is the slow, network-bound part and the one
/// worth reporting; writing a name is instant and local.
@override@JsonKey() final  bool isUploadingLogo;

/// Create a copy of EditStoreState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditStoreStateCopyWith<_EditStoreState> get copyWith => __$EditStoreStateCopyWithImpl<_EditStoreState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditStoreState&&(identical(other.status, status) || other.status == status)&&(identical(other.store, store) || other.store == store)&&(identical(other.name, name) || other.name == name)&&(identical(other.logoFilename, logoFilename) || other.logoFilename == logoFilename)&&(identical(other.hasPickedLogo, hasPickedLogo) || other.hasPickedLogo == hasPickedLogo)&&(identical(other.logoRemoved, logoRemoved) || other.logoRemoved == logoRemoved)&&(identical(other.isPickingLogo, isPickingLogo) || other.isPickingLogo == isPickingLogo)&&(identical(other.isUploadingLogo, isUploadingLogo) || other.isUploadingLogo == isUploadingLogo));
}


@override
int get hashCode => Object.hash(runtimeType,status,store,name,logoFilename,hasPickedLogo,logoRemoved,isPickingLogo,isUploadingLogo);

@override
String toString() {
  return 'EditStoreState(status: $status, store: $store, name: $name, logoFilename: $logoFilename, hasPickedLogo: $hasPickedLogo, logoRemoved: $logoRemoved, isPickingLogo: $isPickingLogo, isUploadingLogo: $isUploadingLogo)';
}


}

/// @nodoc
abstract mixin class _$EditStoreStateCopyWith<$Res> implements $EditStoreStateCopyWith<$Res> {
  factory _$EditStoreStateCopyWith(_EditStoreState value, $Res Function(_EditStoreState) _then) = __$EditStoreStateCopyWithImpl;
@override @useResult
$Res call({
 EEditStoreStatus status, Store? store, String name, String logoFilename, bool hasPickedLogo, bool logoRemoved, bool isPickingLogo, bool isUploadingLogo
});


@override $StoreCopyWith<$Res>? get store;

}
/// @nodoc
class __$EditStoreStateCopyWithImpl<$Res>
    implements _$EditStoreStateCopyWith<$Res> {
  __$EditStoreStateCopyWithImpl(this._self, this._then);

  final _EditStoreState _self;
  final $Res Function(_EditStoreState) _then;

/// Create a copy of EditStoreState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? store = freezed,Object? name = null,Object? logoFilename = null,Object? hasPickedLogo = null,Object? logoRemoved = null,Object? isPickingLogo = null,Object? isUploadingLogo = null,}) {
  return _then(_EditStoreState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EEditStoreStatus,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as Store?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logoFilename: null == logoFilename ? _self.logoFilename : logoFilename // ignore: cast_nullable_to_non_nullable
as String,hasPickedLogo: null == hasPickedLogo ? _self.hasPickedLogo : hasPickedLogo // ignore: cast_nullable_to_non_nullable
as bool,logoRemoved: null == logoRemoved ? _self.logoRemoved : logoRemoved // ignore: cast_nullable_to_non_nullable
as bool,isPickingLogo: null == isPickingLogo ? _self.isPickingLogo : isPickingLogo // ignore: cast_nullable_to_non_nullable
as bool,isUploadingLogo: null == isUploadingLogo ? _self.isUploadingLogo : isUploadingLogo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of EditStoreState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreCopyWith<$Res>? get store {
    if (_self.store == null) {
    return null;
  }

  return $StoreCopyWith<$Res>(_self.store!, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}

// dart format on
