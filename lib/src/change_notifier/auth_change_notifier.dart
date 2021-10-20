import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/repositories/sign_in_repository.dart';

class AuthChangeNotifier extends ChangeNotifier {
  final _signInRepository = SignInRepository();
  final _localRepository = LocalStorageRepository();
  UserEntity? currentUser;

  Future getCurrentUser({
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    String token = await _localRepository.getToken();
    if (token.isNotEmpty) {
      SignInRepository signInRepo = SignInRepository();
      final result = await signInRepo.getCurrentUser(token);
      if (result['code'] == 'SUCCESS') {
        result['data']['customer']['token'] = token;
        result['data']['customer']['profileUrl'] = result['data']['profileUrl'];
        currentUser = UserEntity.fromJson(result['data']['customer']);
        if (onSuccess != null) onSuccess(currentUser);
      } else {
        currentUser = null;
        await _localRepository.removeToken();
        if (onFailure != null) onFailure();
      }
      notifyListeners();
    }
  }

  Future login(
    String email,
    String password, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      final result = await _signInRepository.login(email, password);
      if (result['code'] == 'SUCCESS') {
        result['user']['token'] = result['token'];
        result['user']['amount_wallet'] = result['user']['wallet'];
        currentUser = UserEntity.fromJson(result['user']);

        if (onSuccess != null) onSuccess(currentUser);
        notifyListeners();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
    }
  }

  Future loginWithSocial(
    String email,
    String firstName,
    String lastName,
    String loginType,
    String lang, {
    String? appleId,
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();

    try {
      final result = await _signInRepository.socialLogin(
          email, firstName, lastName, loginType, lang, appleId);
      if (result['code'] == 'SUCCESS') {
        result['user']['token'] = result['token'];
        result['user']['amount_wallet'] = result['user']['wallet'];
        currentUser = UserEntity.fromJson(result['user']);

        if (onSuccess != null) onSuccess(currentUser);
        notifyListeners();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      print('LOGIN WITH SOCIAL CATCH ERROR: $e');
      if (onFailure != null) onFailure('connection_error');
    }
  }

  Future logout({
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();

    try {
      await _signInRepository.logout(currentUser!.token);
      currentUser = null;

      if (onSuccess != null) onSuccess();
      notifyListeners();
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
    }
  }

  Future signUp(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String password, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();

    try {
      final result = await _signInRepository.register(
          firstName, lastName, phoneNumber, email, password);
      if (result['code'] == 'SUCCESS') {
        result['user']['token'] = result['token'];
        currentUser = UserEntity.fromJson(result['user']);

        if (onSuccess != null) onSuccess(currentUser);
        notifyListeners();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
    }
  }

  Future requestNewPassword(
    String email, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
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
      if (onFailure != null) onFailure('connection_error');
    }
  }

  updateUserEntity(entity) {
    currentUser = entity;
    notifyListeners();
  }
}
