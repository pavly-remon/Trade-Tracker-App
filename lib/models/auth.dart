import 'package:resolution_app/models/password.dart';

class Authentication {
  static const _password = password;

  static bool checkPW(String pw) {
    if (pw == _password) {
      return true;
    }
    return false;
  }
}
