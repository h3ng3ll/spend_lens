// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id;/// Canonicalized name used for matching (lowercase, whitespace/OCR
/// cleanup, abbreviation-expanded) — never shown to the user.
 String get normalizedName;/// User-facing name.
 String get displayName;/// Alternate raw-OCR spellings that have been matched to this product.
 List<String> get aliases; String? get defaultCategoryId; EUnit get defaultUnit;/// The store this product belongs to, or null for a GENERAL-PURPOSE
/// product — one created from a scan before any store was resolved.
///
/// Per-store products are a deliberate product decision: the same goods
/// bought at two stores are two [Product] rows, so each store owns its
/// own price line. The consequence is that cross-store comparison can no
/// longer group by `productId` alone — see [linkedProductIds].
///
/// Legacy rows decode with null here, which reads correctly: a product
/// created before stores were tracked genuinely belongs to no store.
 String? get storeId;/// Products at OTHER stores the user has declared to be the same goods.
///
/// SYMMETRIC — both sides carry each other's id — and resolved into a
/// transitive group at read time by `resolveLinkedGroup`, so A-B plus
/// B-C makes A and C comparable without any group-id bookkeeping to
/// rebalance on unlink.
///
/// This is what keeps the store-detail "cheaper by" comparison alive
/// under per-store products: the comparator groups observations over the
/// linked SET rather than a single `productId`. Empty = compares against
/// nothing, which renders as "Only bought here".
 List<String> get linkedProductIds;/// FILENAME of the product's photo on disk (`product_<id>.jpg`),
/// resolved against the CURRENT Documents directory by
/// [ProductImageStore] — never a full path, which dangles across iOS
/// reinstalls, and never the bytes, which must not reach Hive or a bloc
/// state (see `AvatarImageStore` for the two defects that rule
/// prevents).
///
/// Null = no photo, which is what makes the remove affordance
/// conditional.
 String? get imageFilename;/// Firebase Storage download URL for `users/{uid}/products/{id}.jpg`.
///
/// Carried on the record so the photo travels with the product through
/// the ordinary record sync: a device that pulls this row learns a photo
/// exists, and the photo pass fetches the bytes. Empty = not uploaded
/// yet (offline, or the account is full), which is a normal state and
/// not an error.
 String get imageUrl; DateTime get updatedAt; DateTime? get deletedAt; ESyncStatus get syncStatus;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.normalizedName, normalizedName) || other.normalizedName == normalizedName)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.aliases, aliases)&&(identical(other.defaultCategoryId, defaultCategoryId) || other.defaultCategoryId == defaultCategoryId)&&(identical(other.defaultUnit, defaultUnit) || other.defaultUnit == defaultUnit)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&const DeepCollectionEquality().equals(other.linkedProductIds, linkedProductIds)&&(identical(other.imageFilename, imageFilename) || other.imageFilename == imageFilename)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,normalizedName,displayName,const DeepCollectionEquality().hash(aliases),defaultCategoryId,defaultUnit,storeId,const DeepCollectionEquality().hash(linkedProductIds),imageFilename,imageUrl,updatedAt,deletedAt,syncStatus);

