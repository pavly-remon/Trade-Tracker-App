import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:resolution_app/cubit/bill_cubit.dart';
import 'package:resolution_app/models/bill.dart';
import 'package:resolution_app/models/statement.dart';
import 'package:resolution_app/widgets/app_bar.dart';
import 'package:resolution_app/widgets/insert_data.dart';

class InsertBillScreen extends StatefulWidget {
  const InsertBillScreen({Key? key}) : super(key: key);

  @override
  _InsertBillScreenState createState() => _InsertBillScreenState();
}

class _InsertBillScreenState extends State<InsertBillScreen> {
  bool _isLoading = false;
  final _form = GlobalKey<FormState>();
  final List<TextEditingController> _billDataItem = [TextEditingController()];
  final List<TextEditingController> _billDataQuantity = [
    TextEditingController()
  ];
  final List<TextEditingController> _billDataPrice = [TextEditingController()];
  final List<Widget> _billDataForm = [];

  late Bill _bill;
  final List<Statment> _billDataList = <Statment>[];

  @override
  void initState() {
    _bill = Bill(
      billNo: '',
      companyName: '',
      date: '',
      billData: _billDataList,
    );
    super.initState();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    try {
      for (int i = 0; i < _billDataItem.length; i++) {
        _billDataList.add(Statment(
          itemName: _billDataItem[i].text,
          quantity: int.parse(_billDataQuantity[i].text),
          unitPrice: double.parse(_billDataPrice[i].text),
        ));
      }
      _bill = Bill(
        billNo: _bill.billNo,
        companyName: _bill.companyName,
        date: _bill.date,
        billData: _billDataList,
      );
      BlocProvider.of<BillCubit>(context, listen: false).add(_bill);
      Navigator.of(context).pop();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('خطأ'),
          content: const Text('هناك خطأ في إدخال البيانات'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('موافق'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: insertAppBar(
          title: 'إضافة فاتورة',
          onPressed: () {
            _saveForm();
          }),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            height: size.height * 0.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: _buildInputForm(
                                        labelText: 'رقم الفاتورة',
                                        inputType: TextInputType.number,
                                        saveValue: 'billNo',
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'من فضلك ادخل رقم الفاتورة';
                                          }
                                          if (int.tryParse(value) == null) {
                                            return 'من فضلك ادخل أرقام صحيحة فقط مثال: 00001';
                                          }
                                          return null;
                                        }),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: _buildInputForm(
                                        labelText: 'اسم العميل/الشركة',
                                        saveValue: 'companyName',
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'من فضلك ادخل اسم العميل/الشركة';
                                          }
                                          return null;
                                        }),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: _buildInputForm(
                                        labelText: 'التاريخ',
                                        inputType: TextInputType.datetime,
                                        hintText: DateFormat('dd-MM-yyyy')
                                            .format(DateTime.now()),
                                        saveValue: 'date',
                                        validator: (value) {
                                          RegExp regExp = RegExp(
                                              r"\d{1,2}\-\d{1,2}\-\d{4}");
                                          if (value!.isEmpty) {
                                            return 'من فضلك ادخل التاريخ';
                                          }
                                          if (!regExp.hasMatch(value)) {
                                            return 'سنة - شهر - يوم';
                                          }
                                          return null;
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        InsertDataField(
                          itemController: _billDataItem[0],
                          priceController: _billDataPrice[0],
                          quantityController: _billDataQuantity[0],
                        ),
                        SizedBox(
                          height: size.height * 0.55,
                          child: ListView.builder(
                              itemCount: _billDataForm.length,
                              itemBuilder: (context, i) => _billDataForm[i]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Center(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _addBillData(size);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      primary: Colors.purple,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ElevatedButton(
                                    onPressed: _billDataForm.isEmpty
                                        ? null
                                        : () {
                                            setState(() {
                                              _billDataForm.removeLast();
                                              _billDataItem.removeLast();
                                              _billDataPrice.removeLast();
                                              _billDataQuantity.removeLast();
                                            });
                                          },
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      primary: Colors.purple,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void _addBillData(Size size) {
    setState(() {
      _billDataItem.add(TextEditingController());
      _billDataPrice.add(TextEditingController());
      _billDataQuantity.add(TextEditingController());
      _billDataForm.add(InsertDataField(
        itemController: _billDataItem[_billDataItem.length - 1],
        priceController: _billDataPrice[_billDataPrice.length - 1],
        quantityController: _billDataQuantity[_billDataQuantity.length - 1],
      ));
    });
  }

  TextFormField _buildInputForm({
    required String labelText,
    TextInputType? inputType,
    String? hintText,
    String? saveValue,
    String? Function(String?)? validator,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: labelText,
        alignLabelWithHint: true,
      ),
      validator: validator,
      onSaved: (value) {
        switch (saveValue) {
          case 'billNo':
            _bill = Bill(
              billNo: value!,
              companyName: _bill.companyName,
              date: _bill.date,
              billData: _billDataList,
            );
            break;
          case 'companyName':
            _bill = Bill(
              billNo: _bill.billNo,
              companyName: value!,
              date: _bill.date,
              billData: _billDataList,
            );
            break;
          case 'date':
            _bill = Bill(
              billNo: _bill.billNo,
              companyName: _bill.companyName,
              date: value!,
              billData: _billDataList,
            );
            break;

          default:
            break;
        }
      },
    );
  }

  @override
  void dispose() {
    _billDataItem.clear();
    _billDataPrice.clear();
    _billDataQuantity.clear();
    super.dispose();
  }
}
