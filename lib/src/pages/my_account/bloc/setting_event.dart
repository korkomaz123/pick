part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class NotificationSettingChanged extends SettingEvent {
  final String token;
  final bool isActive;

  NotificationSettingChanged({this.token, this.isActive});

  @override
  List<Object> get props => [token, isActive];
}

class ContactUsSubmitted extends SettingEvent {
  final String name;
  final String phone;
  final String email;
  final String comment;

  ContactUsSubmitted({
    this.name,
    this.phone,
    this.email,
    this.comment,
  });

  @override
  List<Object> get props => [name, phone, email, comment];
}

class PasswordUpdated extends SettingEvent {
  final String token;
  final String oldPassword;
  final String newPassword;

  PasswordUpdated({this.token, this.oldPassword, this.newPassword});

  @override
  List<Object> get props => [token, oldPassword, newPassword];
}
