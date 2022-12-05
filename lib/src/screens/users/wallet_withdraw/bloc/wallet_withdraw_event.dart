part of 'wallet_withdraw_bloc.dart';

class WalletWithdrawEvent extends Equatable {
  const WalletWithdrawEvent();
  
  @override
  List<Object?> get props => [];
}
class WalletWithdrawBankInitial extends WalletWithdrawEvent {
  WalletWithdrawBankInitial({
    this.bankBalance = 0,
    this.bankExRate = 0
  });
  double bankBalance;
  double bankExRate;
  @override
  List<Object?> get props => [bankBalance, bankExRate];
}

class WalletWithdrawAccountNameChanged extends WalletWithdrawEvent {
  WalletWithdrawAccountNameChanged({required this.accountName});
  String accountName;
  @override
  List<Object?> get props => [accountName];
}
class WalletWithdrawAccountNumberChanged extends WalletWithdrawEvent {
  WalletWithdrawAccountNumberChanged({required this.accountNumber});
  String accountNumber;
  @override
  List<Object?> get props => [accountNumber];
}
class WalletWithdrawBankChanged extends WalletWithdrawEvent {
  WalletWithdrawBankChanged({required this.bank});
  String bank;
  @override
  List<Object?> get props => [bank];
}
class WalletWithdrawBankAmountChanged extends WalletWithdrawEvent {
  WalletWithdrawBankAmountChanged({required this.bankAmount});
  String bankAmount;
  @override
  List<Object?> get props => [bankAmount];
}
class WalletWithdrawNoteChanged extends WalletWithdrawEvent {
  WalletWithdrawNoteChanged({required this.note});
  String note;
  @override
  List<Object?> get props => [note];
}
class WalletWithdrawBankRequestSubmitted extends WalletWithdrawEvent {
  WalletWithdrawBankRequestSubmitted({this.isBtnDisabled = false});
  bool isBtnDisabled;
  @override
  List<Object?> get props => [isBtnDisabled];
}

//bc
class WalletWithdrawBitcoinInitial extends WalletWithdrawEvent {
  WalletWithdrawBitcoinInitial({
    this.bitcoinBalance = 0,
    this.bitcoinExRate = 0
  });
  double bitcoinBalance;
  double bitcoinExRate;
  @override
  List<Object?> get props => [bitcoinBalance, bitcoinExRate];
}

class WalletWithdrawBitcoinAmountChanged extends WalletWithdrawEvent {
  WalletWithdrawBitcoinAmountChanged({required this.bitcoinAmount});
  String bitcoinAmount;
  @override
  List<Object?> get props => [bitcoinAmount];
}
class WalletWithdrawAddressChanged extends WalletWithdrawEvent {
  WalletWithdrawAddressChanged({required this.address});
  String address;
  @override
  List<Object?> get props => [address];
}
class WalletWithdrawBitcoinRequestSubmitted extends WalletWithdrawEvent {
  WalletWithdrawBitcoinRequestSubmitted({this.isBtnDisabled = false});
  bool isBtnDisabled;
  @override
  List<Object?> get props => [isBtnDisabled];
}


