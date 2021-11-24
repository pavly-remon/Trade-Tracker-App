class Authentication {
  static const _password = '85246';

  static bool checkPW(String pw) {
    if (pw == _password) {
      return true;
    }
    return false;
  }
}
