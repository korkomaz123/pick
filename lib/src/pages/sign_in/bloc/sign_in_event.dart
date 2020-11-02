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
