import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamble/src/screens/users/profile/profile.dart';
import 'package:gamble/src/screens/users/profile_edit_info/models/user_profile_update.dart';
import 'package:http/http.dart' as http;

abstract class ProfileService {
  Future<Profile?> getUserProfile();
  Future<bool> updateUserProfile(ProfileUpdate profileUpdate);
}

class ProfileManagement extends ProfileService {
  final headers = { 
    HttpHeaders.contentTypeHeader:'application/json',
    "auth": '${dotenv.env['TOKEN']}'
  };

  @override
  Future<Profile?> getUserProfile() async {
    try {
      final response = await http.get(Uri.parse("${dotenv.env['HOST']!}api/get-user"), headers: headers);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return Profile.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> updateUserProfile(ProfileUpdate profileUpdate) async {
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

}