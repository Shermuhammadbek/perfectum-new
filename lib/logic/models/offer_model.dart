// Category enum
enum ProductCategory {
  commercial('commercial'),
  plan('plan'),
  wirelessBroadband('wireless-broadband'),
  prepaid('prepaid'),
  mobileBroadbandModem('mobile-broadband-modem'),
  device('device'),
  broadband('broadband'),
  meshRouter('mesh-router'),
  nonRecurring('non-recurring'),
  additional("additional");

  final String value;
  const ProductCategory(this.value);

  static ProductCategory fromString(String value) {
    return ProductCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown category: $value'),
    );
  }
}

// Price Type enum
enum PriceType {
  recurring('recurring'),
  oneTime('one-time');

  final String value;
  const PriceType(this.value);

  static PriceType fromString(String value) {
    return PriceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown price type: $value'),
    );
  }
}

// Allowance Type enum
enum AllowanceType {
  nationalData('national-data');

  final String value;
  const AllowanceType(this.value);

  static AllowanceType fromString(String value) {
    return AllowanceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown allowance type: $value'),
    );
  }
}

// Allowance model
class Allowance {
  final AllowanceType type;
  final String id;
  final int allowance;
  final String unitOfMeasure;

  Allowance({
    required this.type,
    required this.id,
    required this.allowance,
    required this.unitOfMeasure,
  });

  factory Allowance.fromJson(Map<String, dynamic> json) {
    return Allowance(
      type: AllowanceType.fromString(json['type']),
      id: json['id'],
      allowance: json['allowance'],
      unitOfMeasure: json['unit-of-measure'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'id': id,
      'allowance': allowance,
      'unit-of-measure': unitOfMeasure,
    };
  }
}

// Price model
class Price {
  final PriceType type;
  final String amount;
  final int? recurringCount;
  final String? recurringInterval;

  Price({
    required this.type,
    required this.amount,
    this.recurringCount,
    this.recurringInterval,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      type: PriceType.fromString(json['type']),
      amount: json['amount'],
      recurringCount: json['recurring-count'],
      recurringInterval: json['recurring-interval'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'amount': amount,
      if (recurringCount != null) 'recurring-count': recurringCount,
      if (recurringInterval != null) 'recurring-interval': recurringInterval,
    };
  }

  // Helper method to get formatted price
  String get formattedAmount {
    final num = int.tryParse(amount) ?? 0;
    return '${(num / 1000).toStringAsFixed(0)} 000 so\'m';
  }
}

// Main Product Offering model
class ProductOffering {
  final DateTime bdate;
  final String id;
  final String name;
  final String type;
  final String? channel1;
  final String? channel2;
  final String? channel3;
  final String? channel4;
  final List<Allowance> allowances;
  final List<ProductCategory> categories;
  final List<Price> prices;

  ProductOffering({
    required this.bdate,
    required this.id,
    required this.name,
    required this.type,
    this.channel1,
    this.channel2,
    this.channel3,
    this.channel4,
    required this.allowances,
    required this.categories,
    required this.prices,
  });

  factory ProductOffering.fromJson(Map<String, dynamic> json) {
    return ProductOffering(
      bdate: DateTime.parse(json['bdate']),
      id: json['id'],
      name: json['name'],
      type: json['type'],
      channel1: json['channel_1'],
      channel2: json['channel_2'],
      channel3: json['channel_3'],
      channel4: json['channel_4'],
      allowances: (json['allowances'] as List)
          .map((e) => Allowance.fromJson(e))
          .toList(),
      categories: (json['categories'] as List)
          .map((e) => ProductCategory.fromString(e))
          .toList(),
      prices: (json['prices'] as List)
          .map((e) => Price.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bdate': bdate.toIso8601String(),
      'id': id,
      'name': name,
      'type': type,
      'channel_1': channel1,
      'channel_2': channel2,
      'channel_3': channel3,
      'channel_4': channel4,
      'allowances': allowances.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.value).toList(),
      'prices': prices.map((e) => e.toJson()).toList(),
    };
  }

  // Helper methods
  bool get isPlan => categories.contains(ProductCategory.plan);
  bool get isDevice => categories.contains(ProductCategory.device);
  bool get isCommercial => categories.contains(ProductCategory.commercial);
  bool get hasUnlimitedData => allowances.any((a) => a.allowance >= 9999999999);
  bool get isWirelessBroadband => categories.contains(ProductCategory.wirelessBroadband);
  
  Price? get recurringPrice => prices.firstWhere(
    (p) => p.type == PriceType.recurring,
    orElse: () => prices.first,
  );
  
  Price? get oneTimePrice => prices.firstWhere(
    (p) => p.type == PriceType.oneTime,
    orElse: () => prices.first,
  );
}

// Response model
class ProductOfferingsResponse {
  final List<ProductOffering> data;

  ProductOfferingsResponse({required this.data});

  factory ProductOfferingsResponse.fromJson(List<Map<String, dynamic>> json) {
    return ProductOfferingsResponse(
      data: List.generate(json.length, (index) {
        return ProductOffering.fromJson(json[index]);
      })
    );
  }
}
