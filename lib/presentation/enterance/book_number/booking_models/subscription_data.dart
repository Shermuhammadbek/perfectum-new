

class SubscriptionData {
  final String basketId;
  final String subscriptionItemId;
  final String subscriptionProductId;
  final String reservationIdMsisdn;
  final DateTime endTime;
  final DateTime createdAt;
  final String msisdn;
  final String offerId;

  SubscriptionData({
    required this.basketId,
    required this.subscriptionItemId,
    required this.subscriptionProductId,
    required this.reservationIdMsisdn,
    required this.endTime,
    required this.createdAt,
    required this.msisdn,
    required this.offerId,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      basketId: json['basket-id'],
      subscriptionItemId: json['subscription-item-id'],
      subscriptionProductId: json['subscription-product-id'],
      reservationIdMsisdn: json['reservation-id-msisdn'],
      endTime: DateTime.parse(json['end-time'].toString()),
      createdAt: DateTime.parse(json['created-at'].toString()),
      msisdn: json['msisdn'],
      offerId: json['offer-id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basket-id': basketId,
      'subscription-item-id': subscriptionItemId,
      'subscription-product-id': subscriptionProductId,
      'reservation-id-msisdn': reservationIdMsisdn,
      'end-time': endTime.toIso8601String(),
      'created-at': createdAt.toIso8601String(),
      'msisdn': msisdn,
      'offer_id': offerId,
    };
  }
}
