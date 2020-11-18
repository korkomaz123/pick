import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';
import 'package:ciga/src/data/models/brand_entity.dart';

class BrandRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<BrandEntity>> getAllBrandsEntity() async {
    String url = EndPoints.getAllBrands;
    final result = await Api.getMethod(url);
    List<dynamic> data = result['brand'];
    return data.map((e) => BrandEntity.fromJson(e)).toList();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getAllBrands(String lang) async {
    String url = EndPoints.getAllBrands;
    final params = {'lang': lang};
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
}
