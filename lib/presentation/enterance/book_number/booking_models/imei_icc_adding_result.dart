class ImeiIccAddingResult {
  final String basketId;
  final String subscriptionItemId;
  final NewDevice? device;

  ImeiIccAddingResult ({
    required this.basketId,
    required this.subscriptionItemId,
    this.device,
  });

  factory ImeiIccAddingResult.fromJson(Map<String, dynamic> json) {
    return ImeiIccAddingResult (
      basketId: json['basket-id'] as String,
      subscriptionItemId: json['subscription-item-id'] as String,
      device: json['device'] != null
          ? NewDevice.fromJson(json['device'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basket-id': basketId,
      'subscription-item-id': subscriptionItemId,
      if (device != null) 'device': device!.toJson(),
    };
  }
}

class NewDevice {
  final String identifier;
  final String sku;
  final String stockId;
  final String stockType;

  NewDevice({
    required this.identifier,
    required this.sku,
    required this.stockId,
    required this.stockType,
  });

  factory NewDevice.fromJson(Map<String, dynamic> json) {
    return NewDevice(
      identifier: json['identifier'].toString(),
      sku: json['sku'] as String,
      stockId: json['stock-id'] as String,
      stockType: json['stock-type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'sku': sku,
      'stock-id': stockId,
      'stock-type': stockType,
    };
  }
}
