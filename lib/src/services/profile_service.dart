import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamble/src/screens/users/profile/profile.dart';
import 'package:http/http.dart' as http;

abstract class ProfileService {
  Future<Profile?> getUserProfile();
}

class ProfileManagement extends ProfileService {
  final headers = { HttpHeaders.contentTypeHeader: 'application/json' ,
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
}