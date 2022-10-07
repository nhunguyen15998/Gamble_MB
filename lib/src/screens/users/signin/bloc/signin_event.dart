part of 'signin_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInPhoneChanged extends SignInEvent {
  const SignInPhoneChanged(this.phone);

  final String phone;

  @override
  List<Object> get props => [phone];
}

class SignInPasswordChanged extends SignInEvent {
  const SignInPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class SignInShowPasswordChanged extends SignInEvent {
  const SignInShowPasswordChanged(this.showPassword);

  final bool showPassword;

  @override
  List<Object> get props => [showPassword];
}

class SignInSubmitted extends SignInEvent {
  const SignInSubmitted();
}

class CloseDialog extends SignInEvent {}
