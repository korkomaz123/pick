part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileImageUpdated extends ProfileEvent {
  final String token;
  final Uint8List image;
  final String name;

  ProfileImageUpdated({this.token, this.image, this.name});

  @override
  List<Object> get props => [token, image, name];
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
