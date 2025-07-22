import 'package:intl/intl.dart';

class PaymentRecord {
  final DateTime recordTimestamp;
  final int amount;

  PaymentRecord({
    required this.recordTimestamp,
    required this.amount,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      recordTimestamp: DateTime.parse(json['recordtimestamp']),
      amount: int.parse(json['amount'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordtimestamp': recordTimestamp.toIso8601String(),
      'amount': amount,
    };
  }

  String get formattedDate {
    final formatter = DateFormat('d MMM yyyy, HH:mm');
    return formatter.format(recordTimestamp);
  }
}

class PaymentHistoryResponse {
  final List<PaymentRecord> data;

  PaymentHistoryResponse({required this.data});

  factory PaymentHistoryResponse.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryResponse(
      data: List<PaymentRecord>.from(
        json['data'].map((item) => PaymentRecord.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
