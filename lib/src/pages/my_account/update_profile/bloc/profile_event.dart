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

  ProfileImageUpdated({
    required this.token,
    required this.image,
    required this.name,
  });

  @override
  List<Object> get props => [token, image, name];
}

class ProfileInformationUpdated extends ProfileEvent {
  final String token;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;

  ProfileInformationUpdated({
    required this.token,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
  });

  @override
  List<Object> get props => [token, firstName, lastName, phoneNumber, email];
}
