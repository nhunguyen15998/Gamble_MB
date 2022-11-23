import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:gamble/src/screens/wheel/wheel.dart';
import 'package:gamble/src/services/wheel_service.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';

part 'wheel_event.dart';
part 'wheel_state.dart';

class WheelBloc extends Bloc<WheelEvent, WheelState> {
  WheelService wheelService;
  WheelBloc(this.wheelService) : super(const WheelState()) {
    on<WheelInitial>(_mapWheelInitialToState);
    on<AmountChanged>(_mapAmountChangedToState);
    on<WheelButtonsDisabled>(_mapWheelButtonsDisabledToState);
    on<WheelPaused>(_mapWheelPausedToState);
    on<WheelBoardChanged>(_mapWheelBoardChangedToState);
    on<WheelBalanceAndStatusUpdated>(_mapWheelBalanceAndStatusUpdatedToState);
    on<WheelRefreshed>(_mapWheelRefreshedToState);
    on<WheelInsaneBetButtonClicked>(_mapWheelInsaneBetButtonClickedToState);
  }

  Future<void> _mapWheelInitialToState(WheelInitial event, Emitter<WheelState> emit) async {
    try {
      final wheels = await wheelService.getBalanceAndWheelAttributes();
      if(wheels != null){
        emit(WheelInitialized(balance: wheels[0], listA: wheels[1], listB: wheels[2], listC: wheels[3]));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _mapAmountChangedToState(AmountChanged event, Emitter<WheelState> emit) async {
    final betAmount = event.betAmount;
    WheelInitialized wheelInitialized = state as WheelInitialized;
    emit(wheelInitialized.copyWith(betAmount: betAmount));
  }

  Future<void> _mapWheelButtonsDisabledToState(WheelButtonsDisabled event, Emitter<WheelState> emit) async {
    final isBtnDisabled = event.isBtnDisabled;
    WheelInitialized wheelInitialized = state as WheelInitialized;
    emit(wheelInitialized.copyWith(isBtnDisabled: isBtnDisabled));
  }

  Future<void> _mapWheelPausedToState(WheelPaused event, Emitter<WheelState> emit) async {
    final resultLabel = event.resultLabel;
    final hasResult = event.hasResult;
    WheelInitialized wheelInitialized = state as WheelInitialized;
    emit(wheelInitialized.copyWith(resultLabel: resultLabel, hasResult: hasResult));
  }

  Future<void> _mapWheelBoardChangedToState(WheelBoardChanged event, Emitter<WheelState> emit) async {
    final isNext = event.isNext;
    final hasResult = event.hasResult;
    final round = event.round;
    WheelInitialized wheelInitialized = state as WheelInitialized;
    emit(wheelInitialized.copyWith(isNext: isNext, hasResult: hasResult, round: round));
  }

  Future<void> _mapWheelBalanceAndStatusUpdatedToState(WheelBalanceAndStatusUpdated event, Emitter<WheelState> emit) async {
    final resultStatus = event.resultStatus;
    final balance = event.balance;
    WheelInitialized wheelInitialized = state as WheelInitialized;
    emit(wheelInitialized.copyWith(balance: balance, resultStatus: resultStatus));
  }

  Future<void> _mapWheelRefreshedToState(WheelRefreshed event, Emitter<WheelState> emit) async {
    final resultStatus = event.resultStatus;
    final hasResult = event.hasResult;
    final isNext = event.isNext;
    final round = event.round;
    WheelInitialized wheelInitialized = state as WheelInitialized;
    emit(wheelInitialized.copyWith(resultStatus: resultStatus, hasResult: hasResult, isNext: isNext, round: round));
  }

  Future<void> _mapWheelInsaneBetButtonClickedToState(WheelInsaneBetButtonClicked event, Emitter<WheelState> emit) async {
    final betAmount = event.betAmount;
    WheelInitialized wheelInitialized = state as WheelInitialized;
    emit(wheelInitialized.copyWith(betAmount: betAmount));
  }

}
