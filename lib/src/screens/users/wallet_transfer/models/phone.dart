// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum TransferPhoneValidationError { 
  empty
}

class TransferPhone extends FormzInput<String, TransferPhoneValidationError> {
  const TransferPhone.pure() : super.pure('');
  const TransferPhone.dirty([String value = '']) : super.dirty(value);

  @override
  TransferPhoneValidationError? validator(String value) {
    if (value.isEmpty) {
      return TransferPhoneValidationError.empty;
    }
    return null;
  }
}
