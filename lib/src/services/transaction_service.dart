import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamble/src/screens/users/wallet_deposit/wallet_deposit.dart';
import 'package:gamble/src/screens/users/wallet_transaction/wallet_transaction.dart';
import 'package:gamble/src/screens/users/wallet_transaction_detail/wallet_transaction_detail.dart';
import 'package:http/http.dart' as http;

abstract class TransactionService {
  //on loaded
  Future<Map<String, dynamic>> getBalanceAndExchangeRate(String currency);
  //deposit
  Future<VNPay?> depositVNPay(String amount, int method);
  Future<Map<String, dynamic>> returnVNPayDespositResult(String url);
  //withdraw
  Future<Map<String, dynamic>> withdrawBank(String withdrawBank, String path);
  Future<Map<String, dynamic>> getBCAddress();
  Future<Map<String, dynamic>> withdrawBitcoin(String withdrawBitcoin, String path);
  //transfer  
  Future<Map<String, dynamic>> transfer(String transfer, String path);
  //transaction
  Future<List<TransactionListItem>> getTransactions(int page);
  Future<TransactionItemDetail?> getTransactionById(int transactionId);
}

class TransactionManagement extends TransactionService {
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    "auth": dotenv.env['TOKEN'].toString()
  };

  //on loaded
  Future<Map<String, dynamic>> getBalanceAndExchangeRate(String currency) async {
     Map<String, dynamic> result = <String, dynamic>{};
    try {
      final response = await http.get(Uri.parse("${dotenv.env['HOST']!}api/getExRateAndBalance?name=$currency"), headers: headers);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        var balance = jsonData.entries.firstWhere((e) => e.key == 'balance').value;
        var exchangeRate = jsonData.entries.firstWhere((e) => e.key == 'exchangeRate').value;
        result.addAll(<String, dynamic>{"balance":balance});
        result.addAll(<String, dynamic>{"exchangeRate":exchangeRate});
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  //deposit
  @override
  Future<VNPay?> depositVNPay(String amount, int method) async {
    try {
      var requestBody = json.encode({
        'amount': amount,
        'method': method,
      });
      final response = await http.post(Uri.parse("${dotenv.env['HOST']!}api/depositProcess"), headers: headers, body: requestBody);
      if (response.statusCode == 200) {
        var vnpay = VNPay.fromJson(jsonDecode(response.body));
        return vnpay;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> returnVNPayDespositResult(String url) async {
    Map<String, dynamic> result = <String, dynamic>{};
    try {
      final response = await http.get(Uri.parse("${dotenv.env['HOST']!}$url"));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        var code = jsonData.entries.firstWhere((e) => e.key == 'code').value;
        var message = jsonData.entries.firstWhere((e) => e.key == 'message').value;
        result.addAll(<String, dynamic>{"code":code});
        result.addAll(<String, dynamic>{"message":message});
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  //withdraw
  @override
  Future<Map<String, dynamic>> withdrawBank(String withdrawBank, String path) async {
    Map<String, dynamic> result = <String, dynamic>{};
    try {
      final response = await http.post(Uri.parse("${dotenv.env['HOST']!}api/$path"), headers: headers, body: withdrawBank);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        var code = jsonData.entries.firstWhere((e) => e.key == 'code').value;
        var message = jsonData['message'] != null ? jsonData['message'].toString() : null;
        var amount = jsonData['amount'] != null ? jsonData['amount'].toString() : null;
        result.addAll(<String, dynamic>{"code":code});
        result.addAll(<String, dynamic>{"amount":amount});
        result.addAll(<String, dynamic>{"message":message});
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getBCAddress() async {
    Map<String, dynamic> result = <String, dynamic>{};
    try {
      final response = await http.get(Uri.parse("${dotenv.env['HOST']!}api/generateBCAddress"), headers: headers);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        var bcaddress = jsonData.entries.firstWhere((e) => e.key == 'bcaddress').value;
        var transactionCode = jsonData.entries.firstWhere((e) => e.key == 'transactionCode').value;
        result.addAll(<String, dynamic>{"bcaddress":bcaddress});
        result.addAll(<String, dynamic>{"transactionCode":transactionCode});
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> withdrawBitcoin(String withdrawBitcoin, String path) async {
    Map<String, dynamic> result = <String, dynamic>{};
    try {
      final response = await http.post(Uri.parse("${dotenv.env['HOST']!}api/$path"), headers: headers, body: withdrawBitcoin);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        var code = jsonData.entries.firstWhere((e) => e.key == 'code').value;
        // ignore: prefer_null_aware_operators
        var message = jsonData['message'] != null ? jsonData['message'].toString() : null;
        // ignore: prefer_null_aware_operators
        var amount = jsonData['amount'] != null ? jsonData['amount'].toString() : null;
        result.addAll(<String, dynamic>{"code":code});
        result.addAll(<String, dynamic>{"message":message});
        result.addAll(<String, dynamic>{"amount":amount});
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  //transfer
  @override
  Future<Map<String, dynamic>> transfer(String transfer, String path) async {
    Map<String, dynamic> result = <String, dynamic>{};
    try {
      final response = await http.post(Uri.parse("${dotenv.env['HOST']!}api/$path"), headers: headers, body: transfer);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        var code = jsonData.entries.firstWhere((e) => e.key == 'code').value;
        var phone = jsonData['phone'] != null ? jsonData['phone'].toString() : null;
        var message = jsonData['message'] != null ? jsonData['message'].toString() : null;
        var amount = jsonData['amount'] != null ? jsonData['amount'].toString() : null;
        result.addAll(<String, dynamic>{"code":code});
        result.addAll(<String, dynamic>{"phone":phone});
        result.addAll(<String, dynamic>{"message":message});
        result.addAll(<String, dynamic>{"amount":amount});
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  //transaction
  @override
  Future<List<TransactionListItem>> getTransactions(int page) async {
    try {
      final response = await http.get(Uri.parse("${dotenv.env['HOST']!}api/user/transactions?page=$page"), headers: headers);
      if (response.statusCode == 200) {
        List<TransactionListItem> list = <TransactionListItem>[];
        for (var item in jsonDecode(response.body)) {
          list.add(TransactionListItem.fromJson(item));
        }
        return list;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      print(e);
      return <TransactionListItem>[];
    }
  }

  @override
  Future<TransactionItemDetail?> getTransactionById(int transactionId) async{
    try {
      final response = await http.get(Uri.parse("${dotenv.env['HOST']!}api/user/transaction?transactionId=$transactionId"), headers: headers);
      if (response. statusCode == 200) {
        return TransactionItemDetail.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}
