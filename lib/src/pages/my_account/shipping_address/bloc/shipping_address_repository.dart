import 'dart:convert';

import 'package:markaa/src/data/models/region_entity.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';

class ShippingAddressRepository {
  //////////////////////////////////////////////////////////////////////////////
  /// [GET SHIPPING ADDRESSES LIST]
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getShippingAddresses(String token) async {
    String url = EndPoints.getMyShippingAddresses;
    final params = {'token': token};
    print(params);
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  /// [ADD SHIPPING ADDRESS]
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
        'isdefaultbilling': '1',
        'isdefaultshipping': '1'
      }),
    };
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  /// [DELETE SHIPPING ADDRESS]
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> deleteShippingAddress(String token, String addressId) async {
    String url = EndPoints.deleteShippingAddress;
    final params = {'token': token, 'address_id': addressId};
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  /// [UPDATE SHIPPING ADDRESS]
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

  //////////////////////////////////////////////////////////////////////////////
  /// [GET REGIONS LIST]
  //////////////////////////////////////////////////////////////////////////////
  Future<List<RegionEntity>> getRegions(
    String lang, [
    String countryCode = 'KW',
  ]) async {
    String url = EndPoints.getRegions;
    final params = {'lang': lang, 'country_code': countryCode};
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> regionsList = result['regions'];
      List<RegionEntity> regions = [];
      regions =
          regionsList.map((region) => RegionEntity.fromJson(region)).toList();
      return regions;
    } else {
      return <RegionEntity>[];
    }
  }
}
