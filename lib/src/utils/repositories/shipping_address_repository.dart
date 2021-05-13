import 'dart:convert';

import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/data/models/region_entity.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';

import '../../../preload.dart';

class ShippingAddressRepository {
  //////////////////////////////////////////////////////////////////////////////
  /// [GET SHIPPING ADDRESSES LIST]
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getAddresses(String token) async {
    String url = EndPoints.getMyShippingAddresses;
    final params = {'token': token};
    print(params);
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  /// [ADD SHIPPING ADDRESS]
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> addAddress(
    String token,
    AddressEntity newAddress,
  ) async {
    String url = EndPoints.addShippingAddress;
    final params = {
      'token': token,
      'address': jsonEncode(newAddress.toJson()),
    };
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  /// [DELETE SHIPPING ADDRESS]
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> deleteAddress(String token, String addressId) async {
    String url = EndPoints.deleteShippingAddress;
    final params = {'token': token, 'address_id': addressId};
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  /// [UPDATE SHIPPING ADDRESS]
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> updateAddress(
    String token,
    AddressEntity updateAddress,
  ) async {
    String url = EndPoints.updateShippingAddress;
    final params = {
      'token': token,
      'address': jsonEncode(updateAddress.toJson()),
    };
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  /// [GET REGIONS LIST]
  //////////////////////////////////////////////////////////////////////////////
  Future<List<RegionEntity>> getRegions([
    String countryCode = 'KW',
  ]) async {
    String url = EndPoints.getRegions;
    final params = {'lang': Preload.language, 'country_code': countryCode};
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
