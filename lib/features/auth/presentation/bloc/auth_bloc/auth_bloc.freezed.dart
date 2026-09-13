// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AuthEvent'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,TResult Function( _WatchProfile value)?  watchProfile,TResult Function( _WatchAvatar value)?  watchAvatar,TResult Function( _SeedProfile value)?  seedProfile,TResult Function( _SignInGoogle value)?  signInGoogle,TResult Function( _SignInApple value)?  signInApple,TResult Function( _SignOut value)?  signOut,TResult Function( _DeleteAccount value)?  deleteAccount,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _WatchProfile() when watchProfile != null:
return watchProfile(_that);case _WatchAvatar() when watchAvatar != null:
return watchAvatar(_that);case _SeedProfile() when seedProfile != null:
return seedProfile(_that);case _SignInGoogle() when signInGoogle != null:
return signInGoogle(_that);case _SignInApple() when signInApple != null:
return signInApple(_that);case _SignOut() when signOut != null:
return signOut(_that);case _DeleteAccount() when deleteAccount != null:
return deleteAccount(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,required TResult Function( _WatchProfile value)  watchProfile,required TResult Function( _WatchAvatar value)  watchAvatar,required TResult Function( _SeedProfile value)  seedProfile,required TResult Function( _SignInGoogle value)  signInGoogle,required TResult Function( _SignInApple value)  signInApple,required TResult Function( _SignOut value)  signOut,required TResult Function( _DeleteAccount value)  deleteAccount,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);case _WatchProfile():
return watchProfile(_that);case _WatchAvatar():
return watchAvatar(_that);case _SeedProfile():
return seedProfile(_that);case _SignInGoogle():
return signInGoogle(_that);case _SignInApple():
return signInApple(_that);case _SignOut():
return signOut(_that);case _DeleteAccount():
return deleteAccount(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,TResult? Function( _WatchProfile value)?  watchProfile,TResult? Function( _WatchAvatar value)?  watchAvatar,TResult? Function( _SeedProfile value)?  seedProfile,TResult? Function( _SignInGoogle value)?  signInGoogle,TResult? Function( _SignInApple value)?  signInApple,TResult? Function( _SignOut value)?  signOut,TResult? Function( _DeleteAccount value)?  deleteAccount,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _WatchProfile() when watchProfile != null:
return watchProfile(_that);case _WatchAvatar() when watchAvatar != null:
return watchAvatar(_that);case _SeedProfile() when seedProfile != null:
return seedProfile(_that);case _SignInGoogle() when signInGoogle != null:
return signInGoogle(_that);case _SignInApple() when signInApple != null:
return signInApple(_that);case _SignOut() when signOut != null:
return signOut(_that);case _DeleteAccount() when deleteAccount != null:
return deleteAccount(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  watch,TResult Function()?  watchProfile,TResult Function()?  watchAvatar,TResult Function()?  seedProfile,TResult Function()?  signInGoogle,TResult Function()?  signInApple,TResult Function()?  signOut,TResult Function( EAccountDeletionScope scope)?  deleteAccount,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _WatchProfile() when watchProfile != null:
return watchProfile();case _WatchAvatar() when watchAvatar != null:
return watchAvatar();case _SeedProfile() when seedProfile != null:
return seedProfile();case _SignInGoogle() when signInGoogle != null:
return signInGoogle();case _SignInApple() when signInApple != null:
return signInApple();case _SignOut() when signOut != null:
return signOut();case _DeleteAccount() when deleteAccount != null:
return deleteAccount(_that.scope);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  watch,required TResult Function()  watchProfile,required TResult Function()  watchAvatar,required TResult Function()  seedProfile,required TResult Function()  signInGoogle,required TResult Function()  signInApple,required TResult Function()  signOut,required TResult Function( EAccountDeletionScope scope)  deleteAccount,}) {final _that = this;
switch (_that) {
case _Watch():
return watch();case _WatchProfile():
return watchProfile();case _WatchAvatar():
return watchAvatar();case _SeedProfile():
return seedProfile();case _SignInGoogle():
return signInGoogle();case _SignInApple():
return signInApple();case _SignOut():
return signOut();case _DeleteAccount():
return deleteAccount(_that.scope);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  watch,TResult? Function()?  watchProfile,TResult? Function()?  watchAvatar,TResult? Function()?  seedProfile,TResult? Function()?  signInGoogle,TResult? Function()?  signInApple,TResult? Function()?  signOut,TResult? Function( EAccountDeletionScope scope)?  deleteAccount,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _WatchProfile() when watchProfile != null:
return watchProfile();case _WatchAvatar() when watchAvatar != null:
return watchAvatar();case _SeedProfile() when seedProfile != null:
return seedProfile();case _SignInGoogle() when signInGoogle != null:
return signInGoogle();case _SignInApple() when signInApple != null:
return signInApple();case _SignOut() when signOut != null:
return signOut();case _DeleteAccount() when deleteAccount != null:
return deleteAccount(_that.scope);case _:
  return null;

}
}

}

/// @nodoc


