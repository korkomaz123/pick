import 'dart:convert';

import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/models/condition_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';

class MyCartRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> activateCart(String cartId) async {
    String url = EndPoints.activateCart;
    final params = {'cartId': cartId};

    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> createCart() async {
    String url = EndPoints.createCart;
    // final params = {};
    return await Api.postMethod(url);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getCartId(String token) async {
    String url = EndPoints.createCart;
    final params = {'token': token};

    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getCartItems(String cartId, String lang) async {
    String url = EndPoints.getCartItems;
    final params = {'cartId': cartId, 'lang': lang};
    final result = await Api.postMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> cartList = result['cart'];
      List<CartItemEntity> cartItems = [];
      for (int i = 0; i < cartList.length; i++) {
        Map<String, dynamic> cartItemJson = {};
        cartItemJson['product'] = ProductModel.fromJson(cartList[i]['product']);
        cartItemJson['itemCount'] = cartList[i]['itemCount'];
        cartItemJson['rowPrice'] = cartList[i]['row_price'];
        cartItemJson['itemId'] = cartList[i]['itemid'];
        cartItemJson['availableCount'] = cartList[i]['availableCount'];
        cartItems.add(CartItemEntity.fromJson(cartItemJson));
      }
      List<ConditionEntity> cartConditions = [];
      List<ConditionEntity> productConditions = [];
      bool isCartConditionOkay = true;
      bool isProductConditionOkay = true;
      List<dynamic> cartConditionsList = [];
      List<dynamic> productConditionsList = [];
      if (result.containsKey('cart_condition') &&
          result['cart_condition'] != '') {
        isCartConditionOkay = result['cart_condition']['value'] == '1';
        for (var cartCondition in result['cart_condition']['conditions']) {
          if (cartCondition.containsKey('conditions')) {
            cartConditionsList.addAll(cartCondition['conditions']);
          } else {
            cartConditionsList.add(cartCondition);
          }
        }
      }
      if (result.containsKey('product_condition') &&
          result['product_condition'] != '') {
        isProductConditionOkay = result['product_condition']['value'] == '1';
        for (var productCondition in result['product_condition']
            ['conditions']) {
          if (productCondition.containsKey('conditions')) {
            productConditionsList.addAll(productCondition['conditions']);
          } else {
            productConditionsList.add(productCondition);
          }
        }
      }
      for (var condition in cartConditionsList) {
        cartConditions.add(ConditionEntity.fromJson(condition));
      }
      for (var condition in productConditionsList) {
        productConditions.add(ConditionEntity.fromJson(condition));
      }
      return {
        'code': 'SUCCESS',
        'items': cartItems,
        'couponCode': result['coupon_code'] ?? '',
        'discount': result['discount'],
        'type': result['type'],
        'cartCondition': cartConditions,
        'productCondition': productConditions,
        'isCartConditionOkay': isCartConditionOkay,
        'isProductConditionOkay': isProductConditionOkay
      };
    }
    return result;
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> clearCartItems(String cartId) async {
    String url = EndPoints.clearMyCartItems;
    final params = {'cartId': cartId};
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> addCartItem(
    String cartId,
    String productId,
    String qty,
    String lang,
    Map<String, dynamic> options,
  ) async {
    String url = EndPoints.addCartItem;
    final params = {
      'cartId': cartId,
      'productId': productId,
      'qty': qty,
      'lang': lang,
      'option': jsonEncode(options),
    };
    final result = await Api.postMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      final item = result['cart'][0];
      Map<String, dynamic> cartItemJson = {};
      cartItemJson['product'] = ProductModel.fromJson(item['product']);
      cartItemJson['itemCount'] = item['itemCount'];
      cartItemJson['rowPrice'] = item['row_price'];
      cartItemJson['itemId'] = item['itemid'];
      cartItemJson['availableCount'] = item['availableCount'];
      return {
        'code': 'SUCCESS',
        'item': CartItemEntity.fromJson(cartItemJson),
      };
    }
    return result;
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> updateCartItem(
    String cartId,
    String itemId,
    String qty,
  ) async {
    String url = EndPoints.getCartItems;
    final params = {
      'cartId': cartId,
      'itemId': itemId,
      'qty': qty,
      'type': 'edit'
    };
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> deleteCartItem(String cartId, String itemId) async {
    String url = EndPoints.getCartItems;
    final params = {'cartId': cartId, 'itemId': itemId, 'type': 'delete'};
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> couponCode(
    String cartId,
    String couponCode,
    String remove,
  ) async {
    String url = EndPoints.applyCouponCode;
    final params = {
      'cartId': cartId,
      'coupon_code': couponCode,
      'remove': remove
    };
    final result = await Api.postMethod(url, data: params);
    if (remove == '0' && result['code'] == 'SUCCESS') {
      List<ConditionEntity> cartConditions = [];
      List<ConditionEntity> productConditions = [];
      bool isCartConditionOkay = true;
      bool isProductConditionOkay = true;
      List<dynamic> cartConditionsList = [];
      List<dynamic> productConditionsList = [];
      if (result.containsKey('cart_condition') &&
          result['cart_condition'] != '') {
        isCartConditionOkay = result['cart_condition']['value'] == '1';
        for (var cartCondition in result['cart_condition']['conditions']) {
          if (cartCondition.containsKey('conditions')) {
            cartConditionsList.addAll(cartCondition['conditions']);
          } else {
            cartConditionsList.add(cartCondition);
          }
        }
      }
      if (result.containsKey('product_condition') &&
          result['product_condition'] != '') {
        isProductConditionOkay = result['product_condition']['value'] == '1';
        for (var productCondition in result['product_condition']
            ['conditions']) {
          if (productCondition.containsKey('conditions')) {
            productConditionsList.addAll(productCondition['conditions']);
          } else {
            productConditionsList.add(productCondition);
          }
        }
      }
      for (var condition in cartConditionsList) {
        cartConditions.add(ConditionEntity.fromJson(condition));
      }
      for (var condition in productConditionsList) {
        productConditions.add(ConditionEntity.fromJson(condition));
      }
      return {
        ...result,
        'cartCondition': cartConditions,
        'productCondition': productConditions,
        'isCartConditionOkay': isCartConditionOkay,
        'isProductConditionOkay': isProductConditionOkay
      };
    }
    return result;
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getReorderCartId(String orderId, String lang) async {
    String url = EndPoints.getReorderCartId;
    final params = {'orderId': orderId, 'lang': lang};
    final result = await Api.postMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      return result['cartId'];
    } else {
      return '';
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<int> getProductAvailableCount(String productId) async {
    String url = EndPoints.getProductAvailableCount;
    final params = {'productId': productId};
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      return result['availableCount'];
    } else {
      return 0;
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<bool> transferCart(String viewerCartId, String customerCartId) async {
    String url = EndPoints.transferCart;
    final params = {
      'viewerCartId': viewerCartId,
      'customerCartId': customerCartId,
    };
    final result = await Api.postMethod(url, data: params);
    return result['code'] == 'SUCCESS';
  }
}
