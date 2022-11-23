import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:gamble/src/screens/users/password_required/models/required_password.dart';
import 'package:gamble/src/services/settings_service.dart';
import 'package:gamble/src/services/transaction_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
part 'password_required_event.dart';
part 'password_required_state.dart';

class PasswordRequiredBloc extends Bloc<PasswordRequiredEvent, PasswordRequiredState> {
  TransactionService transactionService;
  SettingsService settingsService;
  PasswordRequiredBloc(this.transactionService, this.settingsService) : super(PasswordRequiredState()) {
    on<PasswordRequiredInitialized>(_mapPasswordRequiredEventToState);
    on<PasswordRequiredPasswordInputChanged>(_mapPasswordRequiredPasswordInputChangedToState);
    on<PasswordRequiredBtnContinueClicked>(_mapPasswordRequiredBtnContinueClickedToState);
    on<PasswordRequiredAlertBtnOKClicked>(_mapPasswordRequiredAlertBtnOKClickedToState);
  }

  void _mapPasswordRequiredEventToState(PasswordRequiredInitialized event, Emitter<PasswordRequiredState> emit){
    final path = event.path;
    final data = event.data;
    final type = event.type;
    emit(state.copyWith(path: path, data: data, type: type));
  }

  void _mapPasswordRequiredPasswordInputChangedToState(PasswordRequiredPasswordInputChanged event, Emitter<PasswordRequiredState> emit){
    final password = RequiredPassword.dirty(event.password);
    var isValid = Formz.validate([password]);
    emit(state.copyWith(password: password, status: isValid));
  }

  Future<void> _mapPasswordRequiredBtnContinueClickedToState(PasswordRequiredBtnContinueClicked event, Emitter<PasswordRequiredState> emit) async {
    final isBtnDisabled = event.isBtnDisabled;
    final password = state.password.value;
    final path = state.path;
    final data = state.data;
    emit(state.copyWith(isBtnDisabled: isBtnDisabled, status: FormzStatus.submissionInProgress));
    try {
      if(state.status.isValidated){
        data.addAll(<String, String>{"require_password":password});
        var requestBody = jsonEncode(data);
        data.removeWhere((key, value) => key == "require_password");
        var receiverPhone = data['phone'] != null ? data.entries.firstWhere((e) => e.key == 'phone').value : null;
        Map<String, dynamic> result = <String, dynamic>{};
        switch (state.type) {
          case 'transfer':
            result = await transactionService.transfer(requestBody, state.path);
            break;
          case 'withdrawBank':
            result = await transactionService.withdrawBank(requestBody, state.path);
            break;
          case 'withdrawBitcoin':
            result = await transactionService.withdrawBitcoin(requestBody, state.path);
            break;
          case 'updateSecurity':
            Map<String, dynamic> security = <String, dynamic>{
              "withdraw_password": int.parse(data['withdraw_password'].toString()),
              "transfer_password": int.parse(data['transfer_password'].toString()),
              "setting_password": int.parse(data['setting_password'].toString()),
              "require_password": password
            };
            result = await settingsService.updateSettingConfigs(jsonEncode(security), state.path);
            break;
        }
        var code = result['code'];
        var message = result['message'];
        emit(code == 200 ? 
             state.copyWith(status: FormzStatus.submissionSuccess, message: message, code: code, 
                            isBtnDisabled: false, receiverPhone: state.type == 'transfer'? receiverPhone : '') : 
             state.copyWith(status: FormzStatus.submissionFailure, message: message, code: code, 
                            isBtnDisabled: false, data: data, path: path));
      }
    } catch (e) {
      print(e);
    }
  }

  void _mapPasswordRequiredAlertBtnOKClickedToState(PasswordRequiredAlertBtnOKClicked event, Emitter<PasswordRequiredState> emit){
    emit(state.copyWith(status: FormzStatus.valid));
  }

}
