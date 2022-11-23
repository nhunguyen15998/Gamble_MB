// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum RequiredPasswordValidationError { 
  empty
}

class RequiredPassword extends FormzInput<String, RequiredPasswordValidationError> {
  const RequiredPassword.pure() : super.pure('');
  const RequiredPassword.dirty([String value = '']) : super.dirty(value);

  @override
  RequiredPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return RequiredPasswordValidationError.empty;
    }
    return null;
  }
}
