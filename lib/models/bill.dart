import 'package:flutter/cupertino.dart';
import 'package:resolution_app/models/file_manager.dart';

class BillData {
  String itemName;
  int quantity;
  double unitPrice;

  BillData({
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
  });

  Map<String, Object?> toJSON() {
    return {
      "Item": itemName,
      "Quantity": quantity,
      "Price": unitPrice,
    };
  }

  static BillData fromMapObject(Map<String, Object?> billDataMap) {
    return BillData(
      itemName: billDataMap['Item'] as String,
      quantity: billDataMap['Quantity'] as int,
      unitPrice: billDataMap['Price'] as double,
    );
  }
}

class Bill {
  String billNo;
  String companyName;
  String date;
  List<BillData> billData;

  Bill({
    required this.billNo,
    required this.companyName,
    required this.date,
    required this.billData,
  });

  static Bill fromMapObject(Map<String, Object?> billMap) {
    List<BillData> billData = <BillData>[];
    dynamic billDataMapList = billMap['billData'];
    if (billMap['billData'] != null) {
      for (int i = 0; i < billDataMapList.length; i++) {
        billData.add(BillData.fromMapObject(billDataMapList[i]));
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

class Bills with ChangeNotifier {
  // ignore: prefer_final_fields
  bool _importData = false;
  final List<Bill> _bills = [];
  List<Bill> get billsList {
    return _bills;
  }

  Future<void> importData() async {
    try {
      if (!_importData) {
        await FileManager.readBills().then((value) {
          if (value != null) {
            for (int i = 0; i < value['Bills'].length; i++) {
              _bills.add(Bill.fromMapObject(value['Bills'][i]));
            }
          }
        });
        _importData = true;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  void insertBill(Bill bill) {
    try {
      _bills.add(bill);
      _bills.sort((a, b) => int.parse(a.billNo).compareTo(int.parse(b.billNo)));
      FileManager.writeBills(_bills);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void deleteBill(String billNo) {
    try {
      _bills.removeWhere((element) => element.billNo == billNo);
      FileManager.writeBills(_bills);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  List<Bill> searchBill(String? search) {
    if (search == null || search == '') {
      return _bills;
    }
    return _bills
        .where((element) =>
            element.companyName.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }
}
