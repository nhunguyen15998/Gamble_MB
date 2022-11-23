part of 'wallet_deposit_bloc.dart';

class WalletDepositState extends Equatable {
  WalletDepositState({
    this.status = FormzStatus.pure,
    this.amount = const Amount.pure(),
    this.method = 0, 
    this.isBtnDisabled = false
  });

  FormzStatus status;
  Amount amount;
  int method;
  bool isBtnDisabled;

  WalletDepositState copyWith({Amount? amount, int? method, FormzStatus? status, bool? isBtnDisabled}){
    return WalletDepositState(
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      isBtnDisabled: isBtnDisabled ?? this.isBtnDisabled
    );
  }

  @override
  List<Object?> get props => [amount, method, status, isBtnDisabled];
}

class WalletDepositInitialized extends WalletDepositState {}

