// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum FirstNameValidationError { empty, minLength }

class FirstName extends FormzInput<String, FirstNameValidationError> {
  const FirstName.pure() : super.pure('');
  const FirstName.dirty([String value = '']) : super.dirty(value);

  @override
  FirstNameValidationError? validator(String value) {
    if (value.isEmpty || value.length < 6) {
      return FirstNameValidationError.empty;
    }
    return null;
  }
}
