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
  Future<dynamic> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    String url = EndPoints.register;
    final params = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'agreeTerms': 'true',
    };
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> socialLogin(
    String email,
    String firstName,
    String lastName,
    String loginType,
    String lang,
  ) async {
    String url = EndPoints.socialLogin;
    final params = {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'loginType': loginType,
      'lang': lang,
    };
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

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getNewPassword(String email) async {
    String url = EndPoints.getNewPassword;
    final params = {'email': email};
    return await Api.getMethod(url, data: params);
  }
}
