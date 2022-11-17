part of 'wallet_transaction_detail_bloc.dart';

class WalletTransactionDetailEvent extends Equatable {
  const WalletTransactionDetailEvent();
  
  @override
  List<Object?> get props => [];
}

class WalletTransactionDetailInitial extends WalletTransactionDetailEvent {
  WalletTransactionDetailInitial({required this.transactionId});

  int transactionId;

  @override
  List<Object?> get props => [];
}