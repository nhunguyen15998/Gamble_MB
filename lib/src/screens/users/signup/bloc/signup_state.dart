part of 'signup_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState(
      {this.status = FormzStatus.pure,
      this.firstName = const FirstName.pure(),
      this.lastName = const LastName.pure(),
      this.phone = const Phone.pure(),
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.showPassword = true,
      this.confirmedPassword = const ConfirmedPassword.pure(),
      this.showConfirmedPassword = true,
      this.error = ''});

  final FormzStatus status;
  final FirstName firstName;
  final LastName lastName;
  final Phone phone;
  final Email email;
  final Password password;
  final bool showPassword;
  final ConfirmedPassword confirmedPassword;
  final bool showConfirmedPassword;
  final String error;

  SignUpState copyWith(
      {FormzStatus? status,
      FirstName? firstName,
      LastName? lastName,
      Phone? phone,
      Email? email,
      Password? password,
      bool? showPassword,
      ConfirmedPassword? confirmedPassword,
      bool? showConfirmedPassword,
      String? error}) {
    return SignUpState(
        status: status ?? this.status,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        password: password ?? this.password,
        showPassword: showPassword ?? this.showPassword,
        confirmedPassword: confirmedPassword ?? this.confirmedPassword,
        showConfirmedPassword:
            showConfirmedPassword ?? this.showConfirmedPassword,
        error: error ?? this.error);
  }

  @override
  List<Object> get props => [
        status,
        firstName,
        lastName,
        phone,
        email,
        password,
        showPassword,
        confirmedPassword,
        showConfirmedPassword,
        error
      ];
}
