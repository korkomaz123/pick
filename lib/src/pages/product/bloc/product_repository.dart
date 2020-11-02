import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class ProductRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getProducts(String categoryId, String lang) async {
    String url = EndPoints.getCategoryProducts;
    final params = {'categoryId': categoryId, 'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> sortProducts(
    String categoryId,
    String sortItem,
    String lang,
  ) async {
    String url = EndPoints.getSortedProducts;
    final params = {
      'currentCategoryId': categoryId,
      'lang': lang,
      'sortItem': sortItem,
    };
    return await Api.getMethod(url, data: params);
  }
}
