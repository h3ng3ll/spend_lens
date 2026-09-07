// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_bundle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupBundle {

 int get schemaVersion; DateTime get exportedAt; List<Receipt> get receipts; List<ReceiptItem> get receiptItems; List<Product> get products; List<Store> get stores; List<Category> get categories; List<Expense> get expenses; List<PriceObservation> get priceObservations;
/// Create a copy of BackupBundle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupBundleCopyWith<BackupBundle> get copyWith => _$BackupBundleCopyWithImpl<BackupBundle>(this as BackupBundle, _$identity);

  /// Serializes this BackupBundle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupBundle&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&const DeepCollectionEquality().equals(other.receipts, receipts)&&const DeepCollectionEquality().equals(other.receiptItems, receiptItems)&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.stores, stores)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.expenses, expenses)&&const DeepCollectionEquality().equals(other.priceObservations, priceObservations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,exportedAt,const DeepCollectionEquality().hash(receipts),const DeepCollectionEquality().hash(receiptItems),const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(stores),const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(expenses),const DeepCollectionEquality().hash(priceObservations));

@override
String toString() {
  return 'BackupBundle(schemaVersion: $schemaVersion, exportedAt: $exportedAt, receipts: $receipts, receiptItems: $receiptItems, products: $products, stores: $stores, categories: $categories, expenses: $expenses, priceObservations: $priceObservations)';
}


}

/// @nodoc
abstract mixin class $BackupBundleCopyWith<$Res>  {
  factory $BackupBundleCopyWith(BackupBundle value, $Res Function(BackupBundle) _then) = _$BackupBundleCopyWithImpl;
@useResult
$Res call({
 int schemaVersion, DateTime exportedAt, List<Receipt> receipts, List<ReceiptItem> receiptItems, List<Product> products, List<Store> stores, List<Category> categories, List<Expense> expenses, List<PriceObservation> priceObservations
});




}
/// @nodoc
class _$BackupBundleCopyWithImpl<$Res>
    implements $BackupBundleCopyWith<$Res> {
  _$BackupBundleCopyWithImpl(this._self, this._then);

  final BackupBundle _self;
  final $Res Function(BackupBundle) _then;

/// Create a copy of BackupBundle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? exportedAt = null,Object? receipts = null,Object? receiptItems = null,Object? products = null,Object? stores = null,Object? categories = null,Object? expenses = null,Object? priceObservations = null,}) {
  return _then(_self.copyWith(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,receipts: null == receipts ? _self.receipts : receipts // ignore: cast_nullable_to_non_nullable
as List<Receipt>,receiptItems: null == receiptItems ? _self.receiptItems : receiptItems // ignore: cast_nullable_to_non_nullable
as List<ReceiptItem>,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,stores: null == stores ? _self.stores : stores // ignore: cast_nullable_to_non_nullable
as List<Store>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,priceObservations: null == priceObservations ? _self.priceObservations : priceObservations // ignore: cast_nullable_to_non_nullable
as List<PriceObservation>,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupBundle].
extension BackupBundlePatterns on BackupBundle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupBundle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupBundle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupBundle value)  $default,){
final _that = this;
switch (_that) {
case _BackupBundle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupBundle value)?  $default,){
final _that = this;
switch (_that) {
case _BackupBundle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int schemaVersion,  DateTime exportedAt,  List<Receipt> receipts,  List<ReceiptItem> receiptItems,  List<Product> products,  List<Store> stores,  List<Category> categories,  List<Expense> expenses,  List<PriceObservation> priceObservations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupBundle() when $default != null:
return $default(_that.schemaVersion,_that.exportedAt,_that.receipts,_that.receiptItems,_that.products,_that.stores,_that.categories,_that.expenses,_that.priceObservations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int schemaVersion,  DateTime exportedAt,  List<Receipt> receipts,  List<ReceiptItem> receiptItems,  List<Product> products,  List<Store> stores,  List<Category> categories,  List<Expense> expenses,  List<PriceObservation> priceObservations)  $default,) {final _that = this;
switch (_that) {
case _BackupBundle():
return $default(_that.schemaVersion,_that.exportedAt,_that.receipts,_that.receiptItems,_that.products,_that.stores,_that.categories,_that.expenses,_that.priceObservations);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int schemaVersion,  DateTime exportedAt,  List<Receipt> receipts,  List<ReceiptItem> receiptItems,  List<Product> products,  List<Store> stores,  List<Category> categories,  List<Expense> expenses,  List<PriceObservation> priceObservations)?  $default,) {final _that = this;
switch (_that) {
case _BackupBundle() when $default != null:
return $default(_that.schemaVersion,_that.exportedAt,_that.receipts,_that.receiptItems,_that.products,_that.stores,_that.categories,_that.expenses,_that.priceObservations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupBundle implements BackupBundle {
  const _BackupBundle({required this.schemaVersion, required this.exportedAt, final  List<Receipt> receipts = const <Receipt>[], final  List<ReceiptItem> receiptItems = const <ReceiptItem>[], final  List<Product> products = const <Product>[], final  List<Store> stores = const <Store>[], final  List<Category> categories = const <Category>[], final  List<Expense> expenses = const <Expense>[], final  List<PriceObservation> priceObservations = const <PriceObservation>[]}): _receipts = receipts,_receiptItems = receiptItems,_products = products,_stores = stores,_categories = categories,_expenses = expenses,_priceObservations = priceObservations;
  factory _BackupBundle.fromJson(Map<String, dynamic> json) => _$BackupBundleFromJson(json);

@override final  int schemaVersion;
@override final  DateTime exportedAt;
 final  List<Receipt> _receipts;
@override@JsonKey() List<Receipt> get receipts {
  if (_receipts is EqualUnmodifiableListView) return _receipts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_receipts);
}

 final  List<ReceiptItem> _receiptItems;
@override@JsonKey() List<ReceiptItem> get receiptItems {
  if (_receiptItems is EqualUnmodifiableListView) return _receiptItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_receiptItems);
}

 final  List<Product> _products;
@override@JsonKey() List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<Store> _stores;
@override@JsonKey() List<Store> get stores {
  if (_stores is EqualUnmodifiableListView) return _stores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stores);
}

 final  List<Category> _categories;
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<Expense> _expenses;
@override@JsonKey() List<Expense> get expenses {
  if (_expenses is EqualUnmodifiableListView) return _expenses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenses);
}

 final  List<PriceObservation> _priceObservations;
@override@JsonKey() List<PriceObservation> get priceObservations {
  if (_priceObservations is EqualUnmodifiableListView) return _priceObservations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_priceObservations);
}


