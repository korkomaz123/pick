import 'dart:convert';

import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/models/payment_method_entity.dart';
import 'package:markaa/src/data/models/shipping_method_entity.dart';

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
  Future<dynamic> tapPaymentCheckout(
    Map<String, dynamic> data,
    String lang,
  ) async {
    String url = 'https://api.tap.company/v2/charges';

    /// test: sk_test_Bh6kvFjzUfPrSIMVHA0ONJ7n
    /// live: sk_live_wZnUtOjFgAIWi0S6fxvleHoa
    Map<String, String> headers = {
      'Authorization': 'Bearer sk_live_wZnUtOjFgAIWi0S6fxvleHoa',
      'lang_code': lang,
      'Content-Type': 'application/json'
    };
    return Api.postMethod(url, data: data, headers: headers);
  }
}