@override
String toString() {
  return 'Product(id: $id, normalizedName: $normalizedName, displayName: $displayName, aliases: $aliases, defaultCategoryId: $defaultCategoryId, defaultUnit: $defaultUnit, storeId: $storeId, linkedProductIds: $linkedProductIds, imageFilename: $imageFilename, imageUrl: $imageUrl, updatedAt: $updatedAt, deletedAt: $deletedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String normalizedName, String displayName, List<String> aliases, String? defaultCategoryId, EUnit defaultUnit, String? storeId, List<String> linkedProductIds, String? imageFilename, String imageUrl, DateTime updatedAt, DateTime? deletedAt, ESyncStatus syncStatus
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? normalizedName = null,Object? displayName = null,Object? aliases = null,Object? defaultCategoryId = freezed,Object? defaultUnit = null,Object? storeId = freezed,Object? linkedProductIds = null,Object? imageFilename = freezed,Object? imageUrl = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,normalizedName: null == normalizedName ? _self.normalizedName : normalizedName // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,defaultCategoryId: freezed == defaultCategoryId ? _self.defaultCategoryId : defaultCategoryId // ignore: cast_nullable_to_non_nullable
as String?,defaultUnit: null == defaultUnit ? _self.defaultUnit : defaultUnit // ignore: cast_nullable_to_non_nullable
as EUnit,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,linkedProductIds: null == linkedProductIds ? _self.linkedProductIds : linkedProductIds // ignore: cast_nullable_to_non_nullable
as List<String>,imageFilename: freezed == imageFilename ? _self.imageFilename : imageFilename // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as ESyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String normalizedName,  String displayName,  List<String> aliases,  String? defaultCategoryId,  EUnit defaultUnit,  String? storeId,  List<String> linkedProductIds,  String? imageFilename,  String imageUrl,  DateTime updatedAt,  DateTime? deletedAt,  ESyncStatus syncStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.normalizedName,_that.displayName,_that.aliases,_that.defaultCategoryId,_that.defaultUnit,_that.storeId,_that.linkedProductIds,_that.imageFilename,_that.imageUrl,_that.updatedAt,_that.deletedAt,_that.syncStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String normalizedName,  String displayName,  List<String> aliases,  String? defaultCategoryId,  EUnit defaultUnit,  String? storeId,  List<String> linkedProductIds,  String? imageFilename,  String imageUrl,  DateTime updatedAt,  DateTime? deletedAt,  ESyncStatus syncStatus)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.normalizedName,_that.displayName,_that.aliases,_that.defaultCategoryId,_that.defaultUnit,_that.storeId,_that.linkedProductIds,_that.imageFilename,_that.imageUrl,_that.updatedAt,_that.deletedAt,_that.syncStatus);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String normalizedName,  String displayName,  List<String> aliases,  String? defaultCategoryId,  EUnit defaultUnit,  String? storeId,  List<String> linkedProductIds,  String? imageFilename,  String imageUrl,  DateTime updatedAt,  DateTime? deletedAt,  ESyncStatus syncStatus)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.normalizedName,_that.displayName,_that.aliases,_that.defaultCategoryId,_that.defaultUnit,_that.storeId,_that.linkedProductIds,_that.imageFilename,_that.imageUrl,_that.updatedAt,_that.deletedAt,_that.syncStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.normalizedName, required this.displayName, final  List<String> aliases = const <String>[], this.defaultCategoryId, this.defaultUnit = EUnit.piece, this.storeId, final  List<String> linkedProductIds = const <String>[], this.imageFilename, this.imageUrl = '', required this.updatedAt, this.deletedAt, this.syncStatus = ESyncStatus.synced}): _aliases = aliases,_linkedProductIds = linkedProductIds;
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
/// Canonicalized name used for matching (lowercase, whitespace/OCR
/// cleanup, abbreviation-expanded) — never shown to the user.
@override final  String normalizedName;
/// User-facing name.
@override final  String displayName;
/// Alternate raw-OCR spellings that have been matched to this product.
 final  List<String> _aliases;
/// Alternate raw-OCR spellings that have been matched to this product.
@override@JsonKey() List<String> get aliases {
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aliases);
}

@override final  String? defaultCategoryId;
@override@JsonKey() final  EUnit defaultUnit;
/// The store this product belongs to, or null for a GENERAL-PURPOSE
/// product — one created from a scan before any store was resolved.
///
/// Per-store products are a deliberate product decision: the same goods
/// bought at two stores are two [Product] rows, so each store owns its
/// own price line. The consequence is that cross-store comparison can no
/// longer group by `productId` alone — see [linkedProductIds].
///
/// Legacy rows decode with null here, which reads correctly: a product
/// created before stores were tracked genuinely belongs to no store.
@override final  String? storeId;
/// Products at OTHER stores the user has declared to be the same goods.
///
/// SYMMETRIC — both sides carry each other's id — and resolved into a
/// transitive group at read time by `resolveLinkedGroup`, so A-B plus
/// B-C makes A and C comparable without any group-id bookkeeping to
/// rebalance on unlink.
///
/// This is what keeps the store-detail "cheaper by" comparison alive
/// under per-store products: the comparator groups observations over the
/// linked SET rather than a single `productId`. Empty = compares against
/// nothing, which renders as "Only bought here".
 final  List<String> _linkedProductIds;
