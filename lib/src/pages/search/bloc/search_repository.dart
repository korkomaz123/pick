import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class SearchRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<dynamic>> getGenderOptions() async {
    final String url = EndPoints.getGenderOptions;
    final result = await Api.getMethod(url);
    if (result['code'] == 'SUCCESS') {
      return result['data'];
    } else {
      return [];
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> searchProducts(
    String query,
    String categories,
    String brands,
    String genders,
    String lang,
  ) async {
    final String url = EndPoints.getSearchedProducts;
    final params = {
      'q': query,
      'categories': categories,
      'brands': brands,
      'gender': genders,
      'lang': lang,
    };
    return await Api.getMethod(url, data: params);
  }
}
