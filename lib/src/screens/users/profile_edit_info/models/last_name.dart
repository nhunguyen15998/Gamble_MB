// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum LastNameUpdateValidationError { 
  empty
}

class LastNameUpdate extends FormzInput<String, LastNameUpdateValidationError> {
  const LastNameUpdate.pure() : super.pure('');
  const LastNameUpdate.dirty([String value = '']) : super.dirty(value);

  @override
  LastNameUpdateValidationError? validator(String value) {
    if (value.isEmpty) {
      return LastNameUpdateValidationError.empty;
    }
    return null;
  }
}
