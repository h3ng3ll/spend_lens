import 'package:freezed_annotation/freezed_annotation.dart';


part 'subscription_offer.freezed.dart';

part 'subscription_offer.g.dart';

@freezed
sealed class SubscriptionOffer with _$SubscriptionOffer {
  const factory SubscriptionOffer({
    required String id,
    required String name,
    required String description,
    required String price,
  }) = _SubscriptionOffer;

  factory SubscriptionOffer.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionOfferFromJson(
    json,
  );
}
