import 'dart:convert';
import 'dart:typed_data';

import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class ProfileRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> updateProfileImage(
    String token,
    Uint8List image,
    String name,
  ) async {
    String url = EndPoints.updateProfileImage;
    final params = {'token': token, 'image': base64Encode(image), 'name': name};
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> updateProfile(
    String token,
    String firstName,
    String lastName,
  ) async {
    String url = EndPoints.updateProfile;
    final params = {
      'token': token,
      'firstName': firstName,
      'lastName': lastName
    };
    return await Api.postMethod(url, data: params);
  }
}
