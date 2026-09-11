// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubscriptionEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionEvent()';
}


}

/// @nodoc
class $SubscriptionEventCopyWith<$Res>  {
$SubscriptionEventCopyWith(SubscriptionEvent _, $Res Function(SubscriptionEvent) __);
}


/// Adds pattern-matching-related methods to [SubscriptionEvent].
extension SubscriptionEventPatterns on SubscriptionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SelectPlan value)?  selectPlan,TResult Function( _Purchase value)?  purchase,TResult Function( _Restore value)?  restore,TResult Function( _GetOffers value)?  getOffers,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectPlan() when selectPlan != null:
return selectPlan(_that);case _Purchase() when purchase != null:
return purchase(_that);case _Restore() when restore != null:
return restore(_that);case _GetOffers() when getOffers != null:
return getOffers(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SelectPlan value)  selectPlan,required TResult Function( _Purchase value)  purchase,required TResult Function( _Restore value)  restore,required TResult Function( _GetOffers value)  getOffers,}){
final _that = this;
switch (_that) {
case _SelectPlan():
return selectPlan(_that);case _Purchase():
return purchase(_that);case _Restore():
return restore(_that);case _GetOffers():
return getOffers(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SelectPlan value)?  selectPlan,TResult? Function( _Purchase value)?  purchase,TResult? Function( _Restore value)?  restore,TResult? Function( _GetOffers value)?  getOffers,}){
final _that = this;
switch (_that) {
case _SelectPlan() when selectPlan != null:
return selectPlan(_that);case _Purchase() when purchase != null:
return purchase(_that);case _Restore() when restore != null:
return restore(_that);case _GetOffers() when getOffers != null:
return getOffers(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String planId)?  selectPlan,TResult Function()?  purchase,TResult Function()?  restore,TResult Function()?  getOffers,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectPlan() when selectPlan != null:
return selectPlan(_that.planId);case _Purchase() when purchase != null:
return purchase();case _Restore() when restore != null:
return restore();case _GetOffers() when getOffers != null:
return getOffers();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String planId)  selectPlan,required TResult Function()  purchase,required TResult Function()  restore,required TResult Function()  getOffers,}) {final _that = this;
switch (_that) {
case _SelectPlan():
return selectPlan(_that.planId);case _Purchase():
return purchase();case _Restore():
return restore();case _GetOffers():
return getOffers();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String planId)?  selectPlan,TResult? Function()?  purchase,TResult? Function()?  restore,TResult? Function()?  getOffers,}) {final _that = this;
switch (_that) {
case _SelectPlan() when selectPlan != null:
return selectPlan(_that.planId);case _Purchase() when purchase != null:
return purchase();case _Restore() when restore != null:
return restore();case _GetOffers() when getOffers != null:
return getOffers();case _:
  return null;

}
}

}

/// @nodoc


class _SelectPlan implements SubscriptionEvent {
  const _SelectPlan(this.planId);
  

 final  String planId;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectPlanCopyWith<_SelectPlan> get copyWith => __$SelectPlanCopyWithImpl<_SelectPlan>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectPlan&&(identical(other.planId, planId) || other.planId == planId));
}


@override
int get hashCode => Object.hash(runtimeType,planId);

@override
String toString() {
  return 'SubscriptionEvent.selectPlan(planId: $planId)';
}


}

/// @nodoc
abstract mixin class _$SelectPlanCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory _$SelectPlanCopyWith(_SelectPlan value, $Res Function(_SelectPlan) _then) = __$SelectPlanCopyWithImpl;
@useResult
$Res call({
 String planId
});




}
/// @nodoc
class __$SelectPlanCopyWithImpl<$Res>
    implements _$SelectPlanCopyWith<$Res> {
  __$SelectPlanCopyWithImpl(this._self, this._then);

  final _SelectPlan _self;
  final $Res Function(_SelectPlan) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? planId = null,}) {
  return _then(_SelectPlan(
null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Purchase implements SubscriptionEvent {
  const _Purchase();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Purchase);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionEvent.purchase()';
}


}




/// @nodoc


class _Restore implements SubscriptionEvent {
  const _Restore();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Restore);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionEvent.restore()';
}


}




/// @nodoc


class _GetOffers implements SubscriptionEvent {
  const _GetOffers();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetOffers);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionEvent.getOffers()';
}


}




