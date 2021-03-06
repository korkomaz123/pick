import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';

class SettingRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<bool> getNotificationSetting(String token) async {
    String url = EndPoints.getNotificationSetting;
    final params = {'token': token};
    final result = await Api.postMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      return result['status'] == 'true';
    } else {
      return false;
    }
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

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> updatePassword(
    String token,
    String oldPassword,
    String newPassword,
  ) async {
    String url = EndPoints.updatePassword;
    final params = {
      'token': token,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> updateFcmDeviceToken(
    String token,
    String aToken,
    String iToken,
    String aLang,
    String iLang,
  ) async {
    String url = EndPoints.updateDeviceToken;
    final params = {
      'token': token,
      'android_token': aToken,
      'ios_token': iToken,
      'android_lang': aLang,
      'ios_lang': iLang,
    };
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> updateGuestFcmToken(
    String deviceId,
    String token,
    String lang,
  ) async {
    String url = EndPoints.updateGuestFcmToken;
    final params = {
      'device_id': deviceId,
      'token': token,
      'lang': lang,
    };
    print(params);
    return await Api.postMethod(url, data: params);
  }
}
