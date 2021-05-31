import 'dart:convert';

// import 'package:markaa/src/data/mock/regions.dart';
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
    Map<String, dynamic> regionsList = await Api.getMethod(EndPoints.getRegions, data: {"lang": Preload.language, "country_code": countryCode});
    //Map<String, dynamic> regionsList = Preload.language == 'en' ? enRegionsList : arRegionsList;
    List<RegionEntity> _regionsObjs = [];
    if (regionsList['code'] == 'SUCCESS') {
      regionsList['regions'].forEach((region) => _regionsObjs.add(RegionEntity.fromJson(region)));
    }
    return _regionsObjs;
  }
}
