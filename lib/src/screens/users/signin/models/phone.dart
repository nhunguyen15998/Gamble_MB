// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum PhoneValidationError { 
  empty, 
  invalidFormat
}

class Phone extends FormzInput<String, PhoneValidationError> {
  const Phone.pure() : super.pure('');
  const Phone.dirty([String value = '']) : super.dirty(value);

  @override
  PhoneValidationError? validator(String value) {
    if (value.isEmpty) {
      return PhoneValidationError.empty;
    }
    final regex = RegExp(r"^[0][3|5|7|8|9][0-9]{8}$");
    if(!regex.hasMatch(value)){
      return PhoneValidationError.invalidFormat;
    }
    return null;
  }
}
