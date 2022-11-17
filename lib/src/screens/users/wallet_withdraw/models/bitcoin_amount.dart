// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum BitcoinAmountValidationError { 
  empty
}

class BitcoinAmount extends FormzInput<String, BitcoinAmountValidationError> {
  const BitcoinAmount.pure() : super.pure('');
  const BitcoinAmount.dirty([String value = '']) : super.dirty(value);

  @override
  BitcoinAmountValidationError? validator(String value) {
    if (value.isEmpty) {
      return BitcoinAmountValidationError.empty;
    }
    return null;
  }
}
