import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:gamble/src/screens/users/wallet_withdraw/models/account_name.dart';
import 'package:gamble/src/screens/users/wallet_withdraw/models/account_number.dart';
import 'package:gamble/src/screens/users/wallet_withdraw/models/address.dart';
import 'package:gamble/src/screens/users/wallet_withdraw/models/bank.dart';
import 'package:gamble/src/screens/users/wallet_withdraw/models/bank_amount.dart';
import 'package:gamble/src/screens/users/wallet_withdraw/models/bitcoin_amount.dart';
import 'package:gamble/src/services/transaction_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
part 'wallet_withdraw_event.dart';
part 'wallet_withdraw_state.dart';

class WalletWithdrawBloc extends Bloc<WalletWithdrawEvent, WalletWithdrawState> {
  TransactionService transactionService;
  WalletWithdrawBloc(this.transactionService) : super(const WalletWithdrawState()) {
    on<WalletWithdrawBankInitial>(_mapWalletWithdrawInitialToState);
    on<WalletWithdrawAccountNameChanged>(_mapWalletWithdrawAccountNameChangedToState);
    on<WalletWithdrawAccountNumberChanged>(_mapWalletWithdrawAccountNumberChangedToState);
    on<WalletWithdrawBankChanged>(_mapWalletWithdrawBankChangedToState);
    on<WalletWithdrawBankAmountChanged>(_mapWalletWithdrawBankAmountChangedToState);
    on<WalletWithdrawNoteChanged>(_mapWalletWithdrawNoteChangedToState);
    on<WalletWithdrawBankRequestSubmitted>(_mapWalletWithdrawBankRequestSubmittedToState);

    on<WalletWithdrawBitcoinInitial>(_mapWalletWithdrawBitcoinInitialToState);
    on<WalletWithdrawBitcoinAmountChanged>(_mapWalletWithdrawBitcoinAmountChangedToState);
    on<WalletWithdrawAddressChanged>(_mapWalletWithdrawAddressChangedToState);
    on<WalletWithdrawBitcoinRequestSubmitted>(_mapWalletWithdrawBitcoinRequestSubmittedToState);
  }
  