class _Watch with DiagnosticableTreeMixin implements AuthEvent {
  const _Watch();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AuthEvent.watch'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AuthEvent.watch()';
}


}




/// @nodoc


class _WatchProfile with DiagnosticableTreeMixin implements AuthEvent {
  const _WatchProfile();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AuthEvent.watchProfile'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchProfile);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AuthEvent.watchProfile()';
}


}




/// @nodoc


class _WatchAvatar with DiagnosticableTreeMixin implements AuthEvent {
  const _WatchAvatar();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AuthEvent.watchAvatar'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchAvatar);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AuthEvent.watchAvatar()';
}


}




/// @nodoc


class _SeedProfile with DiagnosticableTreeMixin implements AuthEvent {
  const _SeedProfile();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AuthEvent.seedProfile'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeedProfile);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AuthEvent.seedProfile()';
}


}




/// @nodoc


class _SignInGoogle with DiagnosticableTreeMixin implements AuthEvent {
  const _SignInGoogle();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AuthEvent.signInGoogle'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignInGoogle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AuthEvent.signInGoogle()';
}


}




/// @nodoc


class _SignInApple with DiagnosticableTreeMixin implements AuthEvent {
  const _SignInApple();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AuthEvent.signInApple'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignInApple);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AuthEvent.signInApple()';
}


}




/// @nodoc


class _SignOut with DiagnosticableTreeMixin implements AuthEvent {
  const _SignOut();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AuthEvent.signOut'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignOut);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AuthEvent.signOut()';
}


}




/// @nodoc


class _DeleteAccount with DiagnosticableTreeMixin implements AuthEvent {
  const _DeleteAccount(this.scope);
  

 final  EAccountDeletionScope scope;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteAccountCopyWith<_DeleteAccount> get copyWith => __$DeleteAccountCopyWithImpl<_DeleteAccount>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AuthEvent.deleteAccount'))
    ..add(DiagnosticsProperty('scope', scope));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteAccount&&(identical(other.scope, scope) || other.scope == scope));
}


@override
int get hashCode => Object.hash(runtimeType,scope);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AuthEvent.deleteAccount(scope: $scope)';
}


}

/// @nodoc
abstract mixin class _$DeleteAccountCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$DeleteAccountCopyWith(_DeleteAccount value, $Res Function(_DeleteAccount) _then) = __$DeleteAccountCopyWithImpl;
@useResult
$Res call({
 EAccountDeletionScope scope
});




}
/// @nodoc
class __$DeleteAccountCopyWithImpl<$Res>
    implements _$DeleteAccountCopyWith<$Res> {
  __$DeleteAccountCopyWithImpl(this._self, this._then);

  final _DeleteAccount _self;
  final $Res Function(_DeleteAccount) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? scope = null,}) {
  return _then(_DeleteAccount(
null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as EAccountDeletionScope,
  ));
}


}

/// @nodoc
mixin _$AuthState implements DiagnosticableTreeMixin {

 EAuthStatus get status; String get errorMessage;/// `true` when signed in via Google, `false` for Apple/anonymous. Only
/// meaningful when `status == EAuthStatus.signedIn`.
 bool get isGoogleAccount;/// The signed-in user's email, for the Profile artboard's `account`
/// row. Empty when signed out.
 String get email;/// The Firebase uid. Every remote profile call is scoped by it, and the
/// edit screen cannot save without one. Empty when signed out.
 String get uid;/// Projection of the stored [UserProfile], so the three avatar surfaces
/// and the identity line render from the auth state they ALREADY watch
/// rather than each opening a second subscription.
 String get firstName; String get lastName;/// FILENAME of the cached avatar on disk, resolved through
/// `AvatarImageStore`. Empty renders the placeholder glyph.
///
/// Never the bytes: a `Uint8List` here forces `DeepCollectionEquality`
/// into the generated `==`/`hashCode` and the raw bytes into `toString()`,
/// which is what tombstoned the app when `AppObserver` logged a
/// transition. See `AvatarImageStore`.
 String get avatarFilename;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AuthState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('errorMessage', errorMessage))..add(DiagnosticsProperty('isGoogleAccount', isGoogleAccount))..add(DiagnosticsProperty('email', email))..add(DiagnosticsProperty('uid', uid))..add(DiagnosticsProperty('firstName', firstName))..add(DiagnosticsProperty('lastName', lastName))..add(DiagnosticsProperty('avatarFilename', avatarFilename));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isGoogleAccount, isGoogleAccount) || other.isGoogleAccount == isGoogleAccount)&&(identical(other.email, email) || other.email == email)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.avatarFilename, avatarFilename) || other.avatarFilename == avatarFilename));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage,isGoogleAccount,email,uid,firstName,lastName,avatarFilename);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AuthState(status: $status, errorMessage: $errorMessage, isGoogleAccount: $isGoogleAccount, email: $email, uid: $uid, firstName: $firstName, lastName: $lastName, avatarFilename: $avatarFilename)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 EAuthStatus status, String errorMessage, bool isGoogleAccount, String email, String uid, String firstName, String lastName, String avatarFilename
});




}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? errorMessage = null,Object? isGoogleAccount = null,Object? email = null,Object? uid = null,Object? firstName = null,Object? lastName = null,Object? avatarFilename = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EAuthStatus,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,isGoogleAccount: null == isGoogleAccount ? _self.isGoogleAccount : isGoogleAccount // ignore: cast_nullable_to_non_nullable
as bool,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,avatarFilename: null == avatarFilename ? _self.avatarFilename : avatarFilename // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthState value)  $default,){
final _that = this;
switch (_that) {
case _AuthState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EAuthStatus status,  String errorMessage,  bool isGoogleAccount,  String email,  String uid,  String firstName,  String lastName,  String avatarFilename)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.status,_that.errorMessage,_that.isGoogleAccount,_that.email,_that.uid,_that.firstName,_that.lastName,_that.avatarFilename);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EAuthStatus status,  String errorMessage,  bool isGoogleAccount,  String email,  String uid,  String firstName,  String lastName,  String avatarFilename)  $default,) {final _that = this;
switch (_that) {
case _AuthState():
return $default(_that.status,_that.errorMessage,_that.isGoogleAccount,_that.email,_that.uid,_that.firstName,_that.lastName,_that.avatarFilename);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EAuthStatus status,  String errorMessage,  bool isGoogleAccount,  String email,  String uid,  String firstName,  String lastName,  String avatarFilename)?  $default,) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.status,_that.errorMessage,_that.isGoogleAccount,_that.email,_that.uid,_that.firstName,_that.lastName,_that.avatarFilename);case _:
  return null;

}
}

}

