import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';

class BrandRepository {
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
}
