part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileImageUpdated extends ProfileEvent {
  final String token;
  final Uint8List image;

  ProfileImageUpdated({this.token, this.image});

  @override
  List<Object> get props => [token, image];
}

class ProfileInformationUpdated extends ProfileEvent {
  final String token;
  final String firstName;
  final String lastName;

  ProfileInformationUpdated({
    this.token,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object> get props => [token, firstName, lastName];
}