/// @nodoc


class _AuthState with DiagnosticableTreeMixin implements AuthState {
  const _AuthState({this.status = EAuthStatus.signedOut, this.errorMessage = '', this.isGoogleAccount = false, this.email = '', this.uid = '', this.firstName = '', this.lastName = '', this.avatarFilename = ''});
  

@override@JsonKey() final  EAuthStatus status;
@override@JsonKey() final  String errorMessage;
/// `true` when signed in via Google, `false` for Apple/anonymous. Only
/// meaningful when `status == EAuthStatus.signedIn`.
@override@JsonKey() final  bool isGoogleAccount;
/// The signed-in user's email, for the Profile artboard's `account`
/// row. Empty when signed out.
@override@JsonKey() final  String email;
/// The Firebase uid. Every remote profile call is scoped by it, and the
/// edit screen cannot save without one. Empty when signed out.
@override@JsonKey() final  String uid;
/// Projection of the stored [UserProfile], so the three avatar surfaces
/// and the identity line render from the auth state they ALREADY watch
/// rather than each opening a second subscription.
@override@JsonKey() final  String firstName;
@override@JsonKey() final  String lastName;
/// FILENAME of the cached avatar on disk, resolved through
/// `AvatarImageStore`. Empty renders the placeholder glyph.
///
/// Never the bytes: a `Uint8List` here forces `DeepCollectionEquality`
/// into the generated `==`/`hashCode` and the raw bytes into `toString()`,
/// which is what tombstoned the app when `AppObserver` logged a
/// transition. See `AvatarImageStore`.
@override@JsonKey() final  String avatarFilename;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStateCopyWith<_AuthState> get copyWith => __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AuthState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('errorMessage', errorMessage))..add(DiagnosticsProperty('isGoogleAccount', isGoogleAccount))..add(DiagnosticsProperty('email', email))..add(DiagnosticsProperty('uid', uid))..add(DiagnosticsProperty('firstName', firstName))..add(DiagnosticsProperty('lastName', lastName))..add(DiagnosticsProperty('avatarFilename', avatarFilename));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isGoogleAccount, isGoogleAccount) || other.isGoogleAccount == isGoogleAccount)&&(identical(other.email, email) || other.email == email)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.avatarFilename, avatarFilename) || other.avatarFilename == avatarFilename));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage,isGoogleAccount,email,uid,firstName,lastName,avatarFilename);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AuthState(status: $status, errorMessage: $errorMessage, isGoogleAccount: $isGoogleAccount, email: $email, uid: $uid, firstName: $firstName, lastName: $lastName, avatarFilename: $avatarFilename)';
}


}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(_AuthState value, $Res Function(_AuthState) _then) = __$AuthStateCopyWithImpl;
@override @useResult
$Res call({
 EAuthStatus status, String errorMessage, bool isGoogleAccount, String email, String uid, String firstName, String lastName, String avatarFilename
});




}
/// @nodoc
class __$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? errorMessage = null,Object? isGoogleAccount = null,Object? email = null,Object? uid = null,Object? firstName = null,Object? lastName = null,Object? avatarFilename = null,}) {
  return _then(_AuthState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EAuthStatus,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,isGoogleAccount: null == isGoogleAccount ? _self.isGoogleAccount : isGoogleAccount // ignore: cast_nullable_to_non_nullable
as bool,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,avatarFilename: null == avatarFilename ? _self.avatarFilename : avatarFilename // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
