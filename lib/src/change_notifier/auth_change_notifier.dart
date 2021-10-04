import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/utils/repositories/sign_in_repository.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthChangeNotifier extends ChangeNotifier {
  final _signInRepository = SignInRepository();
  UserEntity currentUser;

  Future login(
    String email,
    String password, {
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      final result = await _signInRepository.login(email, password);
      if (result['code'] == 'SUCCESS') {
        result['user']['token'] = result['token'];
        result['user']['amount_wallet'] = result['user']['wallet'];
        currentUser = UserEntity.fromJson(result['user']);
        OneSignal.shared.sendTag('wallet', currentUser.balance);
        if (onSuccess != null) onSuccess(currentUser);
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure(e.toString());
    }
  }

  Future loginWithSocial(
    String email,
    String firstName,
    String lastName,
    String loginType,
    String lang, {
    String appleId,
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();

    try {
      final result = await _signInRepository.socialLogin(
          email, firstName, lastName, loginType, lang, appleId);
      if (result['code'] == 'SUCCESS') {
        result['user']['token'] = result['token'];
        result['user']['amount_wallet'] = result['user']['wallet'];
        currentUser = UserEntity.fromJson(result['user']);
        OneSignal.shared.sendTag('wallet', currentUser.balance);
        if (onSuccess != null) onSuccess(currentUser);
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure(e.toString());
    }
  }

  Future logout({
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();

    try {
      await _signInRepository.logout(currentUser.token);
      OneSignal.shared.sendTag('wallet', 0);
      currentUser = null;
      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onFailure != null) onFailure(e.toString());
    }
  }

  Future signUp(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String password, {
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();

    try {
      final result = await _signInRepository.register(
          firstName, lastName, phoneNumber, email, password);
      if (result['code'] == 'SUCCESS') {
        result['user']['token'] = result['token'];
        currentUser = UserEntity.fromJson(result['user']);
        OneSignal.shared.sendTag('wallet', currentUser.balance);
        if (onSuccess != null) onSuccess(currentUser);
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure(e.toString());
    }
  }

  Future requestNewPassword(
    String email, {
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();

    try {
      final result = await _signInRepository.getNewPassword(email);
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
