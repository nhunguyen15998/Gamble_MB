import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:gamble/src/screens/users/models/model.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationService {
  Future<User?> getCurrentUser();
  Future<User?> signInAction(String phone, String password);
  Future<bool> signUpAction(String firstName, String lastName, String email,
      String phone, String password, String confirmedPassword);
  Future<void>? signOut();
}

class FakeAuthenticationService extends AuthenticationService {
  @override
  Future<User?> getCurrentUser() async {
    return null; // return null for now
  }

  @override
  Future<User?> signInAction(String phone, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate a network delay
    var requestBody = json.encode({
      'phone': phone,
      'plain_password': password,
    });
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(Uri.http('localhost:9090','/api/user/authenticate'), body: requestBody, headers: headers);
    Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      var code = jsonData.entries.firstWhere((e) => e.key == 'code').value;
      var message = jsonData.entries.firstWhere((e) => e.key == 'msg').value;
      if(code != 200){
        throw Exception(message);
      }
      var user = jsonData.entries.firstWhere((e) => e.key == 'user').value as Map<String, dynamic>;
      var token = jsonData.entries.firstWhere((e) => e.key == 'token').value;
      print(user);
      print(token);
      print(message);
      return User.fromJson(user);
    } else {
      var message = jsonData.entries.firstWhere((e) => e.key == 'msg').value;
      throw Exception(message);
    }
  }

  @override
  Future<bool> signUpAction(String firstName, String lastName, String email, String phone, String password, String confirmedPassword) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate a network delay
    var requestBody = json.encode({
      'first_name': firstName,
      'last_name': lastName,
      'email': email, 
      'phone': phone,
      'plain_password': password,
      'confirm_password': confirmedPassword
    });
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(Uri.http('localhost:9090','/api/user/register'), body: requestBody, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
      var code = jsonData.entries.firstWhere((e) => e.key == 'code').value;
      var message = jsonData.entries.firstWhere((e) => e.key == 'msg').value;
      if(code != 200){
        print(message);
        return false;
      }
      print(code);
      print(message);
      return true;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Future<void>? signOut() {
    return null;
  }
}
