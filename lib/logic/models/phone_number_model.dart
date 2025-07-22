import 'dart:math';

class PhoneNumberResponse {
  final List<PhoneNumber> data;
  final Meta meta;

  PhoneNumberResponse({
    required this.data,
    required this.meta,
  });

  factory PhoneNumberResponse.fromJson(Map<String, dynamic> json) {
    return PhoneNumberResponse(
      data: (json['data'] as List)
          .map((item) => PhoneNumber.fromJson(item))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}



class PhoneNumber {
  final String lifecycleStatus;
  final int number;
  final String numberType;
  final int price; // majburiy

  PhoneNumber({
    required this.lifecycleStatus,
    required this.number,
    required this.numberType,
    required this.price,
  });

  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(
      lifecycleStatus: json['lifecycle-status'],
      number: int.parse(json['number'].toString()),
      numberType: json['number-type'],
      price: random().price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lifecycle-status': lifecycleStatus,
      'number': number,
      'number-type': numberType,
      'price': price,
    };
  }

  static PhoneNumber random() {
    final rand = Random();
    final statuses = ['active', 'inactive', 'reserved'];
    final types = ['mobile', 'home', 'work'];

    // Narxlar ro‘yxati: 0 (bepul), 50k, 200k, 500k, 1m, 2m, 3m
    final prices = [0, 50000, 200000, 500000, 1000000, 2000000, 3000000];
    final randomPrice = prices[rand.nextInt(prices.length)];

    return PhoneNumber(
      lifecycleStatus: statuses[rand.nextInt(statuses.length)],
      number: 900000000 + rand.nextInt(99999999),
      numberType: types[rand.nextInt(types.length)],
      price: randomPrice,
    );
  }
}


class Meta {
  final int currentPage;
  final int pageSize;

  Meta({
    required this.currentPage,
    required this.pageSize,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: int.parse(json['currentPage'].toString()),
      pageSize: int.parse(json['pageSize'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
    };
  }
}