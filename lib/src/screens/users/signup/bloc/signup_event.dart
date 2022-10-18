part of 'signup_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpFirstNameChanged extends SignUpEvent {
  const SignUpFirstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

class SignUpLastNameChanged extends SignUpEvent {
  const SignUpLastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

class SignUpPhoneChanged extends SignUpEvent {
  const SignUpPhoneChanged(this.phone);

  final String phone;

  @override
  List<Object> get props => [phone];
}

class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class SignUpShowPasswordChanged extends SignUpEvent {
  const SignUpShowPasswordChanged(this.showPassword);

  final bool showPassword;

  @override
  List<Object> get props => [showPassword];
}

class SignUpConfirmedPasswordChanged extends SignUpEvent {
  const SignUpConfirmedPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class SignUpShowConfirmedPasswordChanged extends SignUpEvent {
  const SignUpShowConfirmedPasswordChanged(this.showPassword);

  final bool showPassword;

  @override
  List<Object> get props => [showPassword];
}

class SignUpStepChanged extends SignUpEvent {
  const SignUpStepChanged(this.step);

  final int step;
  
  @override
  List<Object> get props => [step];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}

class CloseDialog extends SignUpEvent {}
