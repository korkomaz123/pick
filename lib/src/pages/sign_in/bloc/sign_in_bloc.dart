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
    }
  }

  Stream<SignInState> _mapSignInSubmittedToState(
    String email,
    String password,
  ) async* {
    yield SignInSubmittedInProcess();
    try {
      final result = await _signInRepository.login(email, password);
      if (result['code'] == 'error') {
        yield SignInSubmittedFailure(message: result['errorMessage']);
      } else {
        result['user']['token'] = result['token'];
        yield SignInSubmittedSuccess(user: UserEntity.fromJson(result['user']));
      }
    } catch (e) {
      yield SignInSubmittedFailure(message: e.toString());
    }
  }
}
