import 'dart:convert';
import 'dart:typed_data';

import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/mock/mock.dart';

class OrderRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> sendAsGift(
    String token,
    String sender,
    String receiver,
    String message,
  ) async {
    String url = EndPoints.sendAsGift;
    Map<String, dynamic> data = {
      'token': token,
      'sender': sender,
      'receiver': receiver,
      'message': message,
    };
    final result = await Api.postMethod(url, data: data);

    return result;
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> placeOrder(
    Map<String, dynamic> orderDetails,
    String lang,
    String isVirtual,
  ) async {
    String url = EndPoints.placeOrder;
    Map<String, dynamic> data = orderDetails.map((key, value) => MapEntry(key, value));
    data['orderDetails'] = jsonEncode(orderDetails['orderDetails']);
    data['lang'] = lang;
    data['is_virtual'] = isVirtual;
    final result = await Api.postMethod(url, data: data);

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
  Future<dynamic> cancelOrderById(String orderId, String lang) async {
    String url = EndPoints.cancelOrderById;
    final params = {'orderId': orderId, 'lang': lang};

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
    Uint8List? product,
    String? imageName,
  ) async {
    String url = EndPoints.cancelOrder;
    final params = {
      'token': user!.token,
      'orderId': orderId,
      'items': json.encode(items),
      'reason': reason,
      'imageName': imageName!,
      'lang': lang,
      'imageForProduct': base64Encode(product!),
    };
    // print(params);
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
    Uint8List? product,
    String? imageName,
  ) async {
    String url = EndPoints.returnOrder;
    final params = {
      'token': token,
      'orderId': orderId,
      'items': json.encode(items),
      'reason': reason,
      'imageName': imageName!,
      'lang': lang,
      'imageForProduct': base64Encode(product!),
    };
    print(params);
    return await Api.postMethod(url, data: params);
  }
}