  //bank
  Future<void> _mapWalletWithdrawInitialToState(WalletWithdrawBankInitial event, Emitter<WalletWithdrawState> emit) async {
    try {
      final result = await transactionService.getBalanceAndExchangeRate("VND");
      final bankBalance = result['balance'];
      final exchangeRate = result['exchangeRate'];
      emit(WalletWithdrawBankInitialized(bankBalance: bankBalance, bankExRate: exchangeRate, tempBankBalance: bankBalance));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _mapWalletWithdrawAccountNameChangedToState(WalletWithdrawAccountNameChanged event, Emitter<WalletWithdrawState> emit) async {
    final accountName = AccountName.dirty(event.accountName);
    WalletWithdrawBankInitialized walletWithdrawBank = state as WalletWithdrawBankInitialized;
    var isValid = Formz.validate([accountName, walletWithdrawBank.accountNumber, 
                                  walletWithdrawBank.bank, walletWithdrawBank.bankAmount]);
    emit(walletWithdrawBank.copyWith(status: isValid, accountName: accountName));
  }

  Future<void> _mapWalletWithdrawAccountNumberChangedToState(WalletWithdrawAccountNumberChanged event, Emitter<WalletWithdrawState> emit) async {
    final accountNumber = AccountNumber.dirty(event.accountNumber);
    WalletWithdrawBankInitialized walletWithdrawBank = state as WalletWithdrawBankInitialized;
    var isValid = Formz.validate([walletWithdrawBank.accountNumber, accountNumber, 
                                  walletWithdrawBank.bank, walletWithdrawBank.bankAmount]);
    emit(walletWithdrawBank.copyWith(status: isValid, accountNumber: accountNumber));
  }

  Future<void> _mapWalletWithdrawBankChangedToState(WalletWithdrawBankChanged event, Emitter<WalletWithdrawState> emit) async {
    final bank = Bank.dirty(event.bank);
    WalletWithdrawBankInitialized walletWithdrawBank = state as WalletWithdrawBankInitialized;
    var isValid = Formz.validate([walletWithdrawBank.accountNumber, walletWithdrawBank.accountNumber, 
                                  bank, walletWithdrawBank.bankAmount]);
    emit(walletWithdrawBank.copyWith(status: isValid, bank: bank));
  }

  Future<void> _mapWalletWithdrawBankAmountChangedToState(WalletWithdrawBankAmountChanged event, Emitter<WalletWithdrawState> emit) async {
    final bankAmount = BankAmount.dirty(event.bankAmount);
    WalletWithdrawBankInitialized walletWithdrawBank = state as WalletWithdrawBankInitialized;
    var isValid = Formz.validate([walletWithdrawBank.accountNumber, walletWithdrawBank.accountNumber,
                                  walletWithdrawBank.bank, bankAmount]);
    final regex = RegExp(r"^[+]?[0-9]*([.][0-9]*)?$");
    var balanceUpdated = bankAmount.value.isEmpty || !regex.hasMatch(bankAmount.value) ? 
                          walletWithdrawBank.bankBalance : 
                          walletWithdrawBank.bankBalance - (double.parse(bankAmount.value)*walletWithdrawBank.bankExRate);
    emit(walletWithdrawBank.copyWith(status: isValid, bankAmount: bankAmount, tempBankBalance: balanceUpdated));
  }

  Future<void> _mapWalletWithdrawNoteChangedToState(WalletWithdrawNoteChanged event, Emitter<WalletWithdrawState> emit) async {
    final note = event.note;
    WalletWithdrawBankInitialized walletWithdrawBank = state as WalletWithdrawBankInitialized;
    emit(walletWithdrawBank.copyWith(note: note));
  }

  Future<void> _mapWalletWithdrawBankRequestSubmittedToState(WalletWithdrawBankRequestSubmitted event, Emitter<WalletWithdrawState> emit) async {
    final isBtnDisabled = event.isBtnDisabled;
    WalletWithdrawBankInitialized walletWithdrawBank = state as WalletWithdrawBankInitialized;
    emit(walletWithdrawBank.copyWith(isBtnDisabled: isBtnDisabled));
  }

  //bitcoin
  Future<void> _mapWalletWithdrawBitcoinInitialToState(WalletWithdrawBitcoinInitial event, Emitter<WalletWithdrawState> emit) async {
    try {
      final result = await transactionService.getBalanceAndExchangeRate("BITCOIN");
      final bitcoinBalance = result['balance'];
      final exchangeRate = result['exchangeRate'];
      emit(WalletWithdrawBitcoinInitialized(bitcoinBalance: bitcoinBalance, bitcoinExRate: exchangeRate, tempBitcoinBalance: bitcoinBalance));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _mapWalletWithdrawBitcoinAmountChangedToState(WalletWithdrawBitcoinAmountChanged event, Emitter<WalletWithdrawState> emit) async {
    final amount = BitcoinAmount.dirty(event.bitcoinAmount);
    WalletWithdrawBitcoinInitialized walletWithdrawBitcoin = state as WalletWithdrawBitcoinInitialized;
    var isValid = Formz.validate([amount, walletWithdrawBitcoin.address]);
    final regex = RegExp(r"^[+]?[0-9]*([.][0-9]*)?$");
    var balanceUpdated = amount.value.isEmpty || !regex.hasMatch(amount.value) ? 
                          walletWithdrawBitcoin.bitcoinBalance : 
                          walletWithdrawBitcoin.bitcoinBalance - (double.parse(amount.value)*walletWithdrawBitcoin.bitcoinExRate);
    emit(walletWithdrawBitcoin.copyWith(bitcoinAmount: amount, status: isValid, tempBitcoinBalance: balanceUpdated));
  }

  Future<void> _mapWalletWithdrawAddressChangedToState(WalletWithdrawAddressChanged event, Emitter<WalletWithdrawState> emit) async {
    final bcAddress = Address.dirty(event.address);
    WalletWithdrawBitcoinInitialized walletWithdrawBitcoin = state as WalletWithdrawBitcoinInitialized;
    var isValid = Formz.validate([bcAddress, walletWithdrawBitcoin.bitcoinAmount]);
    emit(walletWithdrawBitcoin.copyWith(status: isValid, address: bcAddress));
  }

  Future<void> _mapWalletWithdrawBitcoinRequestSubmittedToState(WalletWithdrawBitcoinRequestSubmitted event, Emitter<WalletWithdrawState> emit) async {
    final isBtnDisabled = event.isBtnDisabled;
    WalletWithdrawBitcoinInitialized walletWithdrawBitcoin = state as WalletWithdrawBitcoinInitialized;
    emit(walletWithdrawBitcoin.copyWith(isBtnDisabled: isBtnDisabled));
  }

}
