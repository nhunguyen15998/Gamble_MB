// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum AccountNumberValidationError { 
  empty
}

class AccountNumber extends FormzInput<String, AccountNumberValidationError> {
  const AccountNumber.pure() : super.pure('');
  const AccountNumber.dirty([String value = '']) : super.dirty(value);

  @override
  AccountNumberValidationError? validator(String value) {
    if (value.isEmpty) {
      return AccountNumberValidationError.empty;
    }
    return null;
  }
}
