import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/src/data/models/cart_item_entity.dart';
import 'package:markaa/src/data/models/condition_entity.dart';
import 'package:markaa/src/data/models/payment_method_entity.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/shipping_method_entity.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';
import 'package:markaa/src/utils/services/string_service.dart';

import 'address_entity.dart';
import 'enum.dart';

class OrderEntity {
  String orderId;
  String orderNo;
  String orderDate;
  OrderStatusEnum status;
  String totalQty;
  String totalPrice;
  String subtotalPrice;
  double discountAmount;
  String discountType;
  PaymentMethodEntity paymentMethod;
  ShippingMethodEntity shippingMethod;
  String cartId;
  List<CartItemEntity> cartItems;
  AddressEntity address;
  List<ConditionEntity> productCondition;
  List<ConditionEntity> cartCondition;
  bool isProductConditionOkay;
  bool isCartConditionOkay;
  double discountPrice;

  OrderEntity({
    required this.orderId,
    required this.orderNo,
    required this.orderDate,
    required this.status,
    required this.totalQty,
    required this.totalPrice,
    required this.subtotalPrice,
    required this.discountAmount,
    required this.discountType,
    required this.paymentMethod,
    required this.shippingMethod,
    required this.cartId,
    required this.cartItems,
    required this.address,
    required this.productCondition,
    required this.cartCondition,
    required this.isCartConditionOkay,
    required this.isProductConditionOkay,
    required this.discountPrice,
  });

  OrderEntity.fromJson(Map<String, dynamic> json)
      : orderId = json['entity_id'],
        orderNo = json['increment_id'],
        orderDate = _covertLocalTime(json['created_at_timestamp']),
        status = EnumToString.fromString(
          OrderStatusEnum.values,
          json['status'],
        )!,
        totalQty = json['total_qty_ordered'],
        totalPrice = json['status'] == 'canceled'
            ? '0.000'
            : StringService.roundString(json['base_grand_total'], 3),
        subtotalPrice = StringService.roundString(json['base_subtotal'], 3),
        discountPrice = json.containsKey('discount_amount')
            ? StringService.roundDouble(json['discount_amount'], 3) * -1
            : 0,
        discountAmount = double.parse(
            json['discount'].isNotEmpty ? json['discount'] : '0.000'),
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
        address = AddressEntity.fromJson(json['shippingAddress']),
        cartCondition =
            json.containsKey('cart_condition') && json['cart_condition'] != ''
                ? _getCondition(json['cart_condition'])
                : [],
        productCondition = json.containsKey('product_condition') &&
                json['product_condition'] != ''
            ? _getCondition(json['product_condition'])
            : [],
        isProductConditionOkay = json.containsKey('product_condition') &&
                json['product_condition'] != ''
            ? json['product_condition']['value'] == '1'
            : true,
        isCartConditionOkay =
            json.containsKey('cart_condition') && json['cart_condition'] != ''
                ? json['cart_condition']['value'] == '1'
                : true;

  static String _covertLocalTime(int timestamp) {
    int milliseconds = timestamp * 1000;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    Duration timezone = DateTime.now().timeZoneOffset;
    DateTime convertedDateTime = dateTime.add(timezone);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(convertedDateTime);
  }

  static List<CartItemEntity> _getCartItems(List<dynamic>? items) {
    List<CartItemEntity> list = [];
    if (items != null) {
      for (var item in items) {
        Map<String, dynamic> itemJson = item;
        itemJson['product'] = ProductModel.fromJson(item['product']);
        itemJson['itemCount'] = item['item_count'];
        itemJson['itemCountCanceled'] = item['item_count_canceled'] ?? '0';
        itemJson['itemCountReturned'] = item['itemCountReturned'] ?? '0';
        itemJson['returnStatus'] = item['returnStatus'];
        itemJson['itemId'] = item['itemId'];
        itemJson['availableCount'] = 0;
        itemJson['rowPrice'] = 0;
        list.add(CartItemEntity.fromJson(itemJson));
      }
    }
    return list;
  }

