import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:resolution_app/models/account.dart';

import '../models/bill.dart';
import 'encrypt_manager.dart';

class FileManager {
  static Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory

    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path}/$folderName/');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  static Future<File> get _localFileBills async {
    final path = await createFolderInAppDocDir('Resolution-Data');
    return File('$path/bills');
  }

  static Future<File> get _localFileTransactions async {
    final path = await createFolderInAppDocDir('Resolution-Data');
    return File('$path/transactions');
  }

  static Future<File> writeBills(List<Bill> bills) async {
    final file = await _localFileBills;
    String jsonBills = '{ "Bills":[';
    for (var i = 0; i < bills.length; i++) {
      jsonBills += jsonEncode(bills[i].toJSON());
      if (i < bills.length - 1) {
        jsonBills += ',';
      }
    }
    jsonBills += ']}';
    // Write the file
    return file.writeAsString(EncryptManager.encrypt(jsonBills));
  }

  static Future<Map?> readBills() async {
    try {
      final file = await _localFileBills;

      // Read the file
      final contents = await file.readAsString();
      return json.decode(EncryptManager.decrypt(contents));
    } catch (e) {
      return null;
    }
  }

  static Future<File> writeAccounts(List<Account> accounts) async {
    final file = await _localFileTransactions;
    String jsonAccounts = '{ "Accounts":[';
    for (var i = 0; i < accounts.length; i++) {
      jsonAccounts += jsonEncode(accounts[i].toJSON());
      if (i < accounts.length - 1) {
        jsonAccounts += ',';
      }
    }
    jsonAccounts += ']}';
    // Write the file
    return file.writeAsString(EncryptManager.encrypt(jsonAccounts));
  }

  static Future<Map?> readAccounts() async {
    try {
      final file = await _localFileTransactions;

      // Read the file
      final contents = await file.readAsString();
      return json.decode(EncryptManager.decrypt(contents));
    } catch (e) {
      return null;
    }
  }
}
