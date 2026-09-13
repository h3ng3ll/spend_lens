// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProfileEvent implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditProfileEvent()';
}


}

/// @nodoc
class $EditProfileEventCopyWith<$Res>  {
$EditProfileEventCopyWith(EditProfileEvent _, $Res Function(EditProfileEvent) __);
}


/// Adds pattern-matching-related methods to [EditProfileEvent].
extension EditProfileEventPatterns on EditProfileEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _FirstNameChanged value)?  firstNameChanged,TResult Function( _LastNameChanged value)?  lastNameChanged,TResult Function( _PhotoPickStarted value)?  photoPickStarted,TResult Function( _PhotoPickEnded value)?  photoPickEnded,TResult Function( _AvatarPicked value)?  avatarPicked,TResult Function( _AvatarRemoved value)?  avatarRemoved,TResult Function( _Save value)?  save,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _FirstNameChanged() when firstNameChanged != null:
return firstNameChanged(_that);case _LastNameChanged() when lastNameChanged != null:
return lastNameChanged(_that);case _PhotoPickStarted() when photoPickStarted != null:
return photoPickStarted(_that);case _PhotoPickEnded() when photoPickEnded != null:
return photoPickEnded(_that);case _AvatarPicked() when avatarPicked != null:
return avatarPicked(_that);case _AvatarRemoved() when avatarRemoved != null:
return avatarRemoved(_that);case _Save() when save != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _FirstNameChanged value)  firstNameChanged,required TResult Function( _LastNameChanged value)  lastNameChanged,required TResult Function( _PhotoPickStarted value)  photoPickStarted,required TResult Function( _PhotoPickEnded value)  photoPickEnded,required TResult Function( _AvatarPicked value)  avatarPicked,required TResult Function( _AvatarRemoved value)  avatarRemoved,required TResult Function( _Save value)  save,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _FirstNameChanged():
return firstNameChanged(_that);case _LastNameChanged():
return lastNameChanged(_that);case _PhotoPickStarted():
return photoPickStarted(_that);case _PhotoPickEnded():
return photoPickEnded(_that);case _AvatarPicked():
return avatarPicked(_that);case _AvatarRemoved():
return avatarRemoved(_that);case _Save():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _FirstNameChanged value)?  firstNameChanged,TResult? Function( _LastNameChanged value)?  lastNameChanged,TResult? Function( _PhotoPickStarted value)?  photoPickStarted,TResult? Function( _PhotoPickEnded value)?  photoPickEnded,TResult? Function( _AvatarPicked value)?  avatarPicked,TResult? Function( _AvatarRemoved value)?  avatarRemoved,TResult? Function( _Save value)?  save,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _FirstNameChanged() when firstNameChanged != null:
return firstNameChanged(_that);case _LastNameChanged() when lastNameChanged != null:
return lastNameChanged(_that);case _PhotoPickStarted() when photoPickStarted != null:
return photoPickStarted(_that);case _PhotoPickEnded() when photoPickEnded != null:
return photoPickEnded(_that);case _AvatarPicked() when avatarPicked != null:
return avatarPicked(_that);case _AvatarRemoved() when avatarRemoved != null:
return avatarRemoved(_that);case _Save() when save != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String uid,  String email,  String firstName,  String lastName)?  started,TResult Function( String value)?  firstNameChanged,TResult Function( String value)?  lastNameChanged,TResult Function()?  photoPickStarted,TResult Function()?  photoPickEnded,TResult Function( String sourcePath)?  avatarPicked,TResult Function()?  avatarRemoved,TResult Function()?  save,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.uid,_that.email,_that.firstName,_that.lastName);case _FirstNameChanged() when firstNameChanged != null:
return firstNameChanged(_that.value);case _LastNameChanged() when lastNameChanged != null:
return lastNameChanged(_that.value);case _PhotoPickStarted() when photoPickStarted != null:
return photoPickStarted();case _PhotoPickEnded() when photoPickEnded != null:
return photoPickEnded();case _AvatarPicked() when avatarPicked != null:
return avatarPicked(_that.sourcePath);case _AvatarRemoved() when avatarRemoved != null:
return avatarRemoved();case _Save() when save != null:
return save();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String uid,  String email,  String firstName,  String lastName)  started,required TResult Function( String value)  firstNameChanged,required TResult Function( String value)  lastNameChanged,required TResult Function()  photoPickStarted,required TResult Function()  photoPickEnded,required TResult Function( String sourcePath)  avatarPicked,required TResult Function()  avatarRemoved,required TResult Function()  save,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.uid,_that.email,_that.firstName,_that.lastName);case _FirstNameChanged():
return firstNameChanged(_that.value);case _LastNameChanged():
return lastNameChanged(_that.value);case _PhotoPickStarted():
return photoPickStarted();case _PhotoPickEnded():
return photoPickEnded();case _AvatarPicked():
return avatarPicked(_that.sourcePath);case _AvatarRemoved():
return avatarRemoved();case _Save():
return save();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String uid,  String email,  String firstName,  String lastName)?  started,TResult? Function( String value)?  firstNameChanged,TResult? Function( String value)?  lastNameChanged,TResult? Function()?  photoPickStarted,TResult? Function()?  photoPickEnded,TResult? Function( String sourcePath)?  avatarPicked,TResult? Function()?  avatarRemoved,TResult? Function()?  save,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.uid,_that.email,_that.firstName,_that.lastName);case _FirstNameChanged() when firstNameChanged != null:
return firstNameChanged(_that.value);case _LastNameChanged() when lastNameChanged != null:
return lastNameChanged(_that.value);case _PhotoPickStarted() when photoPickStarted != null:
return photoPickStarted();case _PhotoPickEnded() when photoPickEnded != null:
return photoPickEnded();case _AvatarPicked() when avatarPicked != null:
return avatarPicked(_that.sourcePath);case _AvatarRemoved() when avatarRemoved != null:
return avatarRemoved();case _Save() when save != null:
return save();case _:
  return null;

}
}

}

