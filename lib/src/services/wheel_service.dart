import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamble/src/screens/users/profile/profile.dart';
import 'package:gamble/src/screens/users/profile_edit_info/models/user_profile_update.dart';
import 'package:gamble/src/screens/wheel/models/wheel_attributes.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

abstract class WheelService {
  Future<List<dynamic>> getBalanceAndWheelAttributes();
  Future<Map<String, dynamic>> returnWheelResult(String betAmount, bool isPartialBet);
}

class WheelManagement extends WheelService {
  final headers = { 
    HttpHeaders.contentTypeHeader:'application/json',
    "auth": '${dotenv.env['TOKEN']}'
  };

  @override
  Future<List<dynamic>> getBalanceAndWheelAttributes() async {
    List<dynamic> lists = List<dynamic>.empty(growable: true);
    try {
      final response = await http.get(Uri.parse("${dotenv.env['HOST']!}api/getSliceArrays"), headers: headers);
      if(response.statusCode == 200){
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        var balance = jsonData.entries.firstWhere((e) => e.key == 'balance').value;
        lists.add(NumberFormat.currency(customPattern: "#,###.", decimalDigits: 4).format(balance));
        //list a
        var a = jsonData.entries.firstWhere((e) => e.key == 'slices1').value;
        List<WheelAttributes> listA = <WheelAttributes>[];
        for(var i = 0; i < a.length; i++){
          listA.add(WheelAttributes.fromJson(jsonData, 1, i));
        }
        lists.add(listA);
        //list b
        var b = jsonData.entries.firstWhere((e) => e.key == 'slices2').value;
        List<WheelAttributes> listB = <WheelAttributes>[];
        for(var i = 0; i < b.length; i++){
          listB.add(WheelAttributes.fromJson(jsonData, 2, i));
        }
        lists.add(listB);
        //list c
        var c = jsonData.entries.firstWhere((e) => e.key == 'slices3').value;
        List<WheelAttributes> listC = <WheelAttributes>[];
        for(var i = 0; i < c.length; i++){
          listC.add(WheelAttributes.fromJson(jsonData, 3, i));
        }
        lists.add(listC);
      } 
    } catch (e) {
      print(e);
    }
    return lists;
  }
  
  @override//9704198526191432198
  Future<Map<String, dynamic>> returnWheelResult(String betAmount, bool isPartialBet) async {
    Map<String, dynamic> result = <String, dynamic>{};
    try {
      var requestBody = jsonEncode({
        "betAmount": betAmount,
        "isPartialBet" : isPartialBet
      });
      final response = await http.post(Uri.parse("${dotenv.env['HOST']!}api/wheels/result"), headers: headers, body: requestBody);
      if(response.statusCode == 200){
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        var code = jsonData.entries.firstWhere((e) => e.key == 'code').value;
        var message = jsonData.entries.firstWhere((e) => e.key == 'message').value;
        var status = jsonData['status'] != null ? int.parse(jsonData['status'].toString()) : null;
        var balance = jsonData['balance'] != null ? NumberFormat.currency(customPattern: "#,###.", decimalDigits: 4).format(jsonData['balance']) : null;
        var sm = jsonData['sm'] != null ? int.parse(jsonData['sm'].toString()) : null;
        var md = jsonData['md'] != null ? int.parse(jsonData['md'].toString()) : null;
        var lg = jsonData['lg'] != null ? int.parse(jsonData['lg'].toString()) : null;
        var small = jsonData['small'] != null ? jsonData['small'].toString() : null;
        var medium = jsonData['medium'] != null ? jsonData['medium'].toString() : null;
        var large = jsonData['large'] != null ? jsonData['large'].toString() : null;
        result.addAll(<String, dynamic>{"code":code});
        result.addAll(<String, dynamic>{"message":message});
        result.addAll(<String, dynamic>{"status":status});
        result.addAll(<String, dynamic>{"balance":balance});
        result.addAll(<String, dynamic>{"sm":sm});
        result.addAll(<String, dynamic>{"md":md});
        result.addAll(<String, dynamic>{"lg":lg});
        result.addAll(<String, dynamic>{"small":small});
        result.addAll(<String, dynamic>{"medium":medium});
        result.addAll(<String, dynamic>{"large":large});
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

}