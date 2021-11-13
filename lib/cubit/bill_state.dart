part of 'bill_cubit.dart';

abstract class BillState {
  List<Bill> bills = BillRepository.bills;
}

class BillInitial extends BillState {}

class AddBill extends BillState {
  final Bill bill;
  AddBill({required this.bill}) {
    BillRepository.insertBill(bill);
  }
}

class DelBill extends BillState {
  final String billNo;
  DelBill({required this.billNo}) {
    BillRepository.deleteBill(billNo);
  }
}
