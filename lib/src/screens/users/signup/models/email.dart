// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum EmailValidationError { empty, minLength }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    return null;
  }
}
