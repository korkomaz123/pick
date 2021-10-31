part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileImageUpdatedInProcess extends ProfileState {}

class ProfileImageUpdatedSuccess extends ProfileState {
  final String url;

  ProfileImageUpdatedSuccess({required this.url});

  @override
  List<Object> get props => [url];
}

class ProfileImageUpdatedFailure extends ProfileState {
  final String message;

  ProfileImageUpdatedFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileInformationUpdatedInProcess extends ProfileState {}

class ProfileInformationUpdatedSuccess extends ProfileState {}

class ProfileInformationUpdatedFailure extends ProfileState {
  final String message;

  ProfileInformationUpdatedFailure({required this.message});

  @override
  List<Object> get props => [message];
}