/// @nodoc


class _Started with DiagnosticableTreeMixin implements EditProfileEvent {
  const _Started({this.uid = '', this.email = '', this.firstName = '', this.lastName = ''});
  

@JsonKey() final  String uid;
@JsonKey() final  String email;
@JsonKey() final  String firstName;
@JsonKey() final  String lastName;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedCopyWith<_Started> get copyWith => __$StartedCopyWithImpl<_Started>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.started'))
    ..add(DiagnosticsProperty('uid', uid))..add(DiagnosticsProperty('email', email))..add(DiagnosticsProperty('firstName', firstName))..add(DiagnosticsProperty('lastName', lastName));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName));
}


@override
int get hashCode => Object.hash(runtimeType,uid,email,firstName,lastName);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditProfileEvent.started(uid: $uid, email: $email, firstName: $firstName, lastName: $lastName)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String firstName, String lastName
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? firstName = null,Object? lastName = null,}) {
  return _then(_Started(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _FirstNameChanged with DiagnosticableTreeMixin implements EditProfileEvent {
  const _FirstNameChanged(this.value);
  

 final  String value;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FirstNameChangedCopyWith<_FirstNameChanged> get copyWith => __$FirstNameChangedCopyWithImpl<_FirstNameChanged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.firstNameChanged'))
    ..add(DiagnosticsProperty('value', value));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FirstNameChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditProfileEvent.firstNameChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class _$FirstNameChangedCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory _$FirstNameChangedCopyWith(_FirstNameChanged value, $Res Function(_FirstNameChanged) _then) = __$FirstNameChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class __$FirstNameChangedCopyWithImpl<$Res>
    implements _$FirstNameChangedCopyWith<$Res> {
  __$FirstNameChangedCopyWithImpl(this._self, this._then);

  final _FirstNameChanged _self;
  final $Res Function(_FirstNameChanged) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_FirstNameChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LastNameChanged with DiagnosticableTreeMixin implements EditProfileEvent {
  const _LastNameChanged(this.value);
  

 final  String value;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LastNameChangedCopyWith<_LastNameChanged> get copyWith => __$LastNameChangedCopyWithImpl<_LastNameChanged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.lastNameChanged'))
    ..add(DiagnosticsProperty('value', value));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LastNameChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditProfileEvent.lastNameChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class _$LastNameChangedCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory _$LastNameChangedCopyWith(_LastNameChanged value, $Res Function(_LastNameChanged) _then) = __$LastNameChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class __$LastNameChangedCopyWithImpl<$Res>
    implements _$LastNameChangedCopyWith<$Res> {
  __$LastNameChangedCopyWithImpl(this._self, this._then);

  final _LastNameChanged _self;
  final $Res Function(_LastNameChanged) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_LastNameChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PhotoPickStarted with DiagnosticableTreeMixin implements EditProfileEvent {
  const _PhotoPickStarted();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.photoPickStarted'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoPickStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditProfileEvent.photoPickStarted()';
}


}




/// @nodoc


class _PhotoPickEnded with DiagnosticableTreeMixin implements EditProfileEvent {
  const _PhotoPickEnded();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.photoPickEnded'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoPickEnded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditProfileEvent.photoPickEnded()';
}


}




/// @nodoc


class _AvatarPicked with DiagnosticableTreeMixin implements EditProfileEvent {
  const _AvatarPicked(this.sourcePath);
  

 final  String sourcePath;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarPickedCopyWith<_AvatarPicked> get copyWith => __$AvatarPickedCopyWithImpl<_AvatarPicked>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.avatarPicked'))
    ..add(DiagnosticsProperty('sourcePath', sourcePath));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarPicked&&(identical(other.sourcePath, sourcePath) || other.sourcePath == sourcePath));
}


@override
int get hashCode => Object.hash(runtimeType,sourcePath);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditProfileEvent.avatarPicked(sourcePath: $sourcePath)';
}


}

/// @nodoc
abstract mixin class _$AvatarPickedCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory _$AvatarPickedCopyWith(_AvatarPicked value, $Res Function(_AvatarPicked) _then) = __$AvatarPickedCopyWithImpl;
@useResult
$Res call({
 String sourcePath
});




}
/// @nodoc
class __$AvatarPickedCopyWithImpl<$Res>
    implements _$AvatarPickedCopyWith<$Res> {
  __$AvatarPickedCopyWithImpl(this._self, this._then);

  final _AvatarPicked _self;
  final $Res Function(_AvatarPicked) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sourcePath = null,}) {
  return _then(_AvatarPicked(
null == sourcePath ? _self.sourcePath : sourcePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AvatarRemoved with DiagnosticableTreeMixin implements EditProfileEvent {
  const _AvatarRemoved();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.avatarRemoved'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarRemoved);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditProfileEvent.avatarRemoved()';
}


}




/// @nodoc


class _Save with DiagnosticableTreeMixin implements EditProfileEvent {
  const _Save();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.save'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Save);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditProfileEvent.save()';
}


}




/// @nodoc
mixin _$EditProfileState implements DiagnosticableTreeMixin {

 EEditProfileStatus get status;/// The record as loaded, carrying `uid`/`email`/`photoUrl`. The editable
/// fields are held separately below so the form can be compared against
/// this to detect real changes.
 UserProfile get profile; String get firstName; String get lastName;/// FILENAME of what the avatar currently LOOKS like on screen — the stored
/// image, the staged pick, or empty after a staged removal.
///
/// Never the bytes. A `Uint8List` here put `DeepCollectionEquality` in the
/// generated `==`/`hashCode` (~36 ms per emit on a 12 MB photo, on a state
/// that re-emits every keystroke) and the raw bytes in `toString()`
/// (~309 ms, a 57 MB string) — which `AppObserver` then built four times
/// per Save until the platform killed the process. See `AvatarImageStore`.
 String get avatarFilename;/// Whether [avatarFilename] points at a newly picked image awaiting Save.
///
/// Distinct from the filename so Save knows whether there is anything to
/// UPLOAD, rather than re-uploading the unchanged stored image every time.
 bool get hasPickedAvatar;/// Staged removal, applied on Save. Never committed on tap
/// (`edit_profile_screen_rules.md` rule 3).
 bool get avatarRemoved;/// Whether an image is being fetched from the OS picker and read into
/// memory.
///
/// Covers the gap between the source sheet closing and the picked bytes
/// arriving: the picker itself, plus `readAsBytes` on a multi-megabyte
/// photo. Without it the avatar sat unchanged with no feedback for
/// seconds, which reads as a tap that did nothing.
 bool get isPickingPhoto;/// Whether the save is currently in its PHOTO phase.
///
/// Separate from [status] so the progress label can name what is actually
/// happening. Uploading an image is the slow, network-bound part and the
/// one worth reporting; writing a name is instant and local.
 bool get isUploadingPhoto;
/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileStateCopyWith<EditProfileState> get copyWith => _$EditProfileStateCopyWithImpl<EditProfileState>(this as EditProfileState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditProfileState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('profile', profile))..add(DiagnosticsProperty('firstName', firstName))..add(DiagnosticsProperty('lastName', lastName))..add(DiagnosticsProperty('avatarFilename', avatarFilename))..add(DiagnosticsProperty('hasPickedAvatar', hasPickedAvatar))..add(DiagnosticsProperty('avatarRemoved', avatarRemoved))..add(DiagnosticsProperty('isPickingPhoto', isPickingPhoto))..add(DiagnosticsProperty('isUploadingPhoto', isUploadingPhoto));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.avatarFilename, avatarFilename) || other.avatarFilename == avatarFilename)&&(identical(other.hasPickedAvatar, hasPickedAvatar) || other.hasPickedAvatar == hasPickedAvatar)&&(identical(other.avatarRemoved, avatarRemoved) || other.avatarRemoved == avatarRemoved)&&(identical(other.isPickingPhoto, isPickingPhoto) || other.isPickingPhoto == isPickingPhoto)&&(identical(other.isUploadingPhoto, isUploadingPhoto) || other.isUploadingPhoto == isUploadingPhoto));
}


