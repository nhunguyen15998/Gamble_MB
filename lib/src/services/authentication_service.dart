import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gamble/src/screens/users/models/model.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationService {
  Future<User?> getCurrentUser();
  Future<Map<String, dynamic>> signInAction(String phone, String password);
  Future<Map<String, dynamic>> signUpAction(String firstName, String lastName, String email,
      String phone, String password, String confirmedPassword);
  Future<void>? signOut();
}

class FakeAuthenticationService extends AuthenticationService {
  @override
  Future<User?> getCurrentUser() async {
    return null; // return null for now
  }

  @override
  Future<Map<String, dynamic>> signInAction(String phone, String password) async {
    Map<String, dynamic> result = <String, dynamic>{};
    var requestBody = json.encode({
      'phone': phone,
      'plain_password': password,
    });
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    try {
      final response = await http.post(Uri.parse('${dotenv.env['HOST']!}api/user/authenticate'), body: requestBody, headers: headers);
      Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        var code = jsonData.entries.firstWhere((e) => e.key == 'code').value;
        var message = jsonData.entries.firstWhere((e) => e.key == 'message').value;
        var user = jsonData['user'] != null ? jsonData.entries.firstWhere((e) => e.key == 'user').value as Map<String, dynamic> : null;
        var token = jsonData['token'] != null ? jsonData.entries.firstWhere((e) => e.key == 'token').value : null;

        // const storage = FlutterSecureStorage();
        // await storage.write(key: 'token', value: token);
        result.addAll(<String, dynamic>{"code":code});
        result.addAll(<String, dynamic>{"message":message});
        if(user != null){
          var usr = User.fromJson(user);
          result.addAll(<String, dynamic>{"user":usr});
          result.addAll(<String, dynamic>{"token":token});
        } 
      } else {
        result.addAll(<String, dynamic>{"code":jsonData['code']});
        result.addAll(<String, dynamic>{"message":jsonData['message']});
      }
    } catch(e) {
      print(e);
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> signUpAction(String firstName, String lastName, String email, String phone, String password, String confirmedPassword) async {
    Map<String, dynamic> result = <String, dynamic>{};
    var requestBody = json.encode({
      'first_name': firstName,
      'last_name': lastName,
      'email': email, 
      'phone': phone,
      'plain_password': password,
      'confirm_password': confirmedPassword
    });
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    try {
      final response = await http.post(Uri.parse('${dotenv.env['HOST']!}api/user/register'), body: requestBody, headers: headers);
      Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        var code = jsonData.entries.firstWhere((e) => e.key == 'code').value;
        var message = jsonData.entries.firstWhere((e) => e.key == 'message').value;
        result.addAll(<String, dynamic>{"code":code});
        result.addAll(<String, dynamic>{"message":message});
      } else {
        result.addAll(<String, dynamic>{"code":400});
        result.addAll(<String, dynamic>{"message":jsonData['errors'][0]['defaultMessage']});
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  @override
  Future<void>? signOut() {
    return null;
  }
}
