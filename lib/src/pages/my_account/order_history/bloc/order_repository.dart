import 'dart:convert';
import 'dart:typed_data';

import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';
import 'package:ciga/src/data/mock/mock.dart';

class OrderRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getOrderHistory(String token) async {
    String url = EndPoints.getOrderHistory;
    final params = {'token': token};
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
    return await Api.postMethod(url, data: params);
  }
}
