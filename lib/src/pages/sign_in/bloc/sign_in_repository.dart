import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class SignInRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> login(String email, String password) async {
    String url = EndPoints.login;
    final params = {'username': email, 'password': password};
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> logout(String token) async {
    String url = EndPoints.logout;
    final params = {'token': token};
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getCurrentUser(String token) async {
    String url = EndPoints.getCurrentUser;
    final params = {'token': token};
    return await Api.postMethod(url, data: params);
  }
}
