import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class CategoryRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getSubCategories(String categoryId, String lang) async {
    final params = {'categoryId': categoryId, 'lang': lang};
    String url = EndPoints.getSubCategories;
    return await Api.getMethod(url, data: params);
  }
}
