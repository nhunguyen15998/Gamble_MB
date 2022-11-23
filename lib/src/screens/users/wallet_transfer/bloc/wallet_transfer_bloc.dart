import 'package:bloc/bloc.dart';
import 'package:gamble/src/screens/users/wallet_transfer/models/amount.dart';
import 'package:gamble/src/screens/users/wallet_transfer/models/phone.dart';
import 'package:gamble/src/services/transaction_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
part 'wallet_transfer_event.dart';
part 'wallet_transfer_state.dart';

class WalletTransferBloc extends Bloc<WalletTransferEvent, WalletTransferState> {
  TransactionService transactionService;
  WalletTransferBloc(this.transactionService) : super(WalletTransferState()) {
    on<WalletTransferInitial>(_mapWalletTransferInitialToState);
    on<TransferPhoneChanged>(_mapTransferPhoneChangedToState);
    on<TransferAmountChanged>(_mapTransferAmountChangedToState);
    on<TransferNoteChanged>(_mapTransferNoteChangedToState);
    on<TransferBtnClicked>(_mapTransferBtnClickedToState);
  }

  Future<void> _mapWalletTransferInitialToState(WalletTransferInitial event, Emitter<WalletTransferState> emit) async {
    emit(WalletTransferState());
  }

  Future<void> _mapTransferPhoneChangedToState(TransferPhoneChanged event, Emitter<WalletTransferState> emit) async {
    final phone = TransferPhone.dirty(event.phone);
    var isValid = Formz.validate([phone, state.amount]);
    emit(state.copyWith(phone: phone, status: isValid));
  }

  Future<void> _mapTransferAmountChangedToState(TransferAmountChanged event, Emitter<WalletTransferState> emit) async {
    final amount = TransferAmount.dirty(event.amount);
    var isValid = Formz.validate([amount, state.phone]);
    emit(state.copyWith(amount: amount, status: isValid));
  }

  Future<void> _mapTransferNoteChangedToState(TransferNoteChanged event, Emitter<WalletTransferState> emit) async {
    final note = event.note;
    emit(state.copyWith(note: note));
  }

  Future<void> _mapTransferBtnClickedToState(TransferBtnClicked event, Emitter<WalletTransferState> emit) async {
    var isBtnDisabled = event.isBtnDisabled;
    emit(state.copyWith(isBtnDisabled: isBtnDisabled));
  }
}
