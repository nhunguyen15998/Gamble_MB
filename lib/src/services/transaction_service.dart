import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamble/src/screens/users/wallet_deposit/wallet_deposit.dart';
import 'package:gamble/src/screens/users/wallet_transaction/wallet_transaction.dart';
import 'package:gamble/src/screens/users/wallet_transaction_detail/wallet_transaction_detail.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

abstract class TransactionService {
  //deposit
  Future<Uri?> depositVNPay(String amount, int method);
  Future<Map<String, dynamic>> returnVNPayDespositResult(String url);
  //withdraw
  Future<Map<String, dynamic>> withdrawBank(String withdrawBank);
  Future<Map<String, dynamic>> getBCAddress();
  Future<Map<String, dynamic>> withdrawBitcoin(String withdrawBitcoin);
  //transfer  
  Future<void> transfer();
  //transaction
  Future<List<TransactionListItem>> getTransactions(int page);
  Future<TransactionItemDetail?> getTransactionById(int transactionId);
}

class TransactionManagement extends TransactionService {
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    "auth": dotenv.env['TOKEN'].toString()
  };

  //deposit
  @override
  Future<Uri?> depositVNPay(String amount, int method) async {
    try {
      var requestBody = json.encode({
        'amount': amount,
        'method': method,
      });
      final response = await http.post(Uri.parse("${dotenv.env['HOST']!}api/depositProcess"), headers: headers, body: requestBody);
      if (response.statusCode == 200) {
        var vnpay = VNPay.fromJson(jsonDecode(response.body));
        var url = Uri.parse(vnpay.data);//'https://www.google.com/');
        return url;
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
  Future<Map<String, dynamic>> withdrawBank(String withdrawBank) async {
    Map<String, dynamic> result = <String, dynamic>{};
    try {
      final response = await http.post(Uri.parse("${dotenv.env['HOST']!}api/withdrawBankProccess"), headers: headers, body: withdrawBank);
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

  Future<Map<String, dynamic>> withdrawBitcoin(String withdrawBitcoin) async {
    Map<String, dynamic> result = <String, dynamic>{};
    try {
      final response = await http.post(Uri.parse("${dotenv.env['HOST']!}api/withdrawBitcoinProccess"), headers: headers, body: withdrawBitcoin);
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
  Future<void> transfer() async {
    try {
      
    } catch (e) {
      print(e);
    }
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
