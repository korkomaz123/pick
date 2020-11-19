part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInSubmitted extends SignInEvent {
  final String email;
  final String password;

  SignInSubmitted({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class SocialSignInSubmitted extends SignInEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String loginType;
  final String lang;

  SocialSignInSubmitted({
    this.firstName,
    this.lastName,
    this.email,
    this.loginType,
    this.lang,
  });

  @override
  List<Object> get props => [firstName, lastName, email, loginType, lang];
}

class SignOutSubmitted extends SignInEvent {
  final String token;

  SignOutSubmitted({this.token});

  @override
  List<Object> get props => [token];
}

class SignUpSubmitted extends SignInEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  SignUpSubmitted({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
  });

  @override
  List<Object> get props => [firstName, lastName, email, password];
}

class NewPasswordRequestSubmitted extends SignInEvent {
  final String email;

  NewPasswordRequestSubmitted({this.email});

  @override
  List<Object> get props => [email];
}
