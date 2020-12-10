import 'dart:convert';

import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class ShippingAddressRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getShippingAddresses(String token) async {
    String url = EndPoints.getMyShippingAddresses;
    final params = {'token': token};
    print(params);
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> addShippingAddress(
    String token,
    String title,
    String firstName,
    String lastName,
    String countryId,
    String region,
    String city,
    String streetName,
    String zipCode,
    String phoneNumber,
    String company,
    String email,
  ) async {
    String url = EndPoints.addShippingAddress;
    final params = {
      'token': token,
      'address': json.encode({
        'prefix': title,
        'firstname': firstName,
        'lastname': lastName,
        'country_id': countryId,
        'region': region,
        'city': city,
        'street': streetName,
        'post_code': zipCode,
        'telephone': phoneNumber,
        'company': company,
        'email': email,
        'isdefaultbilling': '0',
        'isdefaultshipping': '0'
      }),
    };
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> deleteShippingAddress(String token, String addressId) async {
    String url = EndPoints.deleteShippingAddress;
    final params = {'token': token, 'address_id': addressId};
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> updateShippingAddress(
    String token,
    String title,
    String addressId,
    String firstName,
    String lastName,
    String countryId,
    String region,
    String city,
    String streetName,
    String zipCode,
    String phoneNumber,
    String company,
    String email,
    String isDefaultBilling,
    String isDefaultShipping,
  ) async {
    String url = EndPoints.updateShippingAddress;
    final params = {
      'token': token,
      'address': json.encode({
        'prefix': title,
        'addressId': addressId,
        'firstname': firstName,
        'lastname': lastName,
        'country_id': countryId,
        'region': region,
        'city': city,
        'street': streetName,
        'post_code': zipCode,
        'telephone': phoneNumber,
        'company': company,
        'email': email,
        'isdefaultbilling': isDefaultBilling,
        'isdefaultshipping': isDefaultShipping
      }),
    };
    return await Api.postMethod(url, data: params);
  }
}
