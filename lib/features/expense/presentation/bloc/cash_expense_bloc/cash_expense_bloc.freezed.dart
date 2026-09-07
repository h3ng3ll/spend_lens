// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_expense_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CashExpenseEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashExpenseEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CashExpenseEvent()';
}


}

/// @nodoc
class $CashExpenseEventCopyWith<$Res>  {
$CashExpenseEventCopyWith(CashExpenseEvent _, $Res Function(CashExpenseEvent) __);
}


/// Adds pattern-matching-related methods to [CashExpenseEvent].
extension CashExpenseEventPatterns on CashExpenseEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _PickStore value)?  pickStore,TResult Function( _ClearStore value)?  clearStore,TResult Function( _Save value)?  save,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickStore() when pickStore != null:
return pickStore(_that);case _ClearStore() when clearStore != null:
return clearStore(_that);case _Save() when save != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _PickStore value)  pickStore,required TResult Function( _ClearStore value)  clearStore,required TResult Function( _Save value)  save,}){
final _that = this;
switch (_that) {
case _PickStore():
return pickStore(_that);case _ClearStore():
return clearStore(_that);case _Save():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _PickStore value)?  pickStore,TResult? Function( _ClearStore value)?  clearStore,TResult? Function( _Save value)?  save,}){
final _that = this;
switch (_that) {
case _PickStore() when pickStore != null:
return pickStore(_that);case _ClearStore() when clearStore != null:
return clearStore(_that);case _Save() when save != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String storeId)?  pickStore,TResult Function()?  clearStore,TResult Function( double amount,  String categoryId,  String currencyCode,  String? note)?  save,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickStore() when pickStore != null:
return pickStore(_that.storeId);case _ClearStore() when clearStore != null:
return clearStore();case _Save() when save != null:
return save(_that.amount,_that.categoryId,_that.currencyCode,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String storeId)  pickStore,required TResult Function()  clearStore,required TResult Function( double amount,  String categoryId,  String currencyCode,  String? note)  save,}) {final _that = this;
switch (_that) {
case _PickStore():
return pickStore(_that.storeId);case _ClearStore():
return clearStore();case _Save():
return save(_that.amount,_that.categoryId,_that.currencyCode,_that.note);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String storeId)?  pickStore,TResult? Function()?  clearStore,TResult? Function( double amount,  String categoryId,  String currencyCode,  String? note)?  save,}) {final _that = this;
switch (_that) {
case _PickStore() when pickStore != null:
return pickStore(_that.storeId);case _ClearStore() when clearStore != null:
return clearStore();case _Save() when save != null:
return save(_that.amount,_that.categoryId,_that.currencyCode,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _PickStore implements CashExpenseEvent {
  const _PickStore(this.storeId);
  

 final  String storeId;

/// Create a copy of CashExpenseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickStoreCopyWith<_PickStore> get copyWith => __$PickStoreCopyWithImpl<_PickStore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickStore&&(identical(other.storeId, storeId) || other.storeId == storeId));
}


@override
int get hashCode => Object.hash(runtimeType,storeId);

@override
String toString() {
  return 'CashExpenseEvent.pickStore(storeId: $storeId)';
}


}

/// @nodoc
abstract mixin class _$PickStoreCopyWith<$Res> implements $CashExpenseEventCopyWith<$Res> {
  factory _$PickStoreCopyWith(_PickStore value, $Res Function(_PickStore) _then) = __$PickStoreCopyWithImpl;
@useResult
$Res call({
 String storeId
});




}
/// @nodoc
class __$PickStoreCopyWithImpl<$Res>
    implements _$PickStoreCopyWith<$Res> {
  __$PickStoreCopyWithImpl(this._self, this._then);

  final _PickStore _self;
  final $Res Function(_PickStore) _then;

/// Create a copy of CashExpenseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeId = null,}) {
  return _then(_PickStore(
null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ClearStore implements CashExpenseEvent {
  const _ClearStore();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClearStore);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CashExpenseEvent.clearStore()';
}


}




/// @nodoc


class _Save implements CashExpenseEvent {
  const _Save({required this.amount, required this.categoryId, required this.currencyCode, this.note});
  

 final  double amount;
 final  String categoryId;
 final  String currencyCode;
 final  String? note;

/// Create a copy of CashExpenseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveCopyWith<_Save> get copyWith => __$SaveCopyWithImpl<_Save>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Save&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,amount,categoryId,currencyCode,note);

@override
String toString() {
  return 'CashExpenseEvent.save(amount: $amount, categoryId: $categoryId, currencyCode: $currencyCode, note: $note)';
}


}

/// @nodoc
abstract mixin class _$SaveCopyWith<$Res> implements $CashExpenseEventCopyWith<$Res> {
  factory _$SaveCopyWith(_Save value, $Res Function(_Save) _then) = __$SaveCopyWithImpl;
@useResult
$Res call({
 double amount, String categoryId, String currencyCode, String? note
});




}
/// @nodoc
class __$SaveCopyWithImpl<$Res>
    implements _$SaveCopyWith<$Res> {
  __$SaveCopyWithImpl(this._self, this._then);

  final _Save _self;
  final $Res Function(_Save) _then;

/// Create a copy of CashExpenseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? categoryId = null,Object? currencyCode = null,Object? note = freezed,}) {
  return _then(_Save(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$CashExpenseState {

 ECashExpenseStatus get status; String? get storeId; String? get storeName;
/// Create a copy of CashExpenseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashExpenseStateCopyWith<CashExpenseState> get copyWith => _$CashExpenseStateCopyWithImpl<CashExpenseState>(this as CashExpenseState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashExpenseState&&(identical(other.status, status) || other.status == status)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName));
}


@override
int get hashCode => Object.hash(runtimeType,status,storeId,storeName);

@override
String toString() {
  return 'CashExpenseState(status: $status, storeId: $storeId, storeName: $storeName)';
}


}

/// @nodoc
abstract mixin class $CashExpenseStateCopyWith<$Res>  {
  factory $CashExpenseStateCopyWith(CashExpenseState value, $Res Function(CashExpenseState) _then) = _$CashExpenseStateCopyWithImpl;
@useResult
$Res call({
 ECashExpenseStatus status, String? storeId, String? storeName
});




}
/// @nodoc
class _$CashExpenseStateCopyWithImpl<$Res>
    implements $CashExpenseStateCopyWith<$Res> {
  _$CashExpenseStateCopyWithImpl(this._self, this._then);

  final CashExpenseState _self;
  final $Res Function(CashExpenseState) _then;

/// Create a copy of CashExpenseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? storeId = freezed,Object? storeName = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ECashExpenseStatus,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashExpenseState].
extension CashExpenseStatePatterns on CashExpenseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashExpenseState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashExpenseState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashExpenseState value)  $default,){
final _that = this;
switch (_that) {
case _CashExpenseState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashExpenseState value)?  $default,){
final _that = this;
switch (_that) {
case _CashExpenseState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ECashExpenseStatus status,  String? storeId,  String? storeName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashExpenseState() when $default != null:
return $default(_that.status,_that.storeId,_that.storeName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ECashExpenseStatus status,  String? storeId,  String? storeName)  $default,) {final _that = this;
switch (_that) {
case _CashExpenseState():
return $default(_that.status,_that.storeId,_that.storeName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ECashExpenseStatus status,  String? storeId,  String? storeName)?  $default,) {final _that = this;
switch (_that) {
case _CashExpenseState() when $default != null:
return $default(_that.status,_that.storeId,_that.storeName);case _:
  return null;

}
}

}

/// @nodoc


class _CashExpenseState implements CashExpenseState {
  const _CashExpenseState({this.status = ECashExpenseStatus.editing, this.storeId, this.storeName});
  

@override@JsonKey() final  ECashExpenseStatus status;
@override final  String? storeId;
@override final  String? storeName;

/// Create a copy of CashExpenseState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashExpenseStateCopyWith<_CashExpenseState> get copyWith => __$CashExpenseStateCopyWithImpl<_CashExpenseState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashExpenseState&&(identical(other.status, status) || other.status == status)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName));
}


@override
int get hashCode => Object.hash(runtimeType,status,storeId,storeName);

@override
String toString() {
  return 'CashExpenseState(status: $status, storeId: $storeId, storeName: $storeName)';
}


}

/// @nodoc
abstract mixin class _$CashExpenseStateCopyWith<$Res> implements $CashExpenseStateCopyWith<$Res> {
  factory _$CashExpenseStateCopyWith(_CashExpenseState value, $Res Function(_CashExpenseState) _then) = __$CashExpenseStateCopyWithImpl;
@override @useResult
$Res call({
 ECashExpenseStatus status, String? storeId, String? storeName
});




}
/// @nodoc
class __$CashExpenseStateCopyWithImpl<$Res>
    implements _$CashExpenseStateCopyWith<$Res> {
  __$CashExpenseStateCopyWithImpl(this._self, this._then);

  final _CashExpenseState _self;
  final $Res Function(_CashExpenseState) _then;

/// Create a copy of CashExpenseState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? storeId = freezed,Object? storeName = freezed,}) {
  return _then(_CashExpenseState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ECashExpenseStatus,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
