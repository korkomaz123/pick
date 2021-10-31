part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class NotificationSettingChanged extends SettingEvent {
  final String token;
  final bool isActive;

  NotificationSettingChanged({required this.token, required this.isActive});

  @override
  List<Object> get props => [token, isActive];
}

class ContactUsSubmitted extends SettingEvent {
  final String name;
  final String phone;
  final String email;
  final String comment;

  ContactUsSubmitted({
    required this.name,
    required this.phone,
    required this.email,
    required this.comment,
  });

  @override
  List<Object> get props => [name, phone, email, comment];
}

class PasswordUpdated extends SettingEvent {
  final String token;
  final String oldPassword;
  final String newPassword;

  PasswordUpdated({
    required this.token,
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [token, oldPassword, newPassword];
}
