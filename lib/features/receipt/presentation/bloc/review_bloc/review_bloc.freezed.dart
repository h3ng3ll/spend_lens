// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReviewEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReviewEvent()';
}


}

/// @nodoc
class $ReviewEventCopyWith<$Res>  {
$ReviewEventCopyWith(ReviewEvent _, $Res Function(ReviewEvent) __);
}


/// Adds pattern-matching-related methods to [ReviewEvent].
extension ReviewEventPatterns on ReviewEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Load value)?  load,TResult Function( _StartEditItem value)?  startEditItem,TResult Function( _CommitEditedName value)?  commitEditedName,TResult Function( _StopEditItem value)?  stopEditItem,TResult Function( _SetCategory value)?  setCategory,TResult Function( _Save value)?  save,TResult Function( _SaveAndCorrect value)?  saveAndCorrect,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _StartEditItem() when startEditItem != null:
return startEditItem(_that);case _CommitEditedName() when commitEditedName != null:
return commitEditedName(_that);case _StopEditItem() when stopEditItem != null:
return stopEditItem(_that);case _SetCategory() when setCategory != null:
return setCategory(_that);case _Save() when save != null:
return save(_that);case _SaveAndCorrect() when saveAndCorrect != null:
return saveAndCorrect(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Load value)  load,required TResult Function( _StartEditItem value)  startEditItem,required TResult Function( _CommitEditedName value)  commitEditedName,required TResult Function( _StopEditItem value)  stopEditItem,required TResult Function( _SetCategory value)  setCategory,required TResult Function( _Save value)  save,required TResult Function( _SaveAndCorrect value)  saveAndCorrect,}){
final _that = this;
switch (_that) {
case _Load():
return load(_that);case _StartEditItem():
return startEditItem(_that);case _CommitEditedName():
return commitEditedName(_that);case _StopEditItem():
return stopEditItem(_that);case _SetCategory():
return setCategory(_that);case _Save():
return save(_that);case _SaveAndCorrect():
return saveAndCorrect(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Load value)?  load,TResult? Function( _StartEditItem value)?  startEditItem,TResult? Function( _CommitEditedName value)?  commitEditedName,TResult? Function( _StopEditItem value)?  stopEditItem,TResult? Function( _SetCategory value)?  setCategory,TResult? Function( _Save value)?  save,TResult? Function( _SaveAndCorrect value)?  saveAndCorrect,}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _StartEditItem() when startEditItem != null:
return startEditItem(_that);case _CommitEditedName() when commitEditedName != null:
return commitEditedName(_that);case _StopEditItem() when stopEditItem != null:
return stopEditItem(_that);case _SetCategory() when setCategory != null:
return setCategory(_that);case _Save() when save != null:
return save(_that);case _SaveAndCorrect() when saveAndCorrect != null:
return saveAndCorrect(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  load,TResult Function( String itemId)?  startEditItem,TResult Function( String name)?  commitEditedName,TResult Function()?  stopEditItem,TResult Function( String categoryId)?  setCategory,TResult Function()?  save,TResult Function()?  saveAndCorrect,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load();case _StartEditItem() when startEditItem != null:
return startEditItem(_that.itemId);case _CommitEditedName() when commitEditedName != null:
return commitEditedName(_that.name);case _StopEditItem() when stopEditItem != null:
return stopEditItem();case _SetCategory() when setCategory != null:
return setCategory(_that.categoryId);case _Save() when save != null:
return save();case _SaveAndCorrect() when saveAndCorrect != null:
return saveAndCorrect();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  load,required TResult Function( String itemId)  startEditItem,required TResult Function( String name)  commitEditedName,required TResult Function()  stopEditItem,required TResult Function( String categoryId)  setCategory,required TResult Function()  save,required TResult Function()  saveAndCorrect,}) {final _that = this;
switch (_that) {
case _Load():
return load();case _StartEditItem():
return startEditItem(_that.itemId);case _CommitEditedName():
return commitEditedName(_that.name);case _StopEditItem():
return stopEditItem();case _SetCategory():
return setCategory(_that.categoryId);case _Save():
return save();case _SaveAndCorrect():
return saveAndCorrect();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  load,TResult? Function( String itemId)?  startEditItem,TResult? Function( String name)?  commitEditedName,TResult? Function()?  stopEditItem,TResult? Function( String categoryId)?  setCategory,TResult? Function()?  save,TResult? Function()?  saveAndCorrect,}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load();case _StartEditItem() when startEditItem != null:
return startEditItem(_that.itemId);case _CommitEditedName() when commitEditedName != null:
return commitEditedName(_that.name);case _StopEditItem() when stopEditItem != null:
return stopEditItem();case _SetCategory() when setCategory != null:
return setCategory(_that.categoryId);case _Save() when save != null:
return save();case _SaveAndCorrect() when saveAndCorrect != null:
return saveAndCorrect();case _:
  return null;

}
}

}

