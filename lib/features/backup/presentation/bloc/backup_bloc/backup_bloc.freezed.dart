// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackupEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BackupEvent()';
}


}

/// @nodoc
class $BackupEventCopyWith<$Res>  {
$BackupEventCopyWith(BackupEvent _, $Res Function(BackupEvent) __);
}


/// Adds pattern-matching-related methods to [BackupEvent].
extension BackupEventPatterns on BackupEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ExportBackup value)?  exportBackup,TResult Function( _ExportCsv value)?  exportCsv,TResult Function( _ImportFilePicked value)?  importFilePicked,TResult Function( _ConfirmImport value)?  confirmImport,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportBackup() when exportBackup != null:
return exportBackup(_that);case _ExportCsv() when exportCsv != null:
return exportCsv(_that);case _ImportFilePicked() when importFilePicked != null:
return importFilePicked(_that);case _ConfirmImport() when confirmImport != null:
return confirmImport(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ExportBackup value)  exportBackup,required TResult Function( _ExportCsv value)  exportCsv,required TResult Function( _ImportFilePicked value)  importFilePicked,required TResult Function( _ConfirmImport value)  confirmImport,}){
final _that = this;
switch (_that) {
case _ExportBackup():
return exportBackup(_that);case _ExportCsv():
return exportCsv(_that);case _ImportFilePicked():
return importFilePicked(_that);case _ConfirmImport():
return confirmImport(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ExportBackup value)?  exportBackup,TResult? Function( _ExportCsv value)?  exportCsv,TResult? Function( _ImportFilePicked value)?  importFilePicked,TResult? Function( _ConfirmImport value)?  confirmImport,}){
final _that = this;
switch (_that) {
case _ExportBackup() when exportBackup != null:
return exportBackup(_that);case _ExportCsv() when exportCsv != null:
return exportCsv(_that);case _ImportFilePicked() when importFilePicked != null:
return importFilePicked(_that);case _ConfirmImport() when confirmImport != null:
return confirmImport(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  exportBackup,TResult Function()?  exportCsv,TResult Function( String? path)?  importFilePicked,TResult Function()?  confirmImport,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportBackup() when exportBackup != null:
return exportBackup();case _ExportCsv() when exportCsv != null:
return exportCsv();case _ImportFilePicked() when importFilePicked != null:
return importFilePicked(_that.path);case _ConfirmImport() when confirmImport != null:
return confirmImport();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  exportBackup,required TResult Function()  exportCsv,required TResult Function( String? path)  importFilePicked,required TResult Function()  confirmImport,}) {final _that = this;
switch (_that) {
case _ExportBackup():
return exportBackup();case _ExportCsv():
return exportCsv();case _ImportFilePicked():
return importFilePicked(_that.path);case _ConfirmImport():
return confirmImport();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  exportBackup,TResult? Function()?  exportCsv,TResult? Function( String? path)?  importFilePicked,TResult? Function()?  confirmImport,}) {final _that = this;
switch (_that) {
case _ExportBackup() when exportBackup != null:
return exportBackup();case _ExportCsv() when exportCsv != null:
return exportCsv();case _ImportFilePicked() when importFilePicked != null:
return importFilePicked(_that.path);case _ConfirmImport() when confirmImport != null:
return confirmImport();case _:
  return null;

}
}

}

/// @nodoc


class _ExportBackup implements BackupEvent {
  const _ExportBackup();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportBackup);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BackupEvent.exportBackup()';
}


}




/// @nodoc


class _ExportCsv implements BackupEvent {
  const _ExportCsv();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportCsv);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BackupEvent.exportCsv()';
}


}




/// @nodoc


class _ImportFilePicked implements BackupEvent {
  const _ImportFilePicked(this.path);
  

 final  String? path;

/// Create a copy of BackupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportFilePickedCopyWith<_ImportFilePicked> get copyWith => __$ImportFilePickedCopyWithImpl<_ImportFilePicked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportFilePicked&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'BackupEvent.importFilePicked(path: $path)';
}


}

