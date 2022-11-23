import 'package:flutter/material.dart';

enum TransactionStatus { pending, successfully, failed }
enum TransactionType { deposited, withdrawed, transferred }
enum TransactionMethod { vnpay, momo, bitcoin }
enum TransactionWithdrawMethod { bitcoin, bank }

enum GameStatus { lose, win, drawn }

class Helpers {
  static String toStatus(int status){
    String loadedStatus = TransactionStatus.pending.name;
    switch (status) {
      case 0:
        break;
      case 1:
        loadedStatus = TransactionStatus.successfully.name;
        break;
      case 2:
        loadedStatus = TransactionStatus.failed.name;
        break;
    }
    return loadedStatus;
  }

  static String toMethod(int method){
    String image = "lib/assets/images/vnpay.png";
    switch (method) {
      case 0:
        break;
      case 1:
        image = "lib/assets/images/momo.png";
        break;
      case 2:
        image = "lib/assets/images/bitcoin.png";
        break;
    }
    return image;
  }

  static String toWithdrawMethod(int method){
    String txt = "lib/assets/images/bitcoin.png";
    switch (method) {
      case 0:
        break;
      case 1:
        txt = "lib/assets/images/bank.png";
        break;
    }
    return txt;
  }

  static String toType(int type){
    String loadedType = TransactionType.deposited.name;
    switch (type) {
      case 0:
        break;
      case 1:
        loadedType = TransactionType.withdrawed.name;
        break;
      case 2:
        loadedType = TransactionType.transferred.name;
        break;
    }
    return loadedType;
  }

  //game status
  static String toGameStringStatus(int status){
    String loadedStatus = GameStatus.lose.name;
    switch (status) {
      case 0:
        break;
      case 1:
        loadedStatus = GameStatus.win.name;
        break;
      case 2:
        loadedStatus = GameStatus.drawn.name;
        break;
    }
    return loadedStatus;
  }

 static void loadingAlert(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}