import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({@required ProfileRepository profileRepository})
      : assert(profileRepository != null),
        _profileRepository = profileRepository,
        super(ProfileInitial());

  final ProfileRepository _profileRepository;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileImageUpdated) {
      yield* _mapProfileImageUpdatedToState(event.token, event.image);
    } else if (event is ProfileInformationUpdated) {
      yield* _mapProfileInformationUpdatedToState(
        event.token,
        event.firstName,
        event.lastName,
      );
    }
  }

  Stream<ProfileState> _mapProfileImageUpdatedToState(
    String token,
    Uint8List image,
  ) async* {
    yield ProfileImageUpdatedInProcess();
    try {
      final result = await _profileRepository.updateProfileImage(token, image);
      if (result['code'] == 'SUCCESS') {
        String profileUrl = result['data']['profileUrl'];
        yield ProfileImageUpdatedSuccess(url: profileUrl);
      } else {
        yield ProfileImageUpdatedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield ProfileImageUpdatedFailure(message: e.toString());
    }
  }

  Stream<ProfileState> _mapProfileInformationUpdatedToState(
    String token,
    String firstName,
    String lastName,
  ) async* {
    yield ProfileInformationUpdatedInProcess();
    try {
      final result =
          await _profileRepository.updateProfile(token, firstName, lastName);
      print(result);
      if (result['code'] == 'SUCCESS') {
        yield ProfileInformationUpdatedSuccess();
      } else {
        yield ProfileInformationUpdatedFailure(message: result['errMessage']);
      }
    } catch (e) {
      print(e.toString());
      yield ProfileInformationUpdatedFailure(message: e.toString());
    }
  }
}
