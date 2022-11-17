// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum BankValidationError { 
  empty
}

class Bank extends FormzInput<String, BankValidationError> {
  const Bank.pure() : super.pure('');
  const Bank.dirty([String value = '']) : super.dirty(value);

  @override
  BankValidationError? validator(String value) {
    if (value.isEmpty) {
      return BankValidationError.empty;
    }
    return null;
  }
}
