part of 'signin_bloc.dart';

class SignInState extends Equatable {
  const SignInState(
      {this.status = FormzStatus.pure,
      this.phone = const Phone.pure(),
      this.password = const Password.pure(),
      this.showPassword = true,
      this.message = ''});

  final FormzStatus status;
  final Phone phone;
  final Password password;
  final bool showPassword;
  final String message;

  SignInState copyWith(
      {FormzStatus? status,
      Phone? phone,
      Password? password,
      bool? showPassword,
      String? message}) {
    return SignInState(
        status: status ?? this.status,
        phone: phone ?? this.phone,
        password: password ?? this.password,
        showPassword: showPassword ?? this.showPassword,
        message: message ?? this.message);
  }

  @override
  List<Object> get props => [status, phone, password, showPassword, message];
}
