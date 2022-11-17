part of 'wheel_bloc.dart';

class WheelEvent extends Equatable {
  const WheelEvent();
  
  @override
  List<Object?> get props => [];
}

class WheelInitial extends WheelEvent {
  const WheelInitial();
  
  @override
  List<Object?> get props => [];
}

class AmountChanged extends WheelEvent {
  AmountChanged({
    required this.betAmount
  });

  String betAmount;

  @override
  List<Object?> get props => [betAmount];
}

//lock btns
class WheelButtonsDisabled extends WheelEvent {
  WheelButtonsDisabled({
    required this.isBtnDisabled
  });

  bool isBtnDisabled;
  
  @override
  List<Object?> get props => [isBtnDisabled];
}

//pause spinning to show result
class WheelPaused extends WheelEvent {
  WheelPaused({
    required this.resultLabel,
    required this.hasResult,
  });

  String resultLabel;
  bool hasResult;

  @override
  List<Object?> get props => [resultLabel, hasResult];
}

//change board content 
class WheelBoardChanged extends WheelEvent {
  WheelBoardChanged({
    this.isNext = 0,
    this.hasResult = false,
    required this.round,
  });

  int isNext;
  bool hasResult;
  String round;
  
  @override
  List<Object?> get props => [isNext, hasResult, round];
}

//update balance when game ends
class WheelBalanceAndStatusUpdated extends WheelEvent {
  WheelBalanceAndStatusUpdated({
    required this.balance,
    required this.resultStatus
  });

  String balance;
  String resultStatus;

  @override
  List<Object?> get props => [balance, resultStatus];
}

//refresh to new game
class WheelRefreshed extends WheelEvent {
  WheelRefreshed({
    required this.resultStatus,
    required this.hasResult,
    required this.isNext,
    this.round = 'Round 1',
  });

  String resultStatus;
  bool hasResult;
  int isNext;
  String round;

  @override
  List<Object?> get props => [resultStatus, hasResult, isNext, round];
}