@override
int get hashCode => Object.hash(runtimeType,status,profile,firstName,lastName,avatarFilename,hasPickedAvatar,avatarRemoved,isPickingPhoto,isUploadingPhoto);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditProfileState(status: $status, profile: $profile, firstName: $firstName, lastName: $lastName, avatarFilename: $avatarFilename, hasPickedAvatar: $hasPickedAvatar, avatarRemoved: $avatarRemoved, isPickingPhoto: $isPickingPhoto, isUploadingPhoto: $isUploadingPhoto)';
}


}

/// @nodoc
abstract mixin class $EditProfileStateCopyWith<$Res>  {
  factory $EditProfileStateCopyWith(EditProfileState value, $Res Function(EditProfileState) _then) = _$EditProfileStateCopyWithImpl;
@useResult
$Res call({
 EEditProfileStatus status, UserProfile profile, String firstName, String lastName, String avatarFilename, bool hasPickedAvatar, bool avatarRemoved, bool isPickingPhoto, bool isUploadingPhoto
});


$UserProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$EditProfileStateCopyWithImpl<$Res>
    implements $EditProfileStateCopyWith<$Res> {
  _$EditProfileStateCopyWithImpl(this._self, this._then);

  final EditProfileState _self;
  final $Res Function(EditProfileState) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? profile = null,Object? firstName = null,Object? lastName = null,Object? avatarFilename = null,Object? hasPickedAvatar = null,Object? avatarRemoved = null,Object? isPickingPhoto = null,Object? isUploadingPhoto = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EEditProfileStatus,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserProfile,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,avatarFilename: null == avatarFilename ? _self.avatarFilename : avatarFilename // ignore: cast_nullable_to_non_nullable
as String,hasPickedAvatar: null == hasPickedAvatar ? _self.hasPickedAvatar : hasPickedAvatar // ignore: cast_nullable_to_non_nullable
as bool,avatarRemoved: null == avatarRemoved ? _self.avatarRemoved : avatarRemoved // ignore: cast_nullable_to_non_nullable
as bool,isPickingPhoto: null == isPickingPhoto ? _self.isPickingPhoto : isPickingPhoto // ignore: cast_nullable_to_non_nullable
as bool,isUploadingPhoto: null == isUploadingPhoto ? _self.isUploadingPhoto : isUploadingPhoto // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res> get profile {
  
  return $UserProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditProfileState].
extension EditProfileStatePatterns on EditProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditProfileState value)  $default,){
final _that = this;
switch (_that) {
case _EditProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EEditProfileStatus status,  UserProfile profile,  String firstName,  String lastName,  String avatarFilename,  bool hasPickedAvatar,  bool avatarRemoved,  bool isPickingPhoto,  bool isUploadingPhoto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
return $default(_that.status,_that.profile,_that.firstName,_that.lastName,_that.avatarFilename,_that.hasPickedAvatar,_that.avatarRemoved,_that.isPickingPhoto,_that.isUploadingPhoto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EEditProfileStatus status,  UserProfile profile,  String firstName,  String lastName,  String avatarFilename,  bool hasPickedAvatar,  bool avatarRemoved,  bool isPickingPhoto,  bool isUploadingPhoto)  $default,) {final _that = this;
switch (_that) {
case _EditProfileState():
return $default(_that.status,_that.profile,_that.firstName,_that.lastName,_that.avatarFilename,_that.hasPickedAvatar,_that.avatarRemoved,_that.isPickingPhoto,_that.isUploadingPhoto);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EEditProfileStatus status,  UserProfile profile,  String firstName,  String lastName,  String avatarFilename,  bool hasPickedAvatar,  bool avatarRemoved,  bool isPickingPhoto,  bool isUploadingPhoto)?  $default,) {final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
return $default(_that.status,_that.profile,_that.firstName,_that.lastName,_that.avatarFilename,_that.hasPickedAvatar,_that.avatarRemoved,_that.isPickingPhoto,_that.isUploadingPhoto);case _:
  return null;

}
}

}

