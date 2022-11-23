import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:gamble/src/screens/users/wallet_deposit/models/amount.dart';
import 'package:gamble/src/screens/users/wallet_deposit/models/vnpay.dart';
import 'package:gamble/src/services/transaction_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'wallet_deposit_event.dart';
part 'wallet_deposit_state.dart';

class WalletDepositBloc extends Bloc<WalletDepositEvent, WalletDepositState> {
  TransactionService transactionService;

  WalletDepositBloc(this.transactionService) : super(WalletDepositState()) {
    on<WalletDepositInitial>(_mapWalletDepositInitialToState);
    on<WalletDepositAmountChanged>(_mapWalletDepositAmountChangedToState);
    on<WalletDepositMethodChanged>(_mapWalletDepositMethodChangedToState);
    on<WalletDepositSubmitted>(_mapWalletDepositSubmittedToState);
  }

  Future<void> _mapWalletDepositInitialToState(WalletDepositInitial event, Emitter<WalletDepositState> emit) async {
    emit(WalletDepositInitialized());
  }

  Future<void> _mapWalletDepositAmountChangedToState(WalletDepositAmountChanged event, Emitter<WalletDepositState> emit) async {
    final amount = Amount.dirty(event.amount);
    var isValid = Formz.validate([amount]);
    print('method: $amount');
    emit(state.copyWith(amount: amount, status: isValid));
  }

  Future<void> _mapWalletDepositMethodChangedToState(WalletDepositMethodChanged event, Emitter<WalletDepositState> emit) async {
    final method = event.method;
    print('method: $method');
    emit(state.copyWith(method: method));
  }

  Future<void> _mapWalletDepositSubmittedToState(WalletDepositSubmitted event, Emitter<WalletDepositState> emit) async {
    final isBtnDisabled = event.isBtnDisabled;
    emit(state.copyWith(isBtnDisabled: isBtnDisabled));
  }

}
