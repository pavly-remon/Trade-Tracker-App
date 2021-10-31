import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'bill.dart';

class FileManager {
  static Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  static Future<File> get _localFileBills async {
    final path = await _localPath;
    return File('$path/bills.json');
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
    return file.writeAsString(jsonBills);
  }

  static Future<Map?> readBills() async {
    try {
      final file = await _localFileBills;

      // Read the file
      final contents = await file.readAsString();
      return json.decode(contents);
    } catch (e) {
      return null;
    }
  }
}
