import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class FilterRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getFilterAttributes(String categoryId, String lang) async {
    String url = EndPoints.getFilterAttributes;
    final params = {'categoryId': categoryId, 'lang': lang};
    return await Api.getMethod(url, data: params);
  }
}
