import 'package:encrypt/encrypt.dart';

class EncryptManager {
  static final _key = Key.fromLength(32);
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(AES(_key));

  static String encrypt(String data) {
    return _encrypter.encrypt(data, iv: _iv).base64.toString();
  }

  static String decrypt(String encryptedData) {
    return _encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: _iv);
  }
}
