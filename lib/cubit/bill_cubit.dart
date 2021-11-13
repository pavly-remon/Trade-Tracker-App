import 'package:bloc/bloc.dart';
import 'package:resolution_app/models/bill.dart';

part 'bill_state.dart';

class BillCubit extends Cubit<BillState> {
  BillCubit() : super(BillInitial());
  void add(Bill bill) => emit(AddBill(bill: bill));
  void remove(String billNo) => emit(DelBill(billNo: billNo));
}