/// Create a copy of BackupBundle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupBundleCopyWith<_BackupBundle> get copyWith => __$BackupBundleCopyWithImpl<_BackupBundle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupBundleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupBundle&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&const DeepCollectionEquality().equals(other._receipts, _receipts)&&const DeepCollectionEquality().equals(other._receiptItems, _receiptItems)&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._stores, _stores)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._expenses, _expenses)&&const DeepCollectionEquality().equals(other._priceObservations, _priceObservations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,exportedAt,const DeepCollectionEquality().hash(_receipts),const DeepCollectionEquality().hash(_receiptItems),const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_stores),const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_expenses),const DeepCollectionEquality().hash(_priceObservations));

@override
String toString() {
  return 'BackupBundle(schemaVersion: $schemaVersion, exportedAt: $exportedAt, receipts: $receipts, receiptItems: $receiptItems, products: $products, stores: $stores, categories: $categories, expenses: $expenses, priceObservations: $priceObservations)';
}


}

/// @nodoc
abstract mixin class _$BackupBundleCopyWith<$Res> implements $BackupBundleCopyWith<$Res> {
  factory _$BackupBundleCopyWith(_BackupBundle value, $Res Function(_BackupBundle) _then) = __$BackupBundleCopyWithImpl;
@override @useResult
$Res call({
 int schemaVersion, DateTime exportedAt, List<Receipt> receipts, List<ReceiptItem> receiptItems, List<Product> products, List<Store> stores, List<Category> categories, List<Expense> expenses, List<PriceObservation> priceObservations
});




}
/// @nodoc
class __$BackupBundleCopyWithImpl<$Res>
    implements _$BackupBundleCopyWith<$Res> {
  __$BackupBundleCopyWithImpl(this._self, this._then);

  final _BackupBundle _self;
  final $Res Function(_BackupBundle) _then;

/// Create a copy of BackupBundle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? exportedAt = null,Object? receipts = null,Object? receiptItems = null,Object? products = null,Object? stores = null,Object? categories = null,Object? expenses = null,Object? priceObservations = null,}) {
  return _then(_BackupBundle(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,receipts: null == receipts ? _self._receipts : receipts // ignore: cast_nullable_to_non_nullable
as List<Receipt>,receiptItems: null == receiptItems ? _self._receiptItems : receiptItems // ignore: cast_nullable_to_non_nullable
as List<ReceiptItem>,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,stores: null == stores ? _self._stores : stores // ignore: cast_nullable_to_non_nullable
as List<Store>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,expenses: null == expenses ? _self._expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,priceObservations: null == priceObservations ? _self._priceObservations : priceObservations // ignore: cast_nullable_to_non_nullable
as List<PriceObservation>,
  ));
}


}

// dart format on
