import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resolution_app/models/bill.dart';
import 'package:resolution_app/widgets/app_bar.dart';

class InsertBillScreen extends StatefulWidget {
  static const String routeName = '/insert_bill';
  const InsertBillScreen({Key? key}) : super(key: key);

  @override
  _InsertBillScreenState createState() => _InsertBillScreenState();
}

class _InsertBillScreenState extends State<InsertBillScreen> {
  bool _isLoading = false;
  final List<Widget> _billDataForm = <Widget>[];
  final _form = GlobalKey<FormState>();

  late Bill _bill;
  final List<BillData> _billDataList = <BillData>[];
  BillData singleBillData = BillData(itemName: '', quantity: 0, unitPrice: 0.0);

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
      Provider.of<Bills>(context, listen: false).insertBill(_bill);
      Navigator.of(context).pop();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('Something went wrong.'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Okay'),
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
                        _buildInputBillData(size),
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
                                      setState(() {
                                        _billDataForm
                                            .add(_buildInputBillData(size));
                                      });
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

  Widget _buildInputBillData(var size) {
    return SizedBox(
      height: size.height * 0.1,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: _buildInputForm(
                  labelText: 'الكمية',
                  saveValue: 'billDataQuantity',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'من فضلك ادخل الكمية';
                    }
                    if (int.tryParse(value) == null) {
                      return 'من فضلك ادخل أرقام صحيحة فقط مثال 5';
                    }
                    if (int.parse(value) <= 0) {
                      return 'الكمية غير صحيحة';
                    }
                    return null;
                  }),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: _buildInputForm(
                  labelText: 'اسم الوحدة',
                  saveValue: 'billDataItem',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'من فضلك ادخل اسم الوحدة';
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
                  labelText: 'سعر الوحدة',
                  saveValue: 'billDataPrice',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'من فضلك ادخل سعر الوحدة';
                    }
                    if (double.tryParse(value) == null) {
                      return 'من فضلك ادخل أرقام فقط مثال 5.50';
                    }
                    if (double.parse(value) <= 0) {
                      return 'السعر غير صحيح';
                    }
                    return null;
                  }),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField _buildInputForm({
    required String labelText,
    TextInputType? inputType,
    String? hintText,
    String? saveValue,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
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
          case 'billDataItem':
            singleBillData = BillData(
              itemName: value!,
              quantity: singleBillData.quantity,
              unitPrice: singleBillData.unitPrice,
            );
            break;
          case 'billDataQuantity':
            singleBillData = BillData(
              itemName: singleBillData.itemName,
              quantity: int.parse(value!),
              unitPrice: singleBillData.unitPrice,
            );
            break;
          case 'billDataPrice':
            singleBillData = BillData(
              itemName: singleBillData.itemName,
              quantity: singleBillData.quantity,
              unitPrice: double.parse(value!),
            );
            _billDataList.add(singleBillData);
            break;

          default:
            break;
        }
      },
    );
  }
}
