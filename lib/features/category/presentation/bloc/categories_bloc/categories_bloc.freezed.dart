// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categories_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoriesEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoriesEvent()';
}


}

/// @nodoc
class $CategoriesEventCopyWith<$Res>  {
$CategoriesEventCopyWith(CategoriesEvent _, $Res Function(CategoriesEvent) __);
}


/// Adds pattern-matching-related methods to [CategoriesEvent].
extension CategoriesEventPatterns on CategoriesEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,TResult Function( _QuickCreate value)?  quickCreate,TResult Function( _Rename value)?  rename,TResult Function( _Delete value)?  delete,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _QuickCreate() when quickCreate != null:
return quickCreate(_that);case _Rename() when rename != null:
return rename(_that);case _Delete() when delete != null:
return delete(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,required TResult Function( _QuickCreate value)  quickCreate,required TResult Function( _Rename value)  rename,required TResult Function( _Delete value)  delete,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);case _QuickCreate():
return quickCreate(_that);case _Rename():
return rename(_that);case _Delete():
return delete(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,TResult? Function( _QuickCreate value)?  quickCreate,TResult? Function( _Rename value)?  rename,TResult? Function( _Delete value)?  delete,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _QuickCreate() when quickCreate != null:
return quickCreate(_that);case _Rename() when rename != null:
return rename(_that);case _Delete() when delete != null:
return delete(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  watch,TResult Function( String name)?  quickCreate,TResult Function( Category category,  String newName)?  rename,TResult Function( String categoryId)?  delete,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _QuickCreate() when quickCreate != null:
return quickCreate(_that.name);case _Rename() when rename != null:
return rename(_that.category,_that.newName);case _Delete() when delete != null:
return delete(_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  watch,required TResult Function( String name)  quickCreate,required TResult Function( Category category,  String newName)  rename,required TResult Function( String categoryId)  delete,}) {final _that = this;
switch (_that) {
case _Watch():
return watch();case _QuickCreate():
return quickCreate(_that.name);case _Rename():
return rename(_that.category,_that.newName);case _Delete():
return delete(_that.categoryId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  watch,TResult? Function( String name)?  quickCreate,TResult? Function( Category category,  String newName)?  rename,TResult? Function( String categoryId)?  delete,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _QuickCreate() when quickCreate != null:
return quickCreate(_that.name);case _Rename() when rename != null:
return rename(_that.category,_that.newName);case _Delete() when delete != null:
return delete(_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc


class _Watch implements CategoriesEvent {
  const _Watch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoriesEvent.watch()';
}


}




/// @nodoc


class _QuickCreate implements CategoriesEvent {
  const _QuickCreate(this.name);
  

 final  String name;

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickCreateCopyWith<_QuickCreate> get copyWith => __$QuickCreateCopyWithImpl<_QuickCreate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickCreate&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CategoriesEvent.quickCreate(name: $name)';
}


}

/// @nodoc
abstract mixin class _$QuickCreateCopyWith<$Res> implements $CategoriesEventCopyWith<$Res> {
  factory _$QuickCreateCopyWith(_QuickCreate value, $Res Function(_QuickCreate) _then) = __$QuickCreateCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class __$QuickCreateCopyWithImpl<$Res>
    implements _$QuickCreateCopyWith<$Res> {
  __$QuickCreateCopyWithImpl(this._self, this._then);

  final _QuickCreate _self;
  final $Res Function(_QuickCreate) _then;

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_QuickCreate(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Rename implements CategoriesEvent {
  const _Rename(this.category, this.newName);
  

 final  Category category;
 final  String newName;

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenameCopyWith<_Rename> get copyWith => __$RenameCopyWithImpl<_Rename>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Rename&&(identical(other.category, category) || other.category == category)&&(identical(other.newName, newName) || other.newName == newName));
}


@override
int get hashCode => Object.hash(runtimeType,category,newName);

@override
String toString() {
  return 'CategoriesEvent.rename(category: $category, newName: $newName)';
}


}

/// @nodoc
abstract mixin class _$RenameCopyWith<$Res> implements $CategoriesEventCopyWith<$Res> {
  factory _$RenameCopyWith(_Rename value, $Res Function(_Rename) _then) = __$RenameCopyWithImpl;
@useResult
$Res call({
 Category category, String newName
});


$CategoryCopyWith<$Res> get category;

}
/// @nodoc
class __$RenameCopyWithImpl<$Res>
    implements _$RenameCopyWith<$Res> {
  __$RenameCopyWithImpl(this._self, this._then);

  final _Rename _self;
  final $Res Function(_Rename) _then;

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? category = null,Object? newName = null,}) {
  return _then(_Rename(
null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,null == newName ? _self.newName : newName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

/// @nodoc


class _Delete implements CategoriesEvent {
  const _Delete(this.categoryId);
  

 final  String categoryId;

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteCopyWith<_Delete> get copyWith => __$DeleteCopyWithImpl<_Delete>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Delete&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId);

@override
String toString() {
  return 'CategoriesEvent.delete(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$DeleteCopyWith<$Res> implements $CategoriesEventCopyWith<$Res> {
  factory _$DeleteCopyWith(_Delete value, $Res Function(_Delete) _then) = __$DeleteCopyWithImpl;
@useResult
$Res call({
 String categoryId
});




}
/// @nodoc
class __$DeleteCopyWithImpl<$Res>
    implements _$DeleteCopyWith<$Res> {
  __$DeleteCopyWithImpl(this._self, this._then);

  final _Delete _self;
  final $Res Function(_Delete) _then;

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = null,}) {
  return _then(_Delete(
null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$CategoriesState {

 ECategoriesStatus get status; List<Category> get categories; String get errorMessage;/// The id of the category most recently created by [CategoriesEvent.quickCreate].
/// A one-shot signal a `BlocListener` consumes to pop the picker screen
/// with the new id — never read to derive displayed state.
 String? get lastCreatedId;/// Whether the most recent write (quickCreate/rename/delete) failed.
/// A one-shot signal for an error-toast listener — never read to derive
/// displayed state.
 bool get lastWriteFailed;
/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoriesStateCopyWith<CategoriesState> get copyWith => _$CategoriesStateCopyWithImpl<CategoriesState>(this as CategoriesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastCreatedId, lastCreatedId) || other.lastCreatedId == lastCreatedId)&&(identical(other.lastWriteFailed, lastWriteFailed) || other.lastWriteFailed == lastWriteFailed));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(categories),errorMessage,lastCreatedId,lastWriteFailed);

@override
String toString() {
  return 'CategoriesState(status: $status, categories: $categories, errorMessage: $errorMessage, lastCreatedId: $lastCreatedId, lastWriteFailed: $lastWriteFailed)';
}


}

/// @nodoc
abstract mixin class $CategoriesStateCopyWith<$Res>  {
  factory $CategoriesStateCopyWith(CategoriesState value, $Res Function(CategoriesState) _then) = _$CategoriesStateCopyWithImpl;
@useResult
$Res call({
 ECategoriesStatus status, List<Category> categories, String errorMessage, String? lastCreatedId, bool lastWriteFailed
});




}
/// @nodoc
class _$CategoriesStateCopyWithImpl<$Res>
    implements $CategoriesStateCopyWith<$Res> {
  _$CategoriesStateCopyWithImpl(this._self, this._then);

  final CategoriesState _self;
  final $Res Function(CategoriesState) _then;

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? categories = null,Object? errorMessage = null,Object? lastCreatedId = freezed,Object? lastWriteFailed = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ECategoriesStatus,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,lastCreatedId: freezed == lastCreatedId ? _self.lastCreatedId : lastCreatedId // ignore: cast_nullable_to_non_nullable
as String?,lastWriteFailed: null == lastWriteFailed ? _self.lastWriteFailed : lastWriteFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoriesState].
extension CategoriesStatePatterns on CategoriesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoriesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoriesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoriesState value)  $default,){
final _that = this;
switch (_that) {
case _CategoriesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoriesState value)?  $default,){
final _that = this;
switch (_that) {
case _CategoriesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ECategoriesStatus status,  List<Category> categories,  String errorMessage,  String? lastCreatedId,  bool lastWriteFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoriesState() when $default != null:
return $default(_that.status,_that.categories,_that.errorMessage,_that.lastCreatedId,_that.lastWriteFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ECategoriesStatus status,  List<Category> categories,  String errorMessage,  String? lastCreatedId,  bool lastWriteFailed)  $default,) {final _that = this;
switch (_that) {
case _CategoriesState():
return $default(_that.status,_that.categories,_that.errorMessage,_that.lastCreatedId,_that.lastWriteFailed);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ECategoriesStatus status,  List<Category> categories,  String errorMessage,  String? lastCreatedId,  bool lastWriteFailed)?  $default,) {final _that = this;
switch (_that) {
case _CategoriesState() when $default != null:
return $default(_that.status,_that.categories,_that.errorMessage,_that.lastCreatedId,_that.lastWriteFailed);case _:
  return null;

}
}

}

/// @nodoc


class _CategoriesState implements CategoriesState {
  const _CategoriesState({this.status = ECategoriesStatus.initial, final  List<Category> categories = const <Category>[], this.errorMessage = '', this.lastCreatedId, this.lastWriteFailed = false}): _categories = categories;
  

@override@JsonKey() final  ECategoriesStatus status;
 final  List<Category> _categories;
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey() final  String errorMessage;
/// The id of the category most recently created by [CategoriesEvent.quickCreate].
/// A one-shot signal a `BlocListener` consumes to pop the picker screen
/// with the new id — never read to derive displayed state.
@override final  String? lastCreatedId;
/// Whether the most recent write (quickCreate/rename/delete) failed.
/// A one-shot signal for an error-toast listener — never read to derive
/// displayed state.
@override@JsonKey() final  bool lastWriteFailed;

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoriesStateCopyWith<_CategoriesState> get copyWith => __$CategoriesStateCopyWithImpl<_CategoriesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoriesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastCreatedId, lastCreatedId) || other.lastCreatedId == lastCreatedId)&&(identical(other.lastWriteFailed, lastWriteFailed) || other.lastWriteFailed == lastWriteFailed));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_categories),errorMessage,lastCreatedId,lastWriteFailed);

