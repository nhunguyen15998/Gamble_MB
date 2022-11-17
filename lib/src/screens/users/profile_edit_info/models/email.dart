// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum EmailUpdateValidationError { 
  empty
}

class EmailUpdate extends FormzInput<String, EmailUpdateValidationError> {
  const EmailUpdate.pure() : super.pure('');
  const EmailUpdate.dirty([String value = '']) : super.dirty(value);

  @override
  EmailUpdateValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailUpdateValidationError.empty;
    }
    return null;
  }
}
