// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum ChangePasswordValidationError { 
  empty
}

class ChangePassword extends FormzInput<String, ChangePasswordValidationError> {
  const ChangePassword.pure() : super.pure('');
  const ChangePassword.dirty([String value = '']) : super.dirty(value);

  @override
  ChangePasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return ChangePasswordValidationError.empty;
    }
    return null;
  }
}