/// @nodoc
abstract mixin class _$ImportFilePickedCopyWith<$Res> implements $BackupEventCopyWith<$Res> {
  factory _$ImportFilePickedCopyWith(_ImportFilePicked value, $Res Function(_ImportFilePicked) _then) = __$ImportFilePickedCopyWithImpl;
@useResult
$Res call({
 String? path
});




}
/// @nodoc
class __$ImportFilePickedCopyWithImpl<$Res>
    implements _$ImportFilePickedCopyWith<$Res> {
  __$ImportFilePickedCopyWithImpl(this._self, this._then);

  final _ImportFilePicked _self;
  final $Res Function(_ImportFilePicked) _then;

/// Create a copy of BackupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = freezed,}) {
  return _then(_ImportFilePicked(
freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _ConfirmImport implements BackupEvent {
  const _ConfirmImport();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfirmImport);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BackupEvent.confirmImport()';
}


}




/// @nodoc
mixin _$BackupState {

 EBackupStatus get status; EBackupError get error; String get errorMessage;/// Populated once [EBackupStatus.exportedJson] /
/// [EBackupStatus.exportedCsv] — the file the UI hands to the share
/// sheet, and the label the toast needs.
 File? get exportedFile; String get exportedFilename; int get exportedRowCount;/// Populated once [EBackupStatus.importReady] — already validated by
/// [BackupJsonCodec.decode]; [BackupEvent.confirmImport] applies it.
 BackupBundle? get pendingImport;/// Populated once [EBackupStatus.imported] — the counts the success
/// toast reports.
 int get importedReceiptCount; int get importedExpenseCount;
/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupStateCopyWith<BackupState> get copyWith => _$BackupStateCopyWithImpl<BackupState>(this as BackupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.exportedFile, exportedFile) || other.exportedFile == exportedFile)&&(identical(other.exportedFilename, exportedFilename) || other.exportedFilename == exportedFilename)&&(identical(other.exportedRowCount, exportedRowCount) || other.exportedRowCount == exportedRowCount)&&(identical(other.pendingImport, pendingImport) || other.pendingImport == pendingImport)&&(identical(other.importedReceiptCount, importedReceiptCount) || other.importedReceiptCount == importedReceiptCount)&&(identical(other.importedExpenseCount, importedExpenseCount) || other.importedExpenseCount == importedExpenseCount));
}


@override
int get hashCode => Object.hash(runtimeType,status,error,errorMessage,exportedFile,exportedFilename,exportedRowCount,pendingImport,importedReceiptCount,importedExpenseCount);

@override
String toString() {
  return 'BackupState(status: $status, error: $error, errorMessage: $errorMessage, exportedFile: $exportedFile, exportedFilename: $exportedFilename, exportedRowCount: $exportedRowCount, pendingImport: $pendingImport, importedReceiptCount: $importedReceiptCount, importedExpenseCount: $importedExpenseCount)';
}


}

