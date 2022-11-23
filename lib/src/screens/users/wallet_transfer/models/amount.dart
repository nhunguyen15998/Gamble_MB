// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum TransferAmountValidationError { 
  empty
}

class TransferAmount extends FormzInput<String, TransferAmountValidationError> {
  const TransferAmount.pure() : super.pure('');
  const TransferAmount.dirty([String value = '']) : super.dirty(value);

  @override
  TransferAmountValidationError? validator(String value) {
    if (value.isEmpty) {
      return TransferAmountValidationError.empty;
    }
    return null;
  }
}
