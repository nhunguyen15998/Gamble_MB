// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum LastNameValidationError { empty, minLength }

class LastName extends FormzInput<String, LastNameValidationError> {
  const LastName.pure() : super.pure('');
  const LastName.dirty([String value = '']) : super.dirty(value);

  @override
  LastNameValidationError? validator(String value) {
    if (value.isEmpty) {
      return LastNameValidationError.empty;
    }
    return null;
  }
}
