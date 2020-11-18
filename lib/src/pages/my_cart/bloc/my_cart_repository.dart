import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

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
  Future<dynamic> getCartItems(String cartId, String lang) async {
    String url = EndPoints.getCartItems;
    final params = {'cartId': cartId, 'lang': lang};
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
    print(params);
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
}
