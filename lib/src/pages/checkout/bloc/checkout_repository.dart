import 'dart:convert';

import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';
import 'package:ciga/src/data/models/payment_method_entity.dart';
import 'package:ciga/src/data/models/shipping_method_entity.dart';

class CheckoutRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<ShippingMethodEntity>> getShippingMethod(String lang) async {
    String url = EndPoints.getShippingMethod;
    final data = {'lang': lang};
    final result = await Api.getMethod(url, data: data);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> shippingMethodList = result['data'];
      List<ShippingMethodEntity> methods = [];
      for (int i = 0; i < shippingMethodList.length; i++) {
        methods.add(ShippingMethodEntity.fromJson(shippingMethodList[i]));
      }
      return methods;
    } else {
      return <ShippingMethodEntity>[];
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<PaymentMethodEntity>> getPaymentMethod(String lang) async {
    String url = EndPoints.getPaymentMethod;
    final data = {'lang': lang};
    final result = await Api.getMethod(url, data: data);
    if (result['code'] == 'SUCCESS') {
      List<String> keys =
          (result['data'] as Map<String, dynamic>).keys.toList();
      List<PaymentMethodEntity> methods = [];
      for (int i = 0; i < keys.length; i++) {
        methods.add(PaymentMethodEntity.fromJson(result['data'][keys[i]]));
      }
      return methods;
    } else {
      return <PaymentMethodEntity>[];
    }
  }

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
}
