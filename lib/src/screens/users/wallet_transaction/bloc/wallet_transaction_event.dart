part of 'wallet_transaction_bloc.dart';

class WalletTransactionEvent extends Equatable {
  const WalletTransactionEvent();

  @override
  List<Object> get props => [];
}

class WalletTransactionInitial extends WalletTransactionEvent {
  WalletTransactionInitial({
    this.transactionList,
    this.page = 1
  });

  List<TransactionListItem>? transactionList;
  int page;

  @override
  List<Object> get props => [page];
}
