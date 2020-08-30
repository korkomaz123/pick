class OrderEntity {
  final String orderNo;
  final String orderDate;
  final String status;
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
