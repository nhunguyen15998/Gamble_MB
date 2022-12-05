import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamble/src/screens/users/wallet_deposit/wallet_deposit.dart';
import 'package:gamble/src/screens/users/wallet_transaction/wallet_transaction.dart';
import 'package:gamble/src/screens/users/wallet_transaction_detail/wallet_transaction_detail.dart';
import 'package:gamble/src/utils/helpers.dart';
import 'package:http/http.dart' as http;

abstract class SettingsService {
  //on loaded
  Future<Map<String, dynamic>> getSettingConfigs();
  //update
  Future<Map<String, dynamic>> updateSettingConfigs(String config, String path);
  //update with password
}

class SettingsManagement extends SettingsService {
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    //dotenv.env['TOKEN'].toString()
  };

  @override
  Future<Map<String, dynamic>> getSettingConfigs() async {
    Map<String, dynamic> result = <String, dynamic>{};
    var token = await Helpers.getCurrentToken();
    headers.addAll(<String, String>{"auth" : token.toString()});
    try {
      final response = await http.get(Uri.parse("${dotenv.env['HOST']!}/api/user/configs"), headers: headers);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        var code = jsonData.entries.firstWhere((e) => e.key == 'code').value;
        var message = jsonData['message'] != null ? jsonData['message'].toString() : null;
        var config = jsonData['configs'] != null ? jsonData['configs'].toString() : null;
        result.addAll(<String, dynamic>{"code":code});
        result.addAll(<String, dynamic>{"message":message});
        result.addAll(<String, dynamic>{"config":config});
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  //update
  @override
  Future<Map<String, dynamic>> updateSettingConfigs(String config, String path) async {
    Map<String, dynamic> result = <String, dynamic>{};
    var token = await Helpers.getCurrentToken();
    headers.addAll(<String, String>{"auth" : token.toString()});
    try {
      final response = await http.post(Uri.parse("${dotenv.env['HOST']!}/api/$path"), headers: headers, body: config);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        var code = jsonData.entries.firstWhere((e) => e.key == 'code').value;
        var message = jsonData['message'] != null ? jsonData['message'].toString() : null;
        result.addAll(<String, dynamic>{"code":code});
        result.addAll(<String, dynamic>{"message":message});
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

}
