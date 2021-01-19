import 'dart:convert';
import 'dart:typed_data';

import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/mock/mock.dart';

class OrderRepository {
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
      'imageName': imageName,
      'lang': lang,
      'imageForProduct': product.toString(),
    };
    print(params);
    return await Api.postMethod(url, data: params);
  }
}
