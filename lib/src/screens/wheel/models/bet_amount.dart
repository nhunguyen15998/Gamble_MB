// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

enum WheelBetAmountValidationError { 
  empty
}

class WheelBetAmount extends FormzInput<String, WheelBetAmountValidationError> {
  const WheelBetAmount.pure() : super.pure('');
  const WheelBetAmount.dirty([String value = '']) : super.dirty(value);

  @override
  WheelBetAmountValidationError? validator(String value) {
    if (value.isEmpty) {
      return WheelBetAmountValidationError.empty;
    }
    return null;
  }
}
