// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum BankAmountValidationError { 
  empty
}

class BankAmount extends FormzInput<String, BankAmountValidationError> {
  const BankAmount.pure() : super.pure('');
  const BankAmount.dirty([String value = '']) : super.dirty(value);

  @override
  BankAmountValidationError? validator(String value) {
    if (value.isEmpty) {
      return BankAmountValidationError.empty;
    }
    return null;
  }
}
