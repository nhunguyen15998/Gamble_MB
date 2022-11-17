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

    on<WalletWithdrawBitcoinInitial>(_mapWalletWithdrawBitcoinInitialToState);
    on<WalletWithdrawBitcoinAmountChanged>(_mapWalletWithdrawBitcoinAmountChangedToState);
    on<WalletWithdrawAddressButtonClicked>(_mapWalletWithdrawAddressChangedToState);
  }

  //bank
  Future<void> _mapWalletWithdrawInitialToState(WalletWithdrawBankInitial event, Emitter<WalletWithdrawState> emit) async {
    emit(WalletWithdrawBankInitialized());
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
    emit(walletWithdrawBank.copyWith(status: isValid, bankAmount: bankAmount));
  }

  Future<void> _mapWalletWithdrawNoteChangedToState(WalletWithdrawNoteChanged event, Emitter<WalletWithdrawState> emit) async {
    final note = event.note;
    WalletWithdrawBankInitialized walletWithdrawBank = state as WalletWithdrawBankInitialized;
    emit(walletWithdrawBank.copyWith(note: note));
  }

  //bitcoin
  Future<void> _mapWalletWithdrawBitcoinInitialToState(WalletWithdrawBitcoinInitial event, Emitter<WalletWithdrawState> emit) async {
    emit(WalletWithdrawBitcoinInitialized());
  }

  Future<void> _mapWalletWithdrawBitcoinAmountChangedToState(WalletWithdrawBitcoinAmountChanged event, Emitter<WalletWithdrawState> emit) async {
    final amount = BitcoinAmount.dirty(event.bitcoinAmount);
    WalletWithdrawBitcoinInitialized walletWithdrawBitcoin = state as WalletWithdrawBitcoinInitialized;
    var isValid = Formz.validate([amount, walletWithdrawBitcoin.address]);
    emit(walletWithdrawBitcoin.copyWith(bitcoinAmount: amount, status: isValid));
  }

  Future<void> _mapWalletWithdrawAddressChangedToState(WalletWithdrawAddressButtonClicked event, Emitter<WalletWithdrawState> emit) async {
    final bcAddress = Address.dirty(event.address);
    final transactionCode = event.transactionCode;
    WalletWithdrawBitcoinInitialized walletWithdrawBitcoin = state as WalletWithdrawBitcoinInitialized;
    var isValid = Formz.validate([bcAddress, walletWithdrawBitcoin.bitcoinAmount]);
    emit(walletWithdrawBitcoin.copyWith(status: isValid, address: bcAddress, transactionCode: transactionCode));
  }

}
