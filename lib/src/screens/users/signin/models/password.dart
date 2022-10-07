// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum PasswordValidationError { empty, minLength }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty || value.length < 6) {
      return PasswordValidationError.empty;
    }
    return null;
  }
}
