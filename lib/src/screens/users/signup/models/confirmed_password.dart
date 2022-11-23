// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { empty, minLength }

class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPassword.pure() : super.pure('');
  const ConfirmedPassword.dirty([String value = '']) : super.dirty(value);

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmedPasswordValidationError.empty;
    }
    return null;
  }
}
