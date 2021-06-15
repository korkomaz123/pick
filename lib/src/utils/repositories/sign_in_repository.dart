import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';

class SignInRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  String getFirebaseUser() {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser?.uid;
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<void> loginFirebase({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

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
    String phoneNumber,
    String email,
    String password,
  ) async {
    String url = EndPoints.register;
    final params = {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
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
    String appleId,
  ) async {
    String url = EndPoints.socialLogin;
    final params = {
      'email': email,
      'firstName': firstName ?? '',
      'lastName': lastName ?? '',
      'loginType': loginType,
      'lang': lang,
      'appleId': appleId ?? '',
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
    print(url);
    print(params);
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