@override
String toString() {
  return 'CategoriesState(status: $status, categories: $categories, errorMessage: $errorMessage, lastCreatedId: $lastCreatedId, lastWriteFailed: $lastWriteFailed)';
}


}

/// @nodoc
abstract mixin class _$CategoriesStateCopyWith<$Res> implements $CategoriesStateCopyWith<$Res> {
  factory _$CategoriesStateCopyWith(_CategoriesState value, $Res Function(_CategoriesState) _then) = __$CategoriesStateCopyWithImpl;
@override @useResult
$Res call({
 ECategoriesStatus status, List<Category> categories, String errorMessage, String? lastCreatedId, bool lastWriteFailed
});




}
/// @nodoc
class __$CategoriesStateCopyWithImpl<$Res>
    implements _$CategoriesStateCopyWith<$Res> {
  __$CategoriesStateCopyWithImpl(this._self, this._then);

  final _CategoriesState _self;
  final $Res Function(_CategoriesState) _then;

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? categories = null,Object? errorMessage = null,Object? lastCreatedId = freezed,Object? lastWriteFailed = null,}) {
  return _then(_CategoriesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ECategoriesStatus,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,lastCreatedId: freezed == lastCreatedId ? _self.lastCreatedId : lastCreatedId // ignore: cast_nullable_to_non_nullable
as String?,lastWriteFailed: null == lastWriteFailed ? _self.lastWriteFailed : lastWriteFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