  static List<ConditionEntity> _getCondition(dynamic condition) {
    List<ConditionEntity> cartConditions = [];
    List<dynamic> conditionsList = [];
    for (var productCondition in condition['conditions']) {
      if (productCondition.containsKey('conditions')) {
        conditionsList.addAll(productCondition['conditions']);
      } else {
        conditionsList.add(productCondition);
      }
    }
    for (var condition in conditionsList) {
      cartConditions.add(ConditionEntity.fromJson(condition));
    }

    return cartConditions;
  }

  double getDiscountedPrice(
    CartItemEntity item, {
    bool isRowPrice = true,
  }) {
    double price = .0;
    bool cartConditionMatched = true;
    for (var condition in cartCondition) {
      print(condition.attribute);
      if (condition.attribute == 'price' ||
          condition.attribute == 'special_price') {
        if (condition.attribute == 'price') {
          price = StringService.roundDouble(item.product.beforePrice!, 3);
        } else if (condition.attribute == 'special_price') {
          if (item.product.price == item.product.beforePrice)
            price = 0;
          else
            price = StringService.roundDouble(item.product.price, 3);
        }
        cartConditionMatched = condition.operator == '>='
            ? price >= double.parse(condition.value)
            : condition.operator == '>'
                ? price > double.parse(condition.value)
                : condition.operator == '<='
                    ? price <= double.parse(condition.value)
                    : price < double.parse(condition.value);
      } else if (condition.attribute == 'sku') {
        cartConditionMatched = condition.operator == '=='
            ? item.product.sku == condition.value
            : item.product.sku != condition.value;
      } else if (condition.attribute == 'manufacturer') {
        cartConditionMatched = condition.operator == '=='
            ? item.product.brandEntity!.optionId == condition.value
            : item.product.brandEntity!.optionId != condition.value;
      } else if (condition.attribute == 'category_ids') {
        List<String> values = condition.value.split(', ');
        cartConditionMatched = condition.operator == '=='
            ? values.any((value) =>
                item.product.categories!.contains(value) ||
                item.product.parentCategories!.contains(value))
            : !values.any((value) =>
                item.product.categories!.contains(value) ||
                item.product.parentCategories!.contains(value));
      }
    }
    bool productConditionMatched = true;
    for (var condition in productCondition) {
      if (condition.attribute == 'price' ||
          condition.attribute == 'special_price') {
        if (condition.attribute == 'price') {
          price = StringService.roundDouble(item.product.beforePrice!, 3);
        } else if (condition.attribute == 'special_price') {
          if (item.product.price == item.product.beforePrice)
            price = 0;
          else
            price = StringService.roundDouble(item.product.price, 3);
        }
        productConditionMatched = condition.operator == '>='
            ? price >= double.parse(condition.value)
            : condition.operator == '>'
                ? price > double.parse(condition.value)
                : condition.operator == '<='
                    ? price <= double.parse(condition.value)
                    : price < double.parse(condition.value);
      } else if (condition.attribute == 'sku') {
        productConditionMatched = condition.operator == '=='
            ? item.product.sku == condition.value
            : item.product.sku != condition.value;
      } else if (condition.attribute == 'manufacturer') {
        productConditionMatched = condition.operator == '=='
            ? item.product.brandEntity!.optionId == condition.value
            : item.product.brandEntity!.optionId != condition.value;
      } else if (condition.attribute == 'category_ids') {
        List<String> values = condition.value.split(', ');
        productConditionMatched = condition.operator == '=='
            ? values.any((value) =>
                item.product.categories!.contains(value) ||
                item.product.parentCategories!.contains(value))
            : !values.any((value) =>
                item.product.categories!.contains(value) ||
                item.product.parentCategories!.contains(value));
      }
    }
    bool isOkay = (cartConditionMatched == isCartConditionOkay) &&
        (productConditionMatched == isProductConditionOkay);
    if (isRowPrice) {
      return isOkay
          ? NumericService.roundDouble(
              item.rowPrice * (100 - discountAmount) / 100, 3)
          : item.rowPrice;
    } else {
      return isOkay
          ? NumericService.roundDouble(
              double.parse(item.product.price) * (100 - discountAmount) / 100,
              3)
          : StringService.roundDouble(item.product.price, 3);
    }
  }
}