/// Products at OTHER stores the user has declared to be the same goods.
///
/// SYMMETRIC — both sides carry each other's id — and resolved into a
/// transitive group at read time by `resolveLinkedGroup`, so A-B plus
/// B-C makes A and C comparable without any group-id bookkeeping to
/// rebalance on unlink.
///
/// This is what keeps the store-detail "cheaper by" comparison alive
/// under per-store products: the comparator groups observations over the
/// linked SET rather than a single `productId`. Empty = compares against
/// nothing, which renders as "Only bought here".
@override@JsonKey() List<String> get linkedProductIds {
  if (_linkedProductIds is EqualUnmodifiableListView) return _linkedProductIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_linkedProductIds);
}

/// FILENAME of the product's photo on disk (`product_<id>.jpg`),
/// resolved against the CURRENT Documents directory by
/// [ProductImageStore] — never a full path, which dangles across iOS
/// reinstalls, and never the bytes, which must not reach Hive or a bloc
/// state (see `AvatarImageStore` for the two defects that rule
/// prevents).
///
/// Null = no photo, which is what makes the remove affordance
/// conditional.
@override final  String? imageFilename;
/// Firebase Storage download URL for `users/{uid}/products/{id}.jpg`.
///
/// Carried on the record so the photo travels with the product through
/// the ordinary record sync: a device that pulls this row learns a photo
/// exists, and the photo pass fetches the bytes. Empty = not uploaded
/// yet (offline, or the account is full), which is a normal state and
/// not an error.
@override@JsonKey() final  String imageUrl;
@override final  DateTime updatedAt;
@override final  DateTime? deletedAt;
@override@JsonKey() final  ESyncStatus syncStatus;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.normalizedName, normalizedName) || other.normalizedName == normalizedName)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other._aliases, _aliases)&&(identical(other.defaultCategoryId, defaultCategoryId) || other.defaultCategoryId == defaultCategoryId)&&(identical(other.defaultUnit, defaultUnit) || other.defaultUnit == defaultUnit)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&const DeepCollectionEquality().equals(other._linkedProductIds, _linkedProductIds)&&(identical(other.imageFilename, imageFilename) || other.imageFilename == imageFilename)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,normalizedName,displayName,const DeepCollectionEquality().hash(_aliases),defaultCategoryId,defaultUnit,storeId,const DeepCollectionEquality().hash(_linkedProductIds),imageFilename,imageUrl,updatedAt,deletedAt,syncStatus);

@override
String toString() {
  return 'Product(id: $id, normalizedName: $normalizedName, displayName: $displayName, aliases: $aliases, defaultCategoryId: $defaultCategoryId, defaultUnit: $defaultUnit, storeId: $storeId, linkedProductIds: $linkedProductIds, imageFilename: $imageFilename, imageUrl: $imageUrl, updatedAt: $updatedAt, deletedAt: $deletedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String normalizedName, String displayName, List<String> aliases, String? defaultCategoryId, EUnit defaultUnit, String? storeId, List<String> linkedProductIds, String? imageFilename, String imageUrl, DateTime updatedAt, DateTime? deletedAt, ESyncStatus syncStatus
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? normalizedName = null,Object? displayName = null,Object? aliases = null,Object? defaultCategoryId = freezed,Object? defaultUnit = null,Object? storeId = freezed,Object? linkedProductIds = null,Object? imageFilename = freezed,Object? imageUrl = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? syncStatus = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,normalizedName: null == normalizedName ? _self.normalizedName : normalizedName // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,aliases: null == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,defaultCategoryId: freezed == defaultCategoryId ? _self.defaultCategoryId : defaultCategoryId // ignore: cast_nullable_to_non_nullable
as String?,defaultUnit: null == defaultUnit ? _self.defaultUnit : defaultUnit // ignore: cast_nullable_to_non_nullable
as EUnit,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,linkedProductIds: null == linkedProductIds ? _self._linkedProductIds : linkedProductIds // ignore: cast_nullable_to_non_nullable
as List<String>,imageFilename: freezed == imageFilename ? _self.imageFilename : imageFilename // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as ESyncStatus,
  ));
}


}

// dart format on
