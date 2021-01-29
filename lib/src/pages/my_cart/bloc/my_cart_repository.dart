import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';

class MyCartRepository {
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
    // print(url);
    // print(params);
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getCartItems(String cartId, String lang) async {
    String url = EndPoints.getCartItems;
    final params = {'cartId': cartId, 'lang': lang};
    // print(url);
    // print(params);
    return await Api.postMethod(url, data: params);
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
  ) async {
    String url = EndPoints.getCartItems;
    final params = {
      'cartId': cartId,
      'productId': productId,
      'qty': qty,
      'type': 'add'
    };
    return await Api.postMethod(url, data: params);
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
    print(params);
    return await Api.postMethod(url, data: params);
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
