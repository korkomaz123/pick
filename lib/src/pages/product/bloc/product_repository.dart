import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class ProductRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getProducts(String categoryId, String lang) async {
    String url = EndPoints.getSubCategories;
    final params = {'categoryId': categoryId, 'lang': lang};
    return await Api.getMethod(url, data: params);
  }
}
