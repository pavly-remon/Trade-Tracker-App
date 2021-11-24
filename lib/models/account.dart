import 'package:resolution_app/utils/file_manager.dart';

import 'statement.dart';

enum Transaction {
  import,
  export,
}

class Account {
  String? id;
  Transaction transaction;
  String date;
  List<Statment> data;
  Account({
    this.id,
    required this.transaction,
    required this.date,
    required this.data,
  });

  double getTotalPrice() {
    double sum = 0.0;
    for (int i = 0; i < data.length; i++) {
      sum += (data[i].unitPrice * data[i].quantity);
    }
    return sum;
  }

  Map toJSON() {
    List<Map<String, Object?>> jsonData = [];
    for (int i = 0; i < data.length; i++) {
      jsonData.add(data[i].toJSON());
    }
    return {
      "id": id,
      "transaction": transaction.index,
      "date": date,
      "data": jsonData,
    };
  }

  static Account fromMapObject(Map<String, Object?> accountMap) {
    List<Statment> data = <Statment>[];
    dynamic accountDataMapList = accountMap['data'];
    if (accountMap['data'] != null) {
      for (int i = 0; i < accountDataMapList.length; i++) {
        data.add(Statment.fromMapObject(accountDataMapList[i]));
      }
    }
    if (accountMap['transaction'] == Transaction.import.index) {
      return Account(
        id: accountMap['id'] as String,
        transaction: Transaction.import,
        date: accountMap['date'] as String,
        data: data,
      );
    }
    return Account(
      id: accountMap['id'] as String,
      transaction: Transaction.export,
      date: accountMap['date'] as String,
      data: data,
    );
  }
}

class AccountRepository {
  bool _importData = false;
  static final List<Account> _accounts = [];

  AccountRepository() {
    importAccounts();
  }

  static List<Account> get accounts {
    return _accounts;
  }

  ///Add new account to list of accounts that are saved locally in device
  static void insertAccount(Account account) {
    try {
      _accounts.add(Account(
        id: _accounts.length.toString(),
        transaction: account.transaction,
        date: account.date,
        data: account.data,
      ));
      FileManager.writeAccounts(_accounts);
    } catch (e) {
      rethrow;
    }
  }

  static void deleteAccount(String id) {
    try {
      _accounts.removeWhere((element) => element.id == id);
      FileManager.writeAccounts(_accounts);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> importAccounts() async {
    try {
      if (!_importData) {
        await FileManager.readAccounts().then((value) {
          if (value != null) {
            for (int i = 0; i < value['Accounts'].length; i++) {
              _accounts.add(Account.fromMapObject(value['Accounts'][i]));
            }
          }
        });
        _importData = true;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Calculate the summation of all transactions
  static double totalMoney() {
    double total = 0.0;
    for (int i = 0; i < _accounts.length; i++) {
      if (_accounts[i].transaction == Transaction.import) {
        total += _accounts[i].getTotalPrice();
      } else {
        total -= _accounts[i].getTotalPrice();
      }
    }
    return total;
  }
}
