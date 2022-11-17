import 'package:bloc/bloc.dart';
import 'package:gamble/src/screens/users/wallet_transaction_detail/wallet_transaction_detail.dart';
import 'package:gamble/src/services/transaction_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'wallet_transaction_detail_event.dart';
part 'wallet_transaction_detail_state.dart';

class WalletTransactionDetailBloc extends Bloc<WalletTransactionDetailEvent, WalletTransactionDetailState> {
  TransactionService transactionService;
  WalletTransactionDetailBloc(this.transactionService) : super(WalletTransactionDetailInitialized()) {
    on<WalletTransactionDetailInitial>(_mapWalletTransactionDetailEventToState);
  }

  Future<void> _mapWalletTransactionDetailEventToState(WalletTransactionDetailInitial event, Emitter<WalletTransactionDetailState> emit) async {
    try {
      final transactionId = event.transactionId;
      final transaction = await transactionService.getTransactionById(transactionId);
      if(transaction != null){
        emit(WalletTransactionDetailLoaded(transactionItemDetail: transaction));
      }
    } catch (e) {
      print(e);
    }
  }

}
