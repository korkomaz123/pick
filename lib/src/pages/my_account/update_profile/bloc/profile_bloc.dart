import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:markaa/src/utils/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(ProfileInitial());

  final ProfileRepository _profileRepository;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileImageUpdated) {
      yield* _mapProfileImageUpdatedToState(
        event.token,
        event.image,
        event.name,
      );
    } else if (event is ProfileInformationUpdated) {
      yield* _mapProfileInformationUpdatedToState(
        event.token,
        event.firstName,
        event.lastName,
        event.phoneNumber,
        event.email,
      );
    }
  }

  Stream<ProfileState> _mapProfileImageUpdatedToState(
    String token,
    Uint8List image,
    String name,
  ) async* {
    yield ProfileImageUpdatedInProcess();
    try {
      final result =
          await _profileRepository.updateProfileImage(token, image, name);

      if (result['code'] == 'SUCCESS') {
        String profileUrl = result['data']['profileUrl'];
        yield ProfileImageUpdatedSuccess(url: profileUrl);
      } else {
        yield ProfileImageUpdatedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      yield ProfileImageUpdatedFailure(message: e.toString());
    }
  }

  Stream<ProfileState> _mapProfileInformationUpdatedToState(
    String token,
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
  ) async* {
    yield ProfileInformationUpdatedInProcess();
    try {
      final result = await _profileRepository.updateProfile(
          token, firstName, lastName, phoneNumber, email);

      if (result['code'] == 'SUCCESS') {
        yield ProfileInformationUpdatedSuccess();
      } else {
        yield ProfileInformationUpdatedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      print(e.toString());
      yield ProfileInformationUpdatedFailure(message: e.toString());
    }
  }
}
