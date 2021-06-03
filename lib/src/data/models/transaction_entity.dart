import 'enum.dart';

class TransactionEntity {
  final String number;
  final double amount;
  final String date;
  final TransactionType type;

  TransactionEntity({
    this.number,
    this.amount,
    this.date,
    this.type,
  });

  TransactionEntity.fromJson(Map<String, dynamic> json)
      : number = json['order_id'],
        amount = double.parse(json['amount']),
        date = json['created_at'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'number': number,
        'amount': amount,
        'date': date,
        'type': type,
      };
}