/// @nodoc
abstract mixin class $BackupStateCopyWith<$Res>  {
  factory $BackupStateCopyWith(BackupState value, $Res Function(BackupState) _then) = _$BackupStateCopyWithImpl;
@useResult
$Res call({
 EBackupStatus status, EBackupError error, String errorMessage, File? exportedFile, String exportedFilename, int exportedRowCount, BackupBundle? pendingImport, int importedReceiptCount, int importedExpenseCount
});


$BackupBundleCopyWith<$Res>? get pendingImport;

}
/// @nodoc
class _$BackupStateCopyWithImpl<$Res>
    implements $BackupStateCopyWith<$Res> {
  _$BackupStateCopyWithImpl(this._self, this._then);

  final BackupState _self;
  final $Res Function(BackupState) _then;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? error = null,Object? errorMessage = null,Object? exportedFile = freezed,Object? exportedFilename = null,Object? exportedRowCount = null,Object? pendingImport = freezed,Object? importedReceiptCount = null,Object? importedExpenseCount = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EBackupStatus,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as EBackupError,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,exportedFile: freezed == exportedFile ? _self.exportedFile : exportedFile // ignore: cast_nullable_to_non_nullable
as File?,exportedFilename: null == exportedFilename ? _self.exportedFilename : exportedFilename // ignore: cast_nullable_to_non_nullable
as String,exportedRowCount: null == exportedRowCount ? _self.exportedRowCount : exportedRowCount // ignore: cast_nullable_to_non_nullable
as int,pendingImport: freezed == pendingImport ? _self.pendingImport : pendingImport // ignore: cast_nullable_to_non_nullable
as BackupBundle?,importedReceiptCount: null == importedReceiptCount ? _self.importedReceiptCount : importedReceiptCount // ignore: cast_nullable_to_non_nullable
as int,importedExpenseCount: null == importedExpenseCount ? _self.importedExpenseCount : importedExpenseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupBundleCopyWith<$Res>? get pendingImport {
    if (_self.pendingImport == null) {
    return null;
  }

  return $BackupBundleCopyWith<$Res>(_self.pendingImport!, (value) {
    return _then(_self.copyWith(pendingImport: value));
  });
}
}


/// Adds pattern-matching-related methods to [BackupState].
extension BackupStatePatterns on BackupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupState value)  $default,){
final _that = this;
switch (_that) {
case _BackupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupState value)?  $default,){
final _that = this;
switch (_that) {
case _BackupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EBackupStatus status,  EBackupError error,  String errorMessage,  File? exportedFile,  String exportedFilename,  int exportedRowCount,  BackupBundle? pendingImport,  int importedReceiptCount,  int importedExpenseCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupState() when $default != null:
return $default(_that.status,_that.error,_that.errorMessage,_that.exportedFile,_that.exportedFilename,_that.exportedRowCount,_that.pendingImport,_that.importedReceiptCount,_that.importedExpenseCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EBackupStatus status,  EBackupError error,  String errorMessage,  File? exportedFile,  String exportedFilename,  int exportedRowCount,  BackupBundle? pendingImport,  int importedReceiptCount,  int importedExpenseCount)  $default,) {final _that = this;
switch (_that) {
case _BackupState():
return $default(_that.status,_that.error,_that.errorMessage,_that.exportedFile,_that.exportedFilename,_that.exportedRowCount,_that.pendingImport,_that.importedReceiptCount,_that.importedExpenseCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EBackupStatus status,  EBackupError error,  String errorMessage,  File? exportedFile,  String exportedFilename,  int exportedRowCount,  BackupBundle? pendingImport,  int importedReceiptCount,  int importedExpenseCount)?  $default,) {final _that = this;
switch (_that) {
case _BackupState() when $default != null:
return $default(_that.status,_that.error,_that.errorMessage,_that.exportedFile,_that.exportedFilename,_that.exportedRowCount,_that.pendingImport,_that.importedReceiptCount,_that.importedExpenseCount);case _:
  return null;

}
}

}

/// @nodoc


class _BackupState implements BackupState {
  const _BackupState({this.status = EBackupStatus.idle, this.error = EBackupError.none, this.errorMessage = '', this.exportedFile, this.exportedFilename = '', this.exportedRowCount = 0, this.pendingImport, this.importedReceiptCount = 0, this.importedExpenseCount = 0});
  

@override@JsonKey() final  EBackupStatus status;
@override@JsonKey() final  EBackupError error;
@override@JsonKey() final  String errorMessage;
/// Populated once [EBackupStatus.exportedJson] /
/// [EBackupStatus.exportedCsv] — the file the UI hands to the share
/// sheet, and the label the toast needs.
@override final  File? exportedFile;
@override@JsonKey() final  String exportedFilename;
@override@JsonKey() final  int exportedRowCount;
/// Populated once [EBackupStatus.importReady] — already validated by
/// [BackupJsonCodec.decode]; [BackupEvent.confirmImport] applies it.
@override final  BackupBundle? pendingImport;
/// Populated once [EBackupStatus.imported] — the counts the success
/// toast reports.
@override@JsonKey() final  int importedReceiptCount;
@override@JsonKey() final  int importedExpenseCount;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupStateCopyWith<_BackupState> get copyWith => __$BackupStateCopyWithImpl<_BackupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.exportedFile, exportedFile) || other.exportedFile == exportedFile)&&(identical(other.exportedFilename, exportedFilename) || other.exportedFilename == exportedFilename)&&(identical(other.exportedRowCount, exportedRowCount) || other.exportedRowCount == exportedRowCount)&&(identical(other.pendingImport, pendingImport) || other.pendingImport == pendingImport)&&(identical(other.importedReceiptCount, importedReceiptCount) || other.importedReceiptCount == importedReceiptCount)&&(identical(other.importedExpenseCount, importedExpenseCount) || other.importedExpenseCount == importedExpenseCount));
}


