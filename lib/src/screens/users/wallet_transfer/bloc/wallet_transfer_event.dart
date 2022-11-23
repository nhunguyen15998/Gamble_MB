part of 'wallet_transfer_bloc.dart';

class WalletTransferEvent extends Equatable {
  const WalletTransferEvent();
  
  @override
  List<Object?> get props => [];
}
class WalletTransferInitial extends WalletTransferEvent {}

class TransferPhoneChanged extends WalletTransferEvent {
  TransferPhoneChanged({required this.phone});

  String phone;

  @override
  List<Object?> get props => [phone];
}

class TransferAmountChanged extends WalletTransferEvent {
  TransferAmountChanged({required this.amount});

  String amount;
  
  @override
  List<Object?> get props => [amount];
}

class TransferNoteChanged extends WalletTransferEvent {
  TransferNoteChanged({required this.note});

  String note;
  
  @override
  List<Object?> get props => [note];
}

class TransferBtnClicked extends WalletTransferEvent {
  TransferBtnClicked({required this.isBtnDisabled});

  bool isBtnDisabled;
  
  @override
  List<Object?> get props => [isBtnDisabled];
}
