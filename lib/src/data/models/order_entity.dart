import 'enum.dart';

class OrderEntity {
  final String orderNo;
  final String orderDate;
  final OrderStatusEnum status;
  final String paymentMethod;
  final String totalPrice;

  OrderEntity({
    this.orderNo,
    this.orderDate,
    this.status,
    this.paymentMethod,
    this.totalPrice,
  });
}
