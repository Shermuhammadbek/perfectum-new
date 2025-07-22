import 'package:intl/intl.dart';

class BundleTransaction {
  final DateTime recordTimestamp;
  final String bundleName;
  final int balanceBefore;
  final int amount;
  final int balanceAfter;
  final String? renewalModeId;

  BundleTransaction({
    required this.recordTimestamp,
    required this.bundleName,
    required this.balanceBefore,
    required this.amount,
    required this.balanceAfter,
    this.renewalModeId,
  });

  factory BundleTransaction.fromJson(Map<String, dynamic> json) {
    return BundleTransaction(
      recordTimestamp: DateTime.parse(json['recordtimestamp']),
      bundleName: json['bundlename'],
      balanceBefore: int.parse(json['balancebefore'].toString()),
      amount: int.parse(json['amount'].toString()),
      balanceAfter: int.parse(json['balanceafter'].toString()),
      renewalModeId: json['renewalmode_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordtimestamp': recordTimestamp.toIso8601String(),
      'bundlename': bundleName,
      'balancebefore': balanceBefore,
      'amount': amount,
      'balanceafter': balanceAfter,
      'renewalmode_id': renewalModeId,
    };
  }

  /// User-friendly formatted date
  String get formattedDate {
    final formatter = DateFormat('d MMM yyyy, HH:mm');
    return formatter.format(recordTimestamp);
  }
}


class BundleTransactionResponse {
  final List<BundleTransaction> data;

  BundleTransactionResponse({required this.data});

  factory BundleTransactionResponse.fromJson(Map<String, dynamic> json) {
    return BundleTransactionResponse(
      data: List<BundleTransaction>.from(
        json['data'].map((item) => BundleTransaction.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