/// @nodoc


class _EditProfileState with DiagnosticableTreeMixin implements EditProfileState {
  const _EditProfileState({this.status = EEditProfileStatus.loading, this.profile = const UserProfile(), this.firstName = '', this.lastName = '', this.avatarFilename = '', this.hasPickedAvatar = false, this.avatarRemoved = false, this.isPickingPhoto = false, this.isUploadingPhoto = false});
  

@override@JsonKey() final  EEditProfileStatus status;
/// The record as loaded, carrying `uid`/`email`/`photoUrl`. The editable
/// fields are held separately below so the form can be compared against
/// this to detect real changes.
@override@JsonKey() final  UserProfile profile;
@override@JsonKey() final  String firstName;
@override@JsonKey() final  String lastName;
/// FILENAME of what the avatar currently LOOKS like on screen — the stored
/// image, the staged pick, or empty after a staged removal.
///
/// Never the bytes. A `Uint8List` here put `DeepCollectionEquality` in the
/// generated `==`/`hashCode` (~36 ms per emit on a 12 MB photo, on a state
/// that re-emits every keystroke) and the raw bytes in `toString()`
/// (~309 ms, a 57 MB string) — which `AppObserver` then built four times
/// per Save until the platform killed the process. See `AvatarImageStore`.
@override@JsonKey() final  String avatarFilename;
/// Whether [avatarFilename] points at a newly picked image awaiting Save.
///
/// Distinct from the filename so Save knows whether there is anything to
/// UPLOAD, rather than re-uploading the unchanged stored image every time.
@override@JsonKey() final  bool hasPickedAvatar;
/// Staged removal, applied on Save. Never committed on tap
/// (`edit_profile_screen_rules.md` rule 3).
@override@JsonKey() final  bool avatarRemoved;
/// Whether an image is being fetched from the OS picker and read into
/// memory.
///
/// Covers the gap between the source sheet closing and the picked bytes
/// arriving: the picker itself, plus `readAsBytes` on a multi-megabyte
/// photo. Without it the avatar sat unchanged with no feedback for
/// seconds, which reads as a tap that did nothing.
@override@JsonKey() final  bool isPickingPhoto;
/// Whether the save is currently in its PHOTO phase.
///
/// Separate from [status] so the progress label can name what is actually
/// happening. Uploading an image is the slow, network-bound part and the
/// one worth reporting; writing a name is instant and local.
@override@JsonKey() final  bool isUploadingPhoto;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditProfileStateCopyWith<_EditProfileState> get copyWith => __$EditProfileStateCopyWithImpl<_EditProfileState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditProfileState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('profile', profile))..add(DiagnosticsProperty('firstName', firstName))..add(DiagnosticsProperty('lastName', lastName))..add(DiagnosticsProperty('avatarFilename', avatarFilename))..add(DiagnosticsProperty('hasPickedAvatar', hasPickedAvatar))..add(DiagnosticsProperty('avatarRemoved', avatarRemoved))..add(DiagnosticsProperty('isPickingPhoto', isPickingPhoto))..add(DiagnosticsProperty('isUploadingPhoto', isUploadingPhoto));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.avatarFilename, avatarFilename) || other.avatarFilename == avatarFilename)&&(identical(other.hasPickedAvatar, hasPickedAvatar) || other.hasPickedAvatar == hasPickedAvatar)&&(identical(other.avatarRemoved, avatarRemoved) || other.avatarRemoved == avatarRemoved)&&(identical(other.isPickingPhoto, isPickingPhoto) || other.isPickingPhoto == isPickingPhoto)&&(identical(other.isUploadingPhoto, isUploadingPhoto) || other.isUploadingPhoto == isUploadingPhoto));
}