@override
int get hashCode => Object.hash(runtimeType,status,error,errorMessage,exportedFile,exportedFilename,exportedRowCount,pendingImport,importedReceiptCount,importedExpenseCount);

@override
String toString() {
  return 'BackupState(status: $status, error: $error, errorMessage: $errorMessage, exportedFile: $exportedFile, exportedFilename: $exportedFilename, exportedRowCount: $exportedRowCount, pendingImport: $pendingImport, importedReceiptCount: $importedReceiptCount, importedExpenseCount: $importedExpenseCount)';
}


}

/// @nodoc
abstract mixin class _$BackupStateCopyWith<$Res> implements $BackupStateCopyWith<$Res> {
  factory _$BackupStateCopyWith(_BackupState value, $Res Function(_BackupState) _then) = __$BackupStateCopyWithImpl;
@override @useResult
$Res call({
 EBackupStatus status, EBackupError error, String errorMessage, File? exportedFile, String exportedFilename, int exportedRowCount, BackupBundle? pendingImport, int importedReceiptCount, int importedExpenseCount
});


@override $BackupBundleCopyWith<$Res>? get pendingImport;

}
/// @nodoc
class __$BackupStateCopyWithImpl<$Res>
    implements _$BackupStateCopyWith<$Res> {
  __$BackupStateCopyWithImpl(this._self, this._then);

  final _BackupState _self;
  final $Res Function(_BackupState) _then;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? error = null,Object? errorMessage = null,Object? exportedFile = freezed,Object? exportedFilename = null,Object? exportedRowCount = null,Object? pendingImport = freezed,Object? importedReceiptCount = null,Object? importedExpenseCount = null,}) {
  return _then(_BackupState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EBackupStatus,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as EBackupError,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,exportedFile: freezed == exportedFile ? _self.exportedFile : exportedFile // ignore: cast_nullable_to_non_nullable
as File?,exportedFilename: null == exportedFilename ? _self.exportedFilename : exportedFilename // ignore: cast_nullable_to_non_nullable
as String,exportedRowCount: null == exportedRowCount ? _self.exportedRowCount : exportedRowCount // ignore: cast_nullable_to_non_nullable
as int,pendingImport: freezed == pendingImport ? _self.pendingImport : pendingImport // ignore: cast_nullable_to_non_nullable
as BackupBundle?,importedReceiptCount: null == importedReceiptCount ? _self.importedReceiptCount : importedReceiptCount // ignore: cast_nullable_to_non_nullable
as int,importedExpenseCount: null == importedExpenseCount ? _self.importedExpenseCount : importedExpenseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupBundleCopyWith<$Res>? get pendingImport {
    if (_self.pendingImport == null) {
    return null;
  }

  return $BackupBundleCopyWith<$Res>(_self.pendingImport!, (value) {
    return _then(_self.copyWith(pendingImport: value));
  });
}
}

// dart format on