/// @nodoc


class _Load implements ReviewEvent {
  const _Load();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Load);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReviewEvent.load()';
}


}




/// @nodoc


class _StartEditItem implements ReviewEvent {
  const _StartEditItem(this.itemId);
  

 final  String itemId;

/// Create a copy of ReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartEditItemCopyWith<_StartEditItem> get copyWith => __$StartEditItemCopyWithImpl<_StartEditItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartEditItem&&(identical(other.itemId, itemId) || other.itemId == itemId));
}


@override
int get hashCode => Object.hash(runtimeType,itemId);

@override
String toString() {
  return 'ReviewEvent.startEditItem(itemId: $itemId)';
}


}

/// @nodoc
abstract mixin class _$StartEditItemCopyWith<$Res> implements $ReviewEventCopyWith<$Res> {
  factory _$StartEditItemCopyWith(_StartEditItem value, $Res Function(_StartEditItem) _then) = __$StartEditItemCopyWithImpl;
@useResult
$Res call({
 String itemId
});




}
/// @nodoc
class __$StartEditItemCopyWithImpl<$Res>
    implements _$StartEditItemCopyWith<$Res> {
  __$StartEditItemCopyWithImpl(this._self, this._then);

  final _StartEditItem _self;
  final $Res Function(_StartEditItem) _then;

/// Create a copy of ReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,}) {
  return _then(_StartEditItem(
null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _CommitEditedName implements ReviewEvent {
  const _CommitEditedName(this.name);
  

 final  String name;

/// Create a copy of ReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommitEditedNameCopyWith<_CommitEditedName> get copyWith => __$CommitEditedNameCopyWithImpl<_CommitEditedName>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommitEditedName&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'ReviewEvent.commitEditedName(name: $name)';
}


}

/// @nodoc
abstract mixin class _$CommitEditedNameCopyWith<$Res> implements $ReviewEventCopyWith<$Res> {
  factory _$CommitEditedNameCopyWith(_CommitEditedName value, $Res Function(_CommitEditedName) _then) = __$CommitEditedNameCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class __$CommitEditedNameCopyWithImpl<$Res>
    implements _$CommitEditedNameCopyWith<$Res> {
  __$CommitEditedNameCopyWithImpl(this._self, this._then);

  final _CommitEditedName _self;
  final $Res Function(_CommitEditedName) _then;

/// Create a copy of ReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_CommitEditedName(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _StopEditItem implements ReviewEvent {
  const _StopEditItem();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopEditItem);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReviewEvent.stopEditItem()';
}


}




/// @nodoc


class _SetCategory implements ReviewEvent {
  const _SetCategory(this.categoryId);
  

 final  String categoryId;

/// Create a copy of ReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetCategoryCopyWith<_SetCategory> get copyWith => __$SetCategoryCopyWithImpl<_SetCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetCategory&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId);

@override
String toString() {
  return 'ReviewEvent.setCategory(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$SetCategoryCopyWith<$Res> implements $ReviewEventCopyWith<$Res> {
  factory _$SetCategoryCopyWith(_SetCategory value, $Res Function(_SetCategory) _then) = __$SetCategoryCopyWithImpl;
@useResult
$Res call({
 String categoryId
});




}
/// @nodoc
class __$SetCategoryCopyWithImpl<$Res>
    implements _$SetCategoryCopyWith<$Res> {
  __$SetCategoryCopyWithImpl(this._self, this._then);

  final _SetCategory _self;
  final $Res Function(_SetCategory) _then;

/// Create a copy of ReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = null,}) {
  return _then(_SetCategory(
null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Save implements ReviewEvent {
  const _Save();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Save);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReviewEvent.save()';
}


}




/// @nodoc


class _SaveAndCorrect implements ReviewEvent {
  const _SaveAndCorrect();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveAndCorrect);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReviewEvent.saveAndCorrect()';
}


}




/// @nodoc
mixin _$ReviewState {

 EReviewStatus get status; String? get storeName; DateTime? get purchasedAt; double? get printedTotal; List<ReviewDraftItem> get items; String? get categoryId; String? get editingItemId; bool get isReconciled; double? get reconciliationDifference; bool get isLikelyDuplicate; Uint8List? get imageBytes; String? get savedReceiptId; String? get errorMessage;
/// Create a copy of ReviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewStateCopyWith<ReviewState> get copyWith => _$ReviewStateCopyWithImpl<ReviewState>(this as ReviewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewState&&(identical(other.status, status) || other.status == status)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.purchasedAt, purchasedAt) || other.purchasedAt == purchasedAt)&&(identical(other.printedTotal, printedTotal) || other.printedTotal == printedTotal)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.editingItemId, editingItemId) || other.editingItemId == editingItemId)&&(identical(other.isReconciled, isReconciled) || other.isReconciled == isReconciled)&&(identical(other.reconciliationDifference, reconciliationDifference) || other.reconciliationDifference == reconciliationDifference)&&(identical(other.isLikelyDuplicate, isLikelyDuplicate) || other.isLikelyDuplicate == isLikelyDuplicate)&&const DeepCollectionEquality().equals(other.imageBytes, imageBytes)&&(identical(other.savedReceiptId, savedReceiptId) || other.savedReceiptId == savedReceiptId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,storeName,purchasedAt,printedTotal,const DeepCollectionEquality().hash(items),categoryId,editingItemId,isReconciled,reconciliationDifference,isLikelyDuplicate,const DeepCollectionEquality().hash(imageBytes),savedReceiptId,errorMessage);

@override
String toString() {
  return 'ReviewState(status: $status, storeName: $storeName, purchasedAt: $purchasedAt, printedTotal: $printedTotal, items: $items, categoryId: $categoryId, editingItemId: $editingItemId, isReconciled: $isReconciled, reconciliationDifference: $reconciliationDifference, isLikelyDuplicate: $isLikelyDuplicate, imageBytes: $imageBytes, savedReceiptId: $savedReceiptId, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ReviewStateCopyWith<$Res>  {
  factory $ReviewStateCopyWith(ReviewState value, $Res Function(ReviewState) _then) = _$ReviewStateCopyWithImpl;
@useResult
$Res call({
 EReviewStatus status, String? storeName, DateTime? purchasedAt, double? printedTotal, List<ReviewDraftItem> items, String? categoryId, String? editingItemId, bool isReconciled, double? reconciliationDifference, bool isLikelyDuplicate, Uint8List? imageBytes, String? savedReceiptId, String? errorMessage
});




}
/// @nodoc
class _$ReviewStateCopyWithImpl<$Res>
    implements $ReviewStateCopyWith<$Res> {
  _$ReviewStateCopyWithImpl(this._self, this._then);

  final ReviewState _self;
  final $Res Function(ReviewState) _then;

/// Create a copy of ReviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? storeName = freezed,Object? purchasedAt = freezed,Object? printedTotal = freezed,Object? items = null,Object? categoryId = freezed,Object? editingItemId = freezed,Object? isReconciled = null,Object? reconciliationDifference = freezed,Object? isLikelyDuplicate = null,Object? imageBytes = freezed,Object? savedReceiptId = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EReviewStatus,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,purchasedAt: freezed == purchasedAt ? _self.purchasedAt : purchasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,printedTotal: freezed == printedTotal ? _self.printedTotal : printedTotal // ignore: cast_nullable_to_non_nullable
as double?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReviewDraftItem>,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,editingItemId: freezed == editingItemId ? _self.editingItemId : editingItemId // ignore: cast_nullable_to_non_nullable
as String?,isReconciled: null == isReconciled ? _self.isReconciled : isReconciled // ignore: cast_nullable_to_non_nullable
as bool,reconciliationDifference: freezed == reconciliationDifference ? _self.reconciliationDifference : reconciliationDifference // ignore: cast_nullable_to_non_nullable
as double?,isLikelyDuplicate: null == isLikelyDuplicate ? _self.isLikelyDuplicate : isLikelyDuplicate // ignore: cast_nullable_to_non_nullable
as bool,imageBytes: freezed == imageBytes ? _self.imageBytes : imageBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,savedReceiptId: freezed == savedReceiptId ? _self.savedReceiptId : savedReceiptId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewState].
extension ReviewStatePatterns on ReviewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewState value)  $default,){
final _that = this;
switch (_that) {
case _ReviewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewState value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EReviewStatus status,  String? storeName,  DateTime? purchasedAt,  double? printedTotal,  List<ReviewDraftItem> items,  String? categoryId,  String? editingItemId,  bool isReconciled,  double? reconciliationDifference,  bool isLikelyDuplicate,  Uint8List? imageBytes,  String? savedReceiptId,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewState() when $default != null:
return $default(_that.status,_that.storeName,_that.purchasedAt,_that.printedTotal,_that.items,_that.categoryId,_that.editingItemId,_that.isReconciled,_that.reconciliationDifference,_that.isLikelyDuplicate,_that.imageBytes,_that.savedReceiptId,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EReviewStatus status,  String? storeName,  DateTime? purchasedAt,  double? printedTotal,  List<ReviewDraftItem> items,  String? categoryId,  String? editingItemId,  bool isReconciled,  double? reconciliationDifference,  bool isLikelyDuplicate,  Uint8List? imageBytes,  String? savedReceiptId,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ReviewState():
return $default(_that.status,_that.storeName,_that.purchasedAt,_that.printedTotal,_that.items,_that.categoryId,_that.editingItemId,_that.isReconciled,_that.reconciliationDifference,_that.isLikelyDuplicate,_that.imageBytes,_that.savedReceiptId,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EReviewStatus status,  String? storeName,  DateTime? purchasedAt,  double? printedTotal,  List<ReviewDraftItem> items,  String? categoryId,  String? editingItemId,  bool isReconciled,  double? reconciliationDifference,  bool isLikelyDuplicate,  Uint8List? imageBytes,  String? savedReceiptId,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ReviewState() when $default != null:
return $default(_that.status,_that.storeName,_that.purchasedAt,_that.printedTotal,_that.items,_that.categoryId,_that.editingItemId,_that.isReconciled,_that.reconciliationDifference,_that.isLikelyDuplicate,_that.imageBytes,_that.savedReceiptId,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewState implements ReviewState {
  const _ReviewState({this.status = EReviewStatus.initial, this.storeName, this.purchasedAt, this.printedTotal, final  List<ReviewDraftItem> items = const <ReviewDraftItem>[], this.categoryId, this.editingItemId, this.isReconciled = false, this.reconciliationDifference, this.isLikelyDuplicate = false, this.imageBytes, this.savedReceiptId, this.errorMessage}): _items = items;
  

@override@JsonKey() final  EReviewStatus status;
@override final  String? storeName;
@override final  DateTime? purchasedAt;
@override final  double? printedTotal;
 final  List<ReviewDraftItem> _items;
@override@JsonKey() List<ReviewDraftItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? categoryId;
@override final  String? editingItemId;
@override@JsonKey() final  bool isReconciled;
@override final  double? reconciliationDifference;
@override@JsonKey() final  bool isLikelyDuplicate;
@override final  Uint8List? imageBytes;
@override final  String? savedReceiptId;
@override final  String? errorMessage;

/// Create a copy of ReviewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewStateCopyWith<_ReviewState> get copyWith => __$ReviewStateCopyWithImpl<_ReviewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewState&&(identical(other.status, status) || other.status == status)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.purchasedAt, purchasedAt) || other.purchasedAt == purchasedAt)&&(identical(other.printedTotal, printedTotal) || other.printedTotal == printedTotal)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.editingItemId, editingItemId) || other.editingItemId == editingItemId)&&(identical(other.isReconciled, isReconciled) || other.isReconciled == isReconciled)&&(identical(other.reconciliationDifference, reconciliationDifference) || other.reconciliationDifference == reconciliationDifference)&&(identical(other.isLikelyDuplicate, isLikelyDuplicate) || other.isLikelyDuplicate == isLikelyDuplicate)&&const DeepCollectionEquality().equals(other.imageBytes, imageBytes)&&(identical(other.savedReceiptId, savedReceiptId) || other.savedReceiptId == savedReceiptId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,storeName,purchasedAt,printedTotal,const DeepCollectionEquality().hash(_items),categoryId,editingItemId,isReconciled,reconciliationDifference,isLikelyDuplicate,const DeepCollectionEquality().hash(imageBytes),savedReceiptId,errorMessage);

@override
String toString() {
  return 'ReviewState(status: $status, storeName: $storeName, purchasedAt: $purchasedAt, printedTotal: $printedTotal, items: $items, categoryId: $categoryId, editingItemId: $editingItemId, isReconciled: $isReconciled, reconciliationDifference: $reconciliationDifference, isLikelyDuplicate: $isLikelyDuplicate, imageBytes: $imageBytes, savedReceiptId: $savedReceiptId, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ReviewStateCopyWith<$Res> implements $ReviewStateCopyWith<$Res> {
  factory _$ReviewStateCopyWith(_ReviewState value, $Res Function(_ReviewState) _then) = __$ReviewStateCopyWithImpl;
@override @useResult
$Res call({
 EReviewStatus status, String? storeName, DateTime? purchasedAt, double? printedTotal, List<ReviewDraftItem> items, String? categoryId, String? editingItemId, bool isReconciled, double? reconciliationDifference, bool isLikelyDuplicate, Uint8List? imageBytes, String? savedReceiptId, String? errorMessage
});




}
/// @nodoc
class __$ReviewStateCopyWithImpl<$Res>
    implements _$ReviewStateCopyWith<$Res> {
  __$ReviewStateCopyWithImpl(this._self, this._then);

  final _ReviewState _self;
  final $Res Function(_ReviewState) _then;

/// Create a copy of ReviewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? storeName = freezed,Object? purchasedAt = freezed,Object? printedTotal = freezed,Object? items = null,Object? categoryId = freezed,Object? editingItemId = freezed,Object? isReconciled = null,Object? reconciliationDifference = freezed,Object? isLikelyDuplicate = null,Object? imageBytes = freezed,Object? savedReceiptId = freezed,Object? errorMessage = freezed,}) {
  return _then(_ReviewState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EReviewStatus,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,purchasedAt: freezed == purchasedAt ? _self.purchasedAt : purchasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,printedTotal: freezed == printedTotal ? _self.printedTotal : printedTotal // ignore: cast_nullable_to_non_nullable
as double?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReviewDraftItem>,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,editingItemId: freezed == editingItemId ? _self.editingItemId : editingItemId // ignore: cast_nullable_to_non_nullable
as String?,isReconciled: null == isReconciled ? _self.isReconciled : isReconciled // ignore: cast_nullable_to_non_nullable
as bool,reconciliationDifference: freezed == reconciliationDifference ? _self.reconciliationDifference : reconciliationDifference // ignore: cast_nullable_to_non_nullable
as double?,isLikelyDuplicate: null == isLikelyDuplicate ? _self.isLikelyDuplicate : isLikelyDuplicate // ignore: cast_nullable_to_non_nullable
as bool,imageBytes: freezed == imageBytes ? _self.imageBytes : imageBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,savedReceiptId: freezed == savedReceiptId ? _self.savedReceiptId : savedReceiptId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
