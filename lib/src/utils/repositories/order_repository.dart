import 'dart:convert';
import 'dart:typed_data';

import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/mock/mock.dart';

class OrderRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> placeOrder(
    Map<String, dynamic> orderDetails,
    String lang,
  ) async {
    String url = EndPoints.submitOrder;
    Map<String, dynamic> params = {};
    params['orderAddress'] = orderDetails['orderAddress'];
    params['token'] = orderDetails['token'];
    params['shipping'] = orderDetails['shipping'];
    params['paymentMethod'] = orderDetails['paymentMethod'];
    params['lang'] = lang;
    params['cartId'] = orderDetails['cartId'];
    params['orderDetails'] = json.encode(orderDetails['orderDetails']);
    print(params);
    final result = await Api.postMethod(url, data: params);
    return result;
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getOrderHistory(String token, String lang) async {
    String url = EndPoints.getOrderHistory;
    final params = {'token': token, 'lang': lang};
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> cancelOrder(
    String orderId,
    List<Map<String, dynamic>> items,
    String additionalInfo,
    String reason,
    Uint8List product,
    String imageName,
  ) async {
    String url = EndPoints.cancelOrder;
    final params = {
      'token': user.token,
      'orderId': orderId,
      'items': json.encode(items),
      'reason': reason,
      'imageName': imageName ?? '',
      'lang': lang,
      'imageForProduct': imageName != null ? base64Encode(product) : '',
    };
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> returnOrder(
    String token,
    String orderId,
    List<Map<String, dynamic>> items,
    String additionalInfo,
    String reason,
    Uint8List product,
    String imageName,
  ) async {
    String url = EndPoints.returnOrder;
    final params = {
      'token': token,
      'orderId': orderId,
      'items': json.encode(items),
      'reason': reason,
      'imageName': imageName ?? '',
      'lang': lang,
      'imageForProduct': imageName != null ? base64Encode(product) : '',
    };
    print(params);
    return await Api.postMethod(url, data: params);
  }
}
