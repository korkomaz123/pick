import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class OrderRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getOrderHistory(String token) async {
    String url = EndPoints.getOrderHistory;
    final params = {'token': token};
    return await Api.postMethod(url, data: params);
  }
}
