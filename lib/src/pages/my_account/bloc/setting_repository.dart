import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class SettingRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<void> getNotificationSetting(String token) async {
    String url = EndPoints.getNotificationSetting;
    final params = {'token': token};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<void> changeNotificationSetting(String token, bool isActive) async {
    String url = EndPoints.changeNotificationSetting;
    final params = {'token': token, 'active': '$isActive'};
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getTerms(String lang) async {
    String url = EndPoints.getTerms;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getAboutUs(String lang) async {
    String url = EndPoints.getAboutus;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<void> submitContactUs(
    String name,
    String phone,
    String email,
    String comment,
  ) async {
    String url = EndPoints.submitContactUs;
    final params = {
      'name': name,
      'telephone': phone,
      'email': email,
      'comment': comment
    };
    return await Api.postMethod(url, data: params);
  }
}
