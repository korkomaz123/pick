import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/profile_repository.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';

class AccountChangeNotifier extends ChangeNotifier {
  ProfileRepository _profileRepository = ProfileRepository();
  SettingRepository _settingRepository = SettingRepository();

  Future<void> updateProfileImage(
    String token,
    Uint8List imageData,
    String imageName, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      final result = await _profileRepository.updateProfileImage(
          token, imageData, imageName);
      if (result['code'] == 'SUCCESS') {
        String profileUrl = result['data']['profileUrl'];
        if (onSuccess != null) onSuccess(profileUrl);
        notifyListeners();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure(e.toString());
    }
  }

  Future<void> updateProfileInfo(
    String token,
    String firstName,
    String lastName,
    String phoneNumber,
    String email, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      final result = await _profileRepository.updateProfile(
          token, firstName, lastName, phoneNumber, email);
      if (result['code'] == 'SUCCESS') {
        if (onSuccess != null) onSuccess();
        notifyListeners();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure(e.toString());
    }
  }

  Future<void> contactSupport(
    String name,
    String phone,
    String email,
    String comment, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      await _settingRepository.submitContactUs(name, phone, email, comment);
      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onFailure != null) onFailure(e.toString());
    }
  }

  Future<void> updatePassword(
    String token,
    String oldPassword,
    String newPassword, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      final result = await _settingRepository.updatePassword(
          token, oldPassword, newPassword);
      if (result['code'] == 'SUCCESS') {
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure(e.toString());
    }
  }
}
