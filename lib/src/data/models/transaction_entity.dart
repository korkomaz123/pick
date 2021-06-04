import 'enum.dart';

class TransactionEntity {
  final String orderId;
  final String number;
  final double amount;
  final String date;
  final TransactionType type;
  final String paymentMethod;

  TransactionEntity({
    this.orderId,
    this.number,
    this.amount,
    this.date,
    this.type,
    this.paymentMethod,
  });

  TransactionEntity.fromJson(Map<String, dynamic> json)
      : orderId = json['order_entityid'],
        number = json['order_id'],
        amount = double.parse(json['amount']),
        date = json['created_at'],
        type = json['order_id'] == 'Admin Debit'
            ? TransactionType.admin
            : json['is_walletrecharge'] == "1"
                ? TransactionType.debit
                : TransactionType.order,
        paymentMethod = json['payment_code'];

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'number': number,
        'amount': amount,
        'date': date,
        'type': type,
        'paymentMethod': paymentMethod,
      };
}
