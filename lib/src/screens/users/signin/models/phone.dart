// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum PhoneValidationError { empty }

class Phone extends FormzInput<String, PhoneValidationError> {
  const Phone.pure() : super.pure('');
  const Phone.dirty([String value = '']) : super.dirty(value);

  @override
  PhoneValidationError? validator(String value) {
    if (value.isEmpty || value.length != 10) {
      return PhoneValidationError.empty;
    }
    return null;
  }
}
