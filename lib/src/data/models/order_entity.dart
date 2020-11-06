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

  OrderEntity.fromJson(Map<String, dynamic> json)
      : orderNo = json['order_no'],
        orderDate = json['order_date'],
        status = json['status'],
        paymentMethod = json['payment_method'],
        totalPrice = json['total_price'];
}
