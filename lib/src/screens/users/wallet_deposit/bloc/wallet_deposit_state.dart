part of 'wallet_deposit_bloc.dart';

class WalletDepositState extends Equatable {
  WalletDepositState({
    this.status = FormzStatus.pure,
    this.amount = const Amount.pure(),
    this.method = 0, 
  });

  FormzStatus status;
  Amount amount;
  int method;

  WalletDepositState copyWith({Amount? amount, int? method, FormzStatus? status}){
    return WalletDepositState(
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [amount, method];
}

class WalletDepositInitialized extends WalletDepositState {}

