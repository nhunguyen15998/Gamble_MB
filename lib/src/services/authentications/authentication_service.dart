import 'package:gamble/src/screens/users/models/model.dart';

abstract class AuthenticationService {
  Future<User?> getCurrentUser();
  Future<User> signInAction(String phone, String password);
  Future<void>? signOut();
}

class FakeAuthenticationService extends AuthenticationService {
  @override
  Future<User?> getCurrentUser() async {
    return null; // return null for now
  }

  @override
  Future<User> signInAction(String phone, String password) async {
    await Future.delayed(
        const Duration(seconds: 1)); // simulate a network delay

    if (phone.toLowerCase() != '0849345639' || password != '123456') {
      throw Exception('Wrong username or password');
    }
    return User(name: 'Nguyễn Thị Như', email: phone);
  }

  @override
  Future<void>? signOut() {
    return null;
  }
}
