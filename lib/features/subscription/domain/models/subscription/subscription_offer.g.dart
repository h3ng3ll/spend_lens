// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscriptionOffer _$SubscriptionOfferFromJson(Map<String, dynamic> json) =>
    _SubscriptionOffer(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
    );

Map<String, dynamic> _$SubscriptionOfferToJson(_SubscriptionOffer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
    };
