// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum FirstNameUpdateValidationError { 
  empty
}

class FirstNameUpdate extends FormzInput<String, FirstNameUpdateValidationError> {
  const FirstNameUpdate.pure() : super.pure('');
  const FirstNameUpdate.dirty([String value = '']) : super.dirty(value);

  @override
  FirstNameUpdateValidationError? validator(String value) {
    if (value.isEmpty) {
      return FirstNameUpdateValidationError.empty;
    }
    return null;
  }
}
