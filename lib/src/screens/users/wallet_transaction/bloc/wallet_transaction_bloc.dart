import 'package:bloc/bloc.dart';
import 'package:gamble/src/screens/users/wallet_transaction/models/transaction_list_item.dart';
import 'package:gamble/src/services/transaction_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'wallet_transaction_event.dart';
part 'wallet_transaction_state.dart';

class WalletTransactionBloc extends Bloc<WalletTransactionEvent, WalletTransactionState> {
  final TransactionService transactionService;
  WalletTransactionBloc(this.transactionService) : super(WalletTransactionInitialized()) {
    on<WalletTransactionInitial>(_mapWalletTransactionInitialToState);
  }

  Future<void> _mapWalletTransactionInitialToState(WalletTransactionInitial event, Emitter<WalletTransactionState> emit) async {
    // emit(WalletTransactionInitialized());
    List<TransactionListItem> transactionList;
    try {
      final page = event.page;
      transactionList = await transactionService.getTransactions(page);
      if(page == 1){
        emit(transactionList.isEmpty?
          WalletTransactionNotFound():
          WalletTransactionLoaded(transactionList: transactionList)
        );
      } else {
        WalletTransactionLoaded walletTransactionLoaded = state as WalletTransactionLoaded;
        emit(transactionList.isEmpty?
          walletTransactionLoaded.copyWith(hasReachedMax: true):
          walletTransactionLoaded.copyWith(transactionList: walletTransactionLoaded.transactionList + transactionList)
        );
      }
      print("size: ${transactionList.length}");
    } catch (e) {
      print(e);
    }
  }

}
