part of 'password_required_bloc.dart';

class PasswordRequiredEvent extends Equatable {
  const PasswordRequiredEvent();
  @override
  List<Object?> get props => [];
}

class PasswordRequiredInitialized extends PasswordRequiredEvent {
  PasswordRequiredInitialized({required this.path, required this.data, required this.type});
  String path;
  Map<String, String> data;
  String type;
  @override
  List<Object?> get props => [path, data, type];
}

class PasswordRequiredPasswordInputChanged extends PasswordRequiredEvent {
  PasswordRequiredPasswordInputChanged({required this.password});
  String password;
  @override
  List<Object?> get props => [password];
}

class PasswordRequiredBtnContinueClicked extends PasswordRequiredEvent {
  PasswordRequiredBtnContinueClicked({this.isBtnDisabled = false});
  bool isBtnDisabled;
  @override
  List<Object?> get props => [isBtnDisabled];
}

class PasswordRequiredAlertBtnOKClicked extends PasswordRequiredEvent {}