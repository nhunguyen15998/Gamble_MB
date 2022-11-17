// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum AccountNameValidationError { 
  empty
}

class AccountName extends FormzInput<String, AccountNameValidationError> {
  const AccountName.pure() : super.pure('');
  const AccountName.dirty([String value = '']) : super.dirty(value);

  @override
  AccountNameValidationError? validator(String value) {
    if (value.isEmpty) {
      return AccountNameValidationError.empty;
    }
    return null;
  }
}
