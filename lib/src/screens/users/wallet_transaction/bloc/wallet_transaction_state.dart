part of 'wallet_transaction_bloc.dart';

class WalletTransactionState extends Equatable {
  const WalletTransactionState();

  @override
  List<Object> get props => [];
}

class WalletTransactionInitialized extends WalletTransactionState {}

class WalletTransactionNotFound extends WalletTransactionState {}

class WalletTransactionLoaded extends WalletTransactionState {
  WalletTransactionLoaded({
    this.transactionList = const <TransactionListItem>[],
    this.page = 1,
    this.hasReachedMax = false
  });

  List<TransactionListItem> transactionList;
  int page;
  bool hasReachedMax;

  WalletTransactionLoaded copyWith({List<TransactionListItem>? transactionList, int? page, bool? hasReachedMax}){
    return WalletTransactionLoaded(
      transactionList: transactionList ?? this.transactionList,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
  }

  @override
  List<Object> get props => [transactionList, page, hasReachedMax];
}
