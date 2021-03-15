import 'package:easy_localization/easy_localization.dart';
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
  final double discountAmount;
  final String discountType;
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
    this.discountAmount,
    this.discountType,
    this.paymentMethod,
    this.shippingMethod,
    this.cartId,
    this.cartItems,
    this.address,
  });

  OrderEntity.fromJson(Map<String, dynamic> json)
      : orderId = json['entity_id'],
        orderNo = json['increment_id'],
        orderDate = _covertLocalTime(json['created_at_timestamp']),
        status = EnumToString.fromString(
          OrderStatusEnum.values,
          json['status'],
        ),
        totalQty = json['total_qty_ordered'],
        totalPrice = json['status'] == 'canceled'
            ? '0.00'
            : _getFormattedValue(json['base_grand_total']),
        subtotalPrice = _getFormattedValue(json['base_subtotal']),
        discountAmount = double.parse(
            json['discount'].isNotEmpty ? json['discount'] : '0.00'),
        discountType = json['discount_type'],
        paymentMethod = PaymentMethodEntity(
          id: json['payment_code'],
          title: json['payment_method'],
        ),
        shippingMethod = ShippingMethodEntity(
          id: json['shipping_method'],
          description: json['shipping_description'],
          serviceFees: double.parse(json['base_shipping_amount']),
        ),
        cartId = json['cartid'],
        cartItems = _getCartItems(json['products']),
        address = AddressEntity.fromJson(json['shippingAddress']);

  static String _covertLocalTime(int timestamp) {
    int milliseconds = timestamp * 1000;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    Duration timezone = DateTime.now().timeZoneOffset;
    DateTime convertedDateTime = dateTime.add(timezone);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(convertedDateTime);
  }

  static String _getFormattedValue(String value) {
    double price = double.parse(value);
    return price.toStringAsFixed(2);
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
