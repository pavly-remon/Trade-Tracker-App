import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resolution_app/models/account.dart';
import 'package:resolution_app/models/statement.dart';
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
  final List<Statment> _accountDataList = <Statment>[];
  var selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
      for (int i = 0; i < _accountDataItem.length; i++) {
        _accountDataList.add(Statment(
          itemName: _accountDataItem[i].text,
          quantity: int.parse(_accountDataQuantity[i].text),
          unitPrice: double.parse(_accountDataPrice[i].text),
        ));
      }
      _account = Account(
        transaction: _account.transaction,
        date: DateFormat('dd-MM-yyyy').format(selectedDate),
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
                                width: size.width * 0.25,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Stack(
                                    alignment: AlignmentDirectional.centerEnd,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          height: size.height * 0.06,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          child: Center(
                                            child: Text(
                                              "التاريخ: ${DateFormat('dd-MM-yyyy').format(selectedDate)}",
                                              style: const TextStyle(
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 15,
                                        child: IconButton(
                                            onPressed: () {
                                              _selectDate(context);
                                            },
                                            icon: const Icon(
                                              Icons.calendar_today,
                                              color: Colors.purple,
                                            )),
                                      ),
                                    ],
                                  ),
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
                                  child: ElevatedButton.icon(
                                    icon: const Icon(
                                        Icons.arrow_downward_rounded),
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
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      primary: _isImport
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    label: SizedBox(
                                        height: size.height * 0.07,
                                        width: size.width * 0.07,
                                        child: const Center(
                                            child: Text(
                                          'وارد',
                                          style: TextStyle(fontSize: 26),
                                        ))),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: ElevatedButton.icon(
                                    icon:
                                        const Icon(Icons.arrow_upward_rounded),
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
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      primary:
                                          !_isImport ? Colors.red : Colors.grey,
                                    ),
                                    label: SizedBox(
                                        height: size.height * 0.07,
                                        width: size.width * 0.07,
                                        child: const Center(
                                            child: Text(
                                          'منصرف',
                                          style: TextStyle(fontSize: 26),
                                        ))),
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

  @override
  void dispose() {
    _accountDataItem.clear();
    _accountDataPrice.clear();
    _accountDataQuantity.clear();
    super.dispose();
  }
}
