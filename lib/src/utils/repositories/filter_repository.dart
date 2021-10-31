import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';

class FilterRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getFilterAttributes(
    String categoryId,
    String brandId,
    String lang,
  ) async {
    String url = EndPoints.getFilterAttributes;
    final params = {
      'categoryId': categoryId == 'all' ? null : categoryId,
      'brandId': brandId == '' ? null : brandId,
      'lang': lang
    };
    print(url);
    print(params);
    return await Api.getMethod(url, data: params);
  }
}
