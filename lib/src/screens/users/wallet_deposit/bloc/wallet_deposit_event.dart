part of 'wallet_deposit_bloc.dart';

class WalletDepositEvent extends Equatable {
  const WalletDepositEvent();

  @override
  List<Object> get props => [];
}
class WalletDepositInitial extends WalletDepositEvent {}

class WalletDepositAmountChanged extends WalletDepositEvent {
  const WalletDepositAmountChanged(this.amount);

  final String amount;

  @override
  List<Object> get props => [amount];
}

class WalletDepositMethodChanged extends WalletDepositEvent {
  const WalletDepositMethodChanged(this.method);

  final int method;

  @override
  List<Object> get props => [method];
}

class WalletDepositSubmitted extends WalletDepositEvent {
  WalletDepositSubmitted({
    required this.amount,
    required this.method,
  });

  String amount;
  int method;

  @override
  List<Object> get props => [amount, method];
}