@override
int get hashCode => Object.hash(runtimeType,status,profile,firstName,lastName,avatarFilename,hasPickedAvatar,avatarRemoved,isPickingPhoto,isUploadingPhoto);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditProfileState(status: $status, profile: $profile, firstName: $firstName, lastName: $lastName, avatarFilename: $avatarFilename, hasPickedAvatar: $hasPickedAvatar, avatarRemoved: $avatarRemoved, isPickingPhoto: $isPickingPhoto, isUploadingPhoto: $isUploadingPhoto)';
}


}

/// @nodoc
abstract mixin class _$EditProfileStateCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory _$EditProfileStateCopyWith(_EditProfileState value, $Res Function(_EditProfileState) _then) = __$EditProfileStateCopyWithImpl;
@override @useResult
$Res call({
 EEditProfileStatus status, UserProfile profile, String firstName, String lastName, String avatarFilename, bool hasPickedAvatar, bool avatarRemoved, bool isPickingPhoto, bool isUploadingPhoto
});


@override $UserProfileCopyWith<$Res> get profile;

}
/// @nodoc
class __$EditProfileStateCopyWithImpl<$Res>
    implements _$EditProfileStateCopyWith<$Res> {
  __$EditProfileStateCopyWithImpl(this._self, this._then);

  final _EditProfileState _self;
  final $Res Function(_EditProfileState) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? profile = null,Object? firstName = null,Object? lastName = null,Object? avatarFilename = null,Object? hasPickedAvatar = null,Object? avatarRemoved = null,Object? isPickingPhoto = null,Object? isUploadingPhoto = null,}) {
  return _then(_EditProfileState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EEditProfileStatus,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserProfile,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,avatarFilename: null == avatarFilename ? _self.avatarFilename : avatarFilename // ignore: cast_nullable_to_non_nullable
as String,hasPickedAvatar: null == hasPickedAvatar ? _self.hasPickedAvatar : hasPickedAvatar // ignore: cast_nullable_to_non_nullable
as bool,avatarRemoved: null == avatarRemoved ? _self.avatarRemoved : avatarRemoved // ignore: cast_nullable_to_non_nullable
as bool,isPickingPhoto: null == isPickingPhoto ? _self.isPickingPhoto : isPickingPhoto // ignore: cast_nullable_to_non_nullable
as bool,isUploadingPhoto: null == isUploadingPhoto ? _self.isUploadingPhoto : isUploadingPhoto // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res> get profile {
  
  return $UserProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
