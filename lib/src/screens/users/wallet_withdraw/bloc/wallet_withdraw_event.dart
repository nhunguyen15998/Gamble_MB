part of 'wallet_withdraw_bloc.dart';

class WalletWithdrawEvent extends Equatable {
  const WalletWithdrawEvent();
  
  @override
  List<Object?> get props => [];
}
class WalletWithdrawBankInitial extends WalletWithdrawEvent {}

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
// class WalletWithdrawBankRequestSubmitted extends WalletWithdrawEvent {}

//bc
class WalletWithdrawBitcoinInitial extends WalletWithdrawEvent {}

class WalletWithdrawBitcoinAmountChanged extends WalletWithdrawEvent {
  WalletWithdrawBitcoinAmountChanged({required this.bitcoinAmount});
  String bitcoinAmount;
  @override
  List<Object?> get props => [bitcoinAmount];
}
class WalletWithdrawAddressButtonClicked extends WalletWithdrawEvent {
  WalletWithdrawAddressButtonClicked({required this.address, required this.transactionCode});
  String address;
  String transactionCode;
  @override
  List<Object?> get props => [address, transactionCode];
}
// class WalletWithdrawBitcoinRequestSubmitted extends WalletWithdrawEvent {}


