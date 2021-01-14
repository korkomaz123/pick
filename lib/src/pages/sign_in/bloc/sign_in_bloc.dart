import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'sign_in_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({@required SignInRepository signInRepository})
      : assert(signInRepository != null),
        _signInRepository = signInRepository,
        super(SignInInitial());

  final SignInRepository _signInRepository;

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is SignInSubmitted) {
      yield* _mapSignInSubmittedToState(event.email, event.password);
    } else if (event is SignOutSubmitted) {
      yield* _mapSignOutSubmittedToState(event.token);
    } else if (event is SocialSignInSubmitted) {
      yield* _mapSocialSignInSubmittedToState(
        event.email,
        event.firstName,
        event.lastName,
        event.loginType,
        event.lang,
      );
    } else if (event is SignUpSubmitted) {
      yield* _mapSignUpSubmittedToState(
        event.firstName,
        event.lastName,
        event.email,
        event.password,
      );
    } else if (event is NewPasswordRequestSubmitted) {
      yield* _mapNewPasswordRequestSubmittedToState(event.email);
    }
  }

  Stream<SignInState> _mapSignInSubmittedToState(
    String email,
    String password,
  ) async* {
    yield SignInSubmittedInProcess();
    try {
      final result = await _signInRepository.login(email, password);
      // print(result);
      if (result['code'] == 'SUCCESS') {
        result['user']['token'] = result['token'];
        yield SignInSubmittedSuccess(user: UserEntity.fromJson(result['user']));
      } else {
        yield SignInSubmittedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      yield SignInSubmittedFailure(message: e.toString());
    }
  }

  Stream<SignInState> _mapSignOutSubmittedToState(String token) async* {
    yield SignOutSubmittedInProcess();
    try {
      await _signInRepository.logout(token);
      yield SignOutSubmittedSuccess();
    } catch (e) {
      yield SignOutSubmittedFailure(message: e.toString());
    }
  }

  Stream<SignInState> _mapSocialSignInSubmittedToState(
    String email,
    String firstName,
    String lastName,
    String loginType,
    String lang,
  ) async* {
    yield SignInSubmittedInProcess();
    try {
      final result = await _signInRepository.socialLogin(
          email, firstName, lastName, loginType, lang);
      // print(result);
      if (result['code'] == 'SUCCESS') {
        result['user']['token'] = result['token'];
        yield SignInSubmittedSuccess(user: UserEntity.fromJson(result['user']));
      } else {
        yield SignInSubmittedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield SignInSubmittedFailure(message: e.toString());
    }
  }

  Stream<SignInState> _mapSignUpSubmittedToState(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async* {
    yield SignUpSubmittedInProcess();
    try {
      final result = await _signInRepository.register(
          firstName, lastName, email, password);
      // print(result);
      if (result['code'] == 'SUCCESS') {
        result['user']['token'] = result['token'];
        yield SignUpSubmittedSuccess(user: UserEntity.fromJson(result['user']));
      } else {
        yield SignUpSubmittedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      yield SignUpSubmittedFailure(message: e.toString());
    }
  }

  Stream<SignInState> _mapNewPasswordRequestSubmittedToState(
    String email,
  ) async* {
    yield NewPasswordRequestSubmittedInProcess();
    try {
      final result = await _signInRepository.getNewPassword(email);
      if (result['code'] == 'SUCCESS') {
        yield NewPasswordRequestSubmittedSuccess();
      } else {
        yield NewPasswordRequestSubmittedFailure(
          message: result['errMessage'],
        );
      }
    } catch (e) {
      yield NewPasswordRequestSubmittedFailure(message: e.toString());
    }
  }
}
