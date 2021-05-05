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
}
