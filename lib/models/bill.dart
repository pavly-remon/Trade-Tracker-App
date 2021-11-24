import 'package:resolution_app/utils/file_manager.dart';

import 'statement.dart';

class Bill {
  String billNo;
  String companyName;
  String date;
  List<Statment> billData;

  Bill({
    required this.billNo,
    required this.companyName,
    required this.date,
    required this.billData,
  });

  static Bill fromMapObject(Map<String, Object?> billMap) {
    List<Statment> billData = <Statment>[];
    dynamic billDataMapList = billMap['billData'];
    if (billMap['billData'] != null) {
      for (int i = 0; i < billDataMapList.length; i++) {
        billData.add(Statment.fromMapObject(billDataMapList[i]));
      }
    }
    return Bill(
      billNo: billMap['billNo'] as String,
      companyName: billMap['companyName'] as String,
      date: billMap['date'] as String,
      billData: billData,
    );
  }

  double getTotalPriceWithTax() {
    double sum = 0.0;
    for (int i = 0; i < billData.length; i++) {
      sum += (billData[i].unitPrice * billData[i].quantity);
    }
    return sum * (1.14);
  }

  Map toJSON() {
    List<Map<String, Object?>> jsonBillData = [];
    for (int i = 0; i < billData.length; i++) {
      jsonBillData.add(billData[i].toJSON());
    }
    return {
      "billNo": billNo,
      "companyName": companyName,
      "date": date,
      "billData": jsonBillData,
    };
  }
}

class BillRepository {
  bool _importData = false;
  static final List<Bill> bills = [];

  BillRepository() {
    _importBills();
  }

  Future<void> _importBills() async {
    try {
      if (!_importData) {
        await FileManager.readBills().then((value) {
          if (value != null) {
            for (int i = 0; i < value['Bills'].length; i++) {
              bills.add(Bill.fromMapObject(value['Bills'][i]));
            }
          }
        });
        _importData = true;
      }
    } catch (e) {
      rethrow;
    }
  }

  static void insertBill(Bill bill) {
    try {
      bills.add(bill);
      bills.sort((a, b) => int.parse(a.billNo).compareTo(int.parse(b.billNo)));
      FileManager.writeBills(bills);
    } catch (e) {
      rethrow;
    }
  }

  static void deleteBill(String billNo) {
    try {
      bills.removeWhere((element) => element.billNo == billNo);
      FileManager.writeBills(bills);
    } catch (e) {
      rethrow;
    }
  }
}
