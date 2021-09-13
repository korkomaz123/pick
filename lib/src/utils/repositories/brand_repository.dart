import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/models/brand_entity.dart';

class BrandRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getBrand(String id, String lang) async {
    String url = EndPoints.getBrand;
    final params = {'brandId': id, 'lang': lang};
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      return BrandEntity.fromJson(result['brand']);
    }
    return null;
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getAllBrands(String lang, String from) async {
    String url = EndPoints.getAllBrands;
    final params = {'lang': lang, 'from': from};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getBrandCategories(String brandId, String lang) async {
    final params = {'brandId': brandId, 'lang': lang};
    String url = EndPoints.getBrandCategories;
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getBrandsOnSale(String lang) async {
    final params = {'lang': lang};
    String url = EndPoints.getBrandsOnSale;

    List<BrandEntity> list = [];
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      Map<String, dynamic> data = result['brands'];
      for (var key in data.keys.toList()) {
        list.add(BrandEntity.fromJson(data[key]));
      }
    }
    return {'list': list, 'title': result['title']};
  }
}
