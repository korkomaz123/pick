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
    }
  }

  Stream<SignInState> _mapSignInSubmittedToState(
    String email,
    String password,
  ) async* {
    yield SignInSubmittedInProcess();
    try {
      final result = await _signInRepository.login(email, password);
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
      print(result);
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
}
