// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum AmountValidationError { 
  empty
}

class Amount extends FormzInput<String, AmountValidationError> {
  const Amount.pure() : super.pure('');
  const Amount.dirty([String value = '']) : super.dirty(value);

  @override
  AmountValidationError? validator(String value) {
    if (value.isEmpty) {
      return AmountValidationError.empty;
    }
    return null;
  }
}
