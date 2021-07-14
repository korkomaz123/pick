import 'enum.dart';

class TransactionEntity {
  final String orderId;
  final String number;
  final double amount;
  final String date;
  final TransactionType type;
  final String paymentMethod;
  final bool isIncome;

  TransactionEntity({
    this.orderId,
    this.number,
    this.amount,
    this.date,
    this.type,
    this.paymentMethod,
    this.isIncome,
  });

  TransactionEntity.fromJson(Map<String, dynamic> json)
      : orderId = json['order_entityid'],
        number = json['order_id'],
        amount = double.parse(json['amount']),
        date = json['created_at'],
        type = json['is_cashback'] == "1" || json['order_id'] == 'Admin Debit'
            ? TransactionType.admin
            : json['order_id'] == 'Wallet-Transfer'
                ? TransactionType.transfer
                : json['is_walletrecharge'] == "1"
                    ? TransactionType.debit
                    : TransactionType.order,
        paymentMethod = json['payment_code'],
        isIncome = json['action'] == "0";

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'number': number,
        'amount': amount,
        'date': date,
        'type': type,
        'paymentMethod': paymentMethod,
        'action': isIncome,
      };
}
