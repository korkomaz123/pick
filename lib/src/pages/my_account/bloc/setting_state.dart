part of 'setting_bloc.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class NotificationSettingChangedInProcess extends SettingState {}

class NotificationSettingChangedSuccess extends SettingState {
  final bool status;

  NotificationSettingChangedSuccess({required this.status});

  @override
  List<Object> get props => [status];
}

class NotificationSettingChangedFailure extends SettingState {
  final String message;

  NotificationSettingChangedFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class ContactUsSubmittedInProcess extends SettingState {}

class ContactUsSubmittedSuccess extends SettingState {}

class ContactUsSubmittedFailure extends SettingState {
  final String message;

  ContactUsSubmittedFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class PasswordUpdatedInProcess extends SettingState {}

class PasswordUpdatedSuccess extends SettingState {}

class PasswordUpdatedFailure extends SettingState {
  final String message;

  PasswordUpdatedFailure({required this.message});

  @override
  List<Object> get props => [message];
}
