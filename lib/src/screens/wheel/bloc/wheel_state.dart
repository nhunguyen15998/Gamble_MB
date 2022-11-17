part of 'wheel_bloc.dart';

class WheelState extends Equatable {
  const WheelState();

  @override
  List<Object?> get props => [];
}

class WheelInitialized extends WheelState {
  WheelInitialized({
    required this.balance,
    this.listA = const <WheelAttributes>[],
    this.listB = const <WheelAttributes>[],
    this.listC = const <WheelAttributes>[],
    this.betAmount = '',
    this.result = const <String, dynamic>{},

    this.resultLabel = '',
    this.hasResult = false,
    this.isNext = 0,
    this.resultStatus = '',
    this.isBtnDisabled = false,
    this.round = 'Round 1'
  });
  
  String balance;
  List<WheelAttributes> listA;
  List<WheelAttributes> listB;
  List<WheelAttributes> listC;
  String betAmount;
  Map<String, dynamic>? result;

  String resultLabel;
  bool hasResult;
  int isNext;
  String resultStatus;
  bool isBtnDisabled;
  String round;

  WheelInitialized copyWith({
    String? betAmount,
    Map<String, dynamic>? result,
    String? balance,
    List<WheelAttributes>? listA,
    List<WheelAttributes>? listB,
    List<WheelAttributes>? listC,

    String? resultLabel,
    bool? hasResult,
    int? isNext,
    String? resultStatus,
    bool? isBtnDisabled,
    String? round,
  }){
    return WheelInitialized(
      betAmount: betAmount ?? this.betAmount,
      result: result ?? this.result,
      balance: balance ?? this.balance,
      listA: listA ?? this.listA,
      listB: listB ?? this.listB,
      listC: listC ?? this.listC,

      resultLabel: resultLabel ?? this.resultLabel,
      hasResult: hasResult ?? this.hasResult,
      isNext: isNext ?? this.isNext,
      resultStatus: resultStatus ?? this.resultStatus,
      isBtnDisabled: isBtnDisabled ?? this.isBtnDisabled,
      round: round ?? this.round
    );
  }

  @override
  List<Object?> get props => [balance, listA, listB, listC, result, betAmount, resultStatus,
                              resultLabel, hasResult, isNext, isBtnDisabled, round];
}