/// @nodoc
mixin _$SubscriptionState {

 ESubscriptionStatus get status;/// Id
 String? get selectedPlan; List<SubscriptionOffer> get subscriptions; String get errorMessage;
/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionStateCopyWith<SubscriptionState> get copyWith => _$SubscriptionStateCopyWithImpl<SubscriptionState>(this as SubscriptionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionState&&(identical(other.status, status) || other.status == status)&&(identical(other.selectedPlan, selectedPlan) || other.selectedPlan == selectedPlan)&&const DeepCollectionEquality().equals(other.subscriptions, subscriptions)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,selectedPlan,const DeepCollectionEquality().hash(subscriptions),errorMessage);

@override
String toString() {
  return 'SubscriptionState(status: $status, selectedPlan: $selectedPlan, subscriptions: $subscriptions, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SubscriptionStateCopyWith<$Res>  {
  factory $SubscriptionStateCopyWith(SubscriptionState value, $Res Function(SubscriptionState) _then) = _$SubscriptionStateCopyWithImpl;
@useResult
$Res call({
 ESubscriptionStatus status, String? selectedPlan, List<SubscriptionOffer> subscriptions, String errorMessage
});




}
/// @nodoc
class _$SubscriptionStateCopyWithImpl<$Res>
    implements $SubscriptionStateCopyWith<$Res> {
  _$SubscriptionStateCopyWithImpl(this._self, this._then);

  final SubscriptionState _self;
  final $Res Function(SubscriptionState) _then;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? selectedPlan = freezed,Object? subscriptions = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ESubscriptionStatus,selectedPlan: freezed == selectedPlan ? _self.selectedPlan : selectedPlan // ignore: cast_nullable_to_non_nullable
as String?,subscriptions: null == subscriptions ? _self.subscriptions : subscriptions // ignore: cast_nullable_to_non_nullable
as List<SubscriptionOffer>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionState].
extension SubscriptionStatePatterns on SubscriptionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionState value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionState value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ESubscriptionStatus status,  String? selectedPlan,  List<SubscriptionOffer> subscriptions,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
return $default(_that.status,_that.selectedPlan,_that.subscriptions,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ESubscriptionStatus status,  String? selectedPlan,  List<SubscriptionOffer> subscriptions,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionState():
return $default(_that.status,_that.selectedPlan,_that.subscriptions,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ESubscriptionStatus status,  String? selectedPlan,  List<SubscriptionOffer> subscriptions,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
return $default(_that.status,_that.selectedPlan,_that.subscriptions,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SubscriptionState implements SubscriptionState {
  const _SubscriptionState({this.status = ESubscriptionStatus.idle, this.selectedPlan, final  List<SubscriptionOffer> subscriptions = const [], this.errorMessage = ''}): _subscriptions = subscriptions;
  

@override@JsonKey() final  ESubscriptionStatus status;
/// Id
@override final  String? selectedPlan;
 final  List<SubscriptionOffer> _subscriptions;
@override@JsonKey() List<SubscriptionOffer> get subscriptions {
  if (_subscriptions is EqualUnmodifiableListView) return _subscriptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subscriptions);
}

@override@JsonKey() final  String errorMessage;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionStateCopyWith<_SubscriptionState> get copyWith => __$SubscriptionStateCopyWithImpl<_SubscriptionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionState&&(identical(other.status, status) || other.status == status)&&(identical(other.selectedPlan, selectedPlan) || other.selectedPlan == selectedPlan)&&const DeepCollectionEquality().equals(other._subscriptions, _subscriptions)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,selectedPlan,const DeepCollectionEquality().hash(_subscriptions),errorMessage);

@override
String toString() {
  return 'SubscriptionState(status: $status, selectedPlan: $selectedPlan, subscriptions: $subscriptions, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionStateCopyWith<$Res> implements $SubscriptionStateCopyWith<$Res> {
  factory _$SubscriptionStateCopyWith(_SubscriptionState value, $Res Function(_SubscriptionState) _then) = __$SubscriptionStateCopyWithImpl;
@override @useResult
$Res call({
 ESubscriptionStatus status, String? selectedPlan, List<SubscriptionOffer> subscriptions, String errorMessage
});




}
/// @nodoc
class __$SubscriptionStateCopyWithImpl<$Res>
    implements _$SubscriptionStateCopyWith<$Res> {
  __$SubscriptionStateCopyWithImpl(this._self, this._then);

  final _SubscriptionState _self;
  final $Res Function(_SubscriptionState) _then;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? selectedPlan = freezed,Object? subscriptions = null,Object? errorMessage = null,}) {
  return _then(_SubscriptionState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ESubscriptionStatus,selectedPlan: freezed == selectedPlan ? _self.selectedPlan : selectedPlan // ignore: cast_nullable_to_non_nullable
as String?,subscriptions: null == subscriptions ? _self._subscriptions : subscriptions // ignore: cast_nullable_to_non_nullable
as List<SubscriptionOffer>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
