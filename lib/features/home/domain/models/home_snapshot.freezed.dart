// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeSnapshot {

 List<Expense> get expenses; List<Category> get categories; List<Store> get stores;
/// Create a copy of HomeSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeSnapshotCopyWith<HomeSnapshot> get copyWith => _$HomeSnapshotCopyWithImpl<HomeSnapshot>(this as HomeSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeSnapshot&&const DeepCollectionEquality().equals(other.expenses, expenses)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.stores, stores));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(expenses),const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(stores));

@override
String toString() {
  return 'HomeSnapshot(expenses: $expenses, categories: $categories, stores: $stores)';
}


}

/// @nodoc
abstract mixin class $HomeSnapshotCopyWith<$Res>  {
  factory $HomeSnapshotCopyWith(HomeSnapshot value, $Res Function(HomeSnapshot) _then) = _$HomeSnapshotCopyWithImpl;
@useResult
$Res call({
 List<Expense> expenses, List<Category> categories, List<Store> stores
});




}
/// @nodoc
class _$HomeSnapshotCopyWithImpl<$Res>
    implements $HomeSnapshotCopyWith<$Res> {
  _$HomeSnapshotCopyWithImpl(this._self, this._then);

  final HomeSnapshot _self;
  final $Res Function(HomeSnapshot) _then;

/// Create a copy of HomeSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expenses = null,Object? categories = null,Object? stores = null,}) {
  return _then(_self.copyWith(
expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,stores: null == stores ? _self.stores : stores // ignore: cast_nullable_to_non_nullable
as List<Store>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeSnapshot].
extension HomeSnapshotPatterns on HomeSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _HomeSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _HomeSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Expense> expenses,  List<Category> categories,  List<Store> stores)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeSnapshot() when $default != null:
return $default(_that.expenses,_that.categories,_that.stores);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Expense> expenses,  List<Category> categories,  List<Store> stores)  $default,) {final _that = this;
switch (_that) {
case _HomeSnapshot():
return $default(_that.expenses,_that.categories,_that.stores);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Expense> expenses,  List<Category> categories,  List<Store> stores)?  $default,) {final _that = this;
switch (_that) {
case _HomeSnapshot() when $default != null:
return $default(_that.expenses,_that.categories,_that.stores);case _:
  return null;

}
}

}

/// @nodoc


class _HomeSnapshot implements HomeSnapshot {
  const _HomeSnapshot({required final  List<Expense> expenses, required final  List<Category> categories, required final  List<Store> stores}): _expenses = expenses,_categories = categories,_stores = stores;
  

 final  List<Expense> _expenses;
@override List<Expense> get expenses {
  if (_expenses is EqualUnmodifiableListView) return _expenses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenses);
}

 final  List<Category> _categories;
@override List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<Store> _stores;
@override List<Store> get stores {
  if (_stores is EqualUnmodifiableListView) return _stores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stores);
}


/// Create a copy of HomeSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeSnapshotCopyWith<_HomeSnapshot> get copyWith => __$HomeSnapshotCopyWithImpl<_HomeSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeSnapshot&&const DeepCollectionEquality().equals(other._expenses, _expenses)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._stores, _stores));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_expenses),const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_stores));

@override
String toString() {
  return 'HomeSnapshot(expenses: $expenses, categories: $categories, stores: $stores)';
}


}

/// @nodoc
abstract mixin class _$HomeSnapshotCopyWith<$Res> implements $HomeSnapshotCopyWith<$Res> {
  factory _$HomeSnapshotCopyWith(_HomeSnapshot value, $Res Function(_HomeSnapshot) _then) = __$HomeSnapshotCopyWithImpl;
@override @useResult
$Res call({
 List<Expense> expenses, List<Category> categories, List<Store> stores
});




}
/// @nodoc
class __$HomeSnapshotCopyWithImpl<$Res>
    implements _$HomeSnapshotCopyWith<$Res> {
  __$HomeSnapshotCopyWithImpl(this._self, this._then);

  final _HomeSnapshot _self;
  final $Res Function(_HomeSnapshot) _then;

/// Create a copy of HomeSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expenses = null,Object? categories = null,Object? stores = null,}) {
  return _then(_HomeSnapshot(
expenses: null == expenses ? _self._expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,stores: null == stores ? _self._stores : stores // ignore: cast_nullable_to_non_nullable
as List<Store>,
  ));
}


}

// dart format on
