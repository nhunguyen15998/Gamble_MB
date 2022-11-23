part of 'wallet_transfer_bloc.dart';

class WalletTransferState extends Equatable {
  WalletTransferState({
    this.status = FormzStatus.invalid,
    this.phone = const TransferPhone.pure(),
    this.amount = const TransferAmount.pure(),
    this.note = '',
    this.isBtnDisabled = false,
  });

  FormzStatus status;
  TransferPhone phone;
  TransferAmount amount;
  String note;
  bool isBtnDisabled;

  WalletTransferState copyWith({
    FormzStatus? status,
    TransferPhone? phone,
    TransferAmount? amount,
    String? note,
    bool? isBtnDisabled,
  }){
    return WalletTransferState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      isBtnDisabled: isBtnDisabled ?? this.isBtnDisabled,
    );
  }
  
  @override
  List<Object?> get props => [status, phone, amount, note, isBtnDisabled];
}
