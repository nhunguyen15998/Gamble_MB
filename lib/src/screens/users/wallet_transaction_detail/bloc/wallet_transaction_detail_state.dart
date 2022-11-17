part of 'wallet_transaction_detail_bloc.dart';

class WalletTransactionDetailState extends Equatable {
  const WalletTransactionDetailState();

  @override
  List<Object?> get props => [];
}

class WalletTransactionDetailInitialized extends WalletTransactionDetailState {}

class WalletTransactionDetailLoaded extends WalletTransactionDetailState {
  WalletTransactionDetailLoaded({
    required this.transactionItemDetail
  });

  TransactionItemDetail transactionItemDetail;

  @override
  List<Object> get props => [transactionItemDetail];
}
