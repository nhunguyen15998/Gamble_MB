import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamble/src/screens/users/profile/profile.dart';
import 'package:gamble/src/screens/users/profile_edit_info/models/user_profile_update.dart';
import 'package:gamble/src/utils/helpers.dart';
import 'package:http/http.dart' as http;

abstract class ProfileService {
  Future<Profile?> getUserProfile();
  Future<bool> updateUserProfile(ProfileUpdate profileUpdate);
  Future<Map<String, dynamic>> changePassword(String request);
}

class ProfileManagement extends ProfileService {
  final headers = { 
    HttpHeaders.contentTypeHeader:'application/json',
    //'${dotenv.env['TOKEN']}'
  };

  @override
  Future<Profile?> getUserProfile() async {
    var token = await Helpers.getCurrentToken();
    headers.addAll(<String, String>{"auth" : token.toString()});
    try {
      final response = await http.get(Uri.parse("${dotenv.env['HOST']!}api/get-user"), headers: headers);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return Profile.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<bool> updateUserProfile(ProfileUpdate profileUpdate) async {
    var token = await Helpers.getCurrentToken();
    headers.addAll(<String, String>{"auth" : token.toString()});
    try {
      var requestBody = jsonEncode({
        "first_name": profileUpdate.firstName,
        "last_name": profileUpdate.lastName,
        "email": profileUpdate.email,
        "birth": profileUpdate.birth,
        "gender": '${profileUpdate.gender}'
      });
      final response = await http.post(Uri.parse("${dotenv.env['HOST']!}api/update-user"), headers: headers, body: requestBody);
      Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        var code = jsonData.entries.firstWhere((e) => e.key == 'code').value;
        var message = jsonData.entries.firstWhere((e) => e.key == 'message').value;
        if(code != 200){
          throw Exception(message);
        }
        return true;
      }
    } catch (e) {
      print(e);
      
    }
    return false;
  }

  @override
  Future<Map<String, dynamic>> changePassword(String request) async {
    Map<String, dynamic> result = <String, dynamic>{};
    var token = await Helpers.getCurrentToken();
    headers.addAll(<String, String>{"auth" : token.toString()});
    try {
      final response = await http.post(Uri.parse("${dotenv.env['HOST']!}api/user/change-password"), headers: headers, body: request);
      Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
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

}