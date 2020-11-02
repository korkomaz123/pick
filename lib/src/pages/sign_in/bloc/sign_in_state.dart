part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInSubmittedInProcess extends SignInState {}

class SignInSubmittedSuccess extends SignInState {
  final UserEntity user;

  SignInSubmittedSuccess({this.user});

  @override
  List<Object> get props => [user];
}

class SignInSubmittedFailure extends SignInState {
  final String message;

  SignInSubmittedFailure({this.message});

  @override
  List<Object> get props => [message];
}

class SocialSignInSubmittedInProcess extends SignInState {}

class SocialSignInSubmittedSuccess extends SignInState {
  final UserEntity user;

  SocialSignInSubmittedSuccess({this.user});

  @override
  List<Object> get props => [user];
}

class SocialSignInSubmittedFailure extends SignInState {
  final String message;

  SocialSignInSubmittedFailure({this.message});

  @override
  List<Object> get props => [message];
}
