import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resolution_app/models/account.dart';
import 'package:resolution_app/models/bill.dart';
import 'package:resolution_app/widgets/app_bar.dart';
import 'package:resolution_app/widgets/insert_data.dart';

class InsertAccountScreen extends StatefulWidget {
  const InsertAccountScreen({Key? key}) : super(key: key);

  @override
  _InsertAccountScreenState createState() => _InsertAccountScreenState();
}

class _InsertAccountScreenState extends State<InsertAccountScreen> {
  bool _isImport = true;
  bool _isLoading = false;
  final _form = GlobalKey<FormState>();

  final List<TextEditingController> _accountDataItem = [
    TextEditingController()
  ];
  final List<TextEditingController> _accountDataQuantity = [
    TextEditingController()
  ];
  final List<TextEditingController> _accountDataPrice = [
    TextEditingController()
  ];
  final List<Widget> _accountDataForm = [];

  late Account _account =
      Account(transaction: Transaction.import, date: '', data: []);
  final List<Data> _accountDataList = <Data>[];

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
      for (int i = 0; i < _accountDataItem.length; i++) {
        _accountDataList.add(Data(
          itemName: _accountDataItem[i].text,
          quantity: int.parse(_accountDataQuantity[i].text),
          unitPrice: double.parse(_accountDataPrice[i].text),
        ));
      }
      _account = Account(
        transaction: _account.transaction,
        date: _account.date,
        data: _accountDataList,
      );
      Provider.of<Accounts>(context, listen: false).insertAccount(_account);
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
    final appBar = insertAppBar(
        title: 'إضافة معاملة',
        onPressed: () async {
          await _saveForm();
        });
    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: _form,
                child: Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              SizedBox(
                                height: size.height * 0.1,
                                width: size.width * 0.2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: _buildInputForm(
                                      labelText: 'التاريخ',
                                      inputType: TextInputType.datetime,
                                      hintText: DateFormat('dd-MM-yyyy')
                                          .format(DateTime.now()),
                                      saveValue: 'date',
                                      validator: (value) {
                                        RegExp regExp =
                                            RegExp(r"\d{1,2}\-\d{1,2}\-\d{4}");
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
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            height: size.height * 0.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isImport = true;
                                        _account = Account(
                                          transaction: Transaction.import,
                                          date: _account.date,
                                          data: _account.data,
                                        );
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: _isImport
                                          ? Colors.purple[700]
                                          : Colors.grey,
                                    ),
                                    child: SizedBox(
                                        height: size.height * 0.07,
                                        width: size.width * 0.1,
                                        child: const Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Center(
                                              child: Text(
                                            'وارد',
                                            style: TextStyle(fontSize: 26),
                                          )),
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isImport = false;
                                        _account = Account(
                                          transaction: Transaction.export,
                                          date: _account.date,
                                          data: _account.data,
                                        );
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: !_isImport
                                          ? Colors.purple[700]
                                          : Colors.grey,
                                    ),
                                    child: SizedBox(
                                        height: size.height * 0.07,
                                        width: size.width * 0.1,
                                        child: const Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Center(
                                              child: Text(
                                            'منصرف',
                                            style: TextStyle(fontSize: 26),
                                          )),
                                        )),
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
                          itemController: _accountDataItem[0],
                          priceController: _accountDataPrice[0],
                          quantityController: _accountDataQuantity[0],
                          disableCalMode: true,
                        ),
                        SizedBox(
                          height: size.height * 0.45,
                          child: ListView.builder(
                              itemCount: _accountDataForm.length,
                              itemBuilder: (context, i) => _accountDataForm[i]),
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
                                      _addAccountData(size);
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
                                    onPressed: _accountDataForm.isEmpty
                                        ? null
                                        : () {
                                            setState(() {
                                              _accountDataForm.removeLast();
                                              _accountDataItem.removeLast();
                                              _accountDataPrice.removeLast();
                                              _accountDataQuantity.removeLast();
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

  void _addAccountData(Size size) {
    setState(() {
      _accountDataItem.add(TextEditingController());
      _accountDataPrice.add(TextEditingController());
      _accountDataQuantity.add(TextEditingController());
      _accountDataForm.add(InsertDataField(
        itemController: _accountDataItem[_accountDataItem.length - 1],
        priceController: _accountDataPrice[_accountDataPrice.length - 1],
        quantityController:
            _accountDataQuantity[_accountDataQuantity.length - 1],
        disableCalMode: true,
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
        _account = Account(
          transaction: _account.transaction,
          date: value!,
          data: _accountDataList,
        );
      },
    );
  }

  @override
  void dispose() {
    _accountDataItem.clear();
    _accountDataPrice.clear();
    _accountDataQuantity.clear();
    super.dispose();
  }
}
