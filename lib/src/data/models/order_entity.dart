import 'package:enum_to_string/enum_to_string.dart';

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
      : orderNo = json['increment_id'],
        orderDate = json['created_at'],
        status = EnumToString.fromString(
          OrderStatusEnum.values,
          json['status'],
        ),
        paymentMethod = json['payment_method'] ?? '',
        totalPrice = json['grand_total'];
}
