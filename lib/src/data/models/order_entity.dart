import 'package:markaa/src/data/models/cart_item_entity.dart';
import 'package:markaa/src/data/models/payment_method_entity.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/shipping_method_entity.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'address_entity.dart';
import 'enum.dart';

class OrderEntity {
  final String orderId;
  final String orderNo;
  final String orderDate;
  final OrderStatusEnum status;
  final String totalQty;
  final String totalPrice;
  final String subtotalPrice;
  final PaymentMethodEntity paymentMethod;
  final ShippingMethodEntity shippingMethod;
  final String cartId;
  final List<CartItemEntity> cartItems;
  final AddressEntity address;

  OrderEntity({
    this.orderId,
    this.orderNo,
    this.orderDate,
    this.status,
    this.totalQty,
    this.totalPrice,
    this.subtotalPrice,
    this.paymentMethod,
    this.shippingMethod,
    this.cartId,
    this.cartItems,
    this.address,
  });

  OrderEntity.fromJson(Map<String, dynamic> json)
      : orderId = json['entity_id'],
        orderNo = json['increment_id'],
        orderDate = json['created_at'],
        status = EnumToString.fromString(
          OrderStatusEnum.values,
          json['status'],
        ),
        totalQty = json['total_qty_ordered'],
        totalPrice = json['grand_total'],
        subtotalPrice = json['subtotal'],
        paymentMethod = PaymentMethodEntity(
          id: json['payment_code'],
          title: json['payment_method'],
        ),
        shippingMethod = ShippingMethodEntity(
          id: json['shipping_method'],
          description: json['shipping_description'],
          serviceFees: _getServiceFees(json),
        ),
        cartId = json['cartid'],
        cartItems = _getCartItems(json['products']),
        address = AddressEntity.fromJson(json['shippingAddress']);

  static int _getServiceFees(Map<String, dynamic> json) {
    String totalPriceStr = json['grand_total'];
    String subtotalPriceStr = json['subtotal'];
    int totalPrice = int.parse(double.parse(totalPriceStr).toStringAsFixed(0));
    int subtotalPrice =
        int.parse(double.parse(subtotalPriceStr).toStringAsFixed(0));
    return totalPrice - subtotalPrice;
  }

  static List<CartItemEntity> _getCartItems(List<dynamic> items) {
    return items.map((item) {
      Map<String, dynamic> itemJson = item;
      itemJson['product'] = ProductModel.fromJson(item['product']);
      itemJson['itemCount'] = item['item_count'];
      itemJson['itemCountCanceled'] = item['item_count_canceled'] ?? '0';
      itemJson['itemCountReturned'] = item['itemCountReturned'] ?? '0';
      itemJson['returnStatus'] = item['returnStatus'];
      itemJson['itemId'] = item['itemId'];
      itemJson['availableCount'] = 0;
      itemJson['rowPrice'] = 0;
      return CartItemEntity.fromJson(itemJson);
    }).toList();
  }
}
