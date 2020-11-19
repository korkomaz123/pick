import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'setting_repository.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc({@required SettingRepository settingRepository})
      : assert(settingRepository != null),
        _settingRepository = settingRepository,
        super(SettingInitial());

  final SettingRepository _settingRepository;

  @override
  Stream<SettingState> mapEventToState(
    SettingEvent event,
  ) async* {
    if (event is NotificationSettingChanged) {
      yield* _mapNotificationSettingChangedToState(
        event.token,
        event.isActive,
      );
    } else if (event is ContactUsSubmitted) {
      yield* _mapContactUsSubmittedToState(
        event.name,
        event.phone,
        event.email,
        event.comment,
      );
    } else if (event is PasswordUpdated) {
      yield* _mapPasswordUpdatedToState(
        event.token,
        event.oldPassword,
        event.newPassword,
      );
    }
  }

  Stream<SettingState> _mapNotificationSettingChangedToState(
    String token,
    bool isActive,
  ) async* {
    yield NotificationSettingChangedInProcess();
    try {
      await _settingRepository.changeNotificationSetting(token, isActive);
      yield NotificationSettingChangedSuccess(status: isActive);
    } catch (e) {
      yield NotificationSettingChangedFailure(message: e.toString());
    }
  }

  Stream<SettingState> _mapContactUsSubmittedToState(
    String name,
    String phone,
    String email,
    String comment,
  ) async* {
    yield ContactUsSubmittedInProcess();
    try {
      await _settingRepository.submitContactUs(name, phone, email, comment);
      yield ContactUsSubmittedSuccess();
    } catch (e) {
      yield ContactUsSubmittedFailure(message: e.toString());
    }
  }

  Stream<SettingState> _mapPasswordUpdatedToState(
    String token,
    String oldPassword,
    String newPassword,
  ) async* {
    yield PasswordUpdatedInProcess();
    try {
      final result = await _settingRepository.updatePassword(
          token, oldPassword, newPassword);
      if (result['code'] == 'SUCCESS') {
        yield PasswordUpdatedSuccess();
      } else {
        yield PasswordUpdatedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      yield PasswordUpdatedFailure(message: e.toString());
    }
  }
}
