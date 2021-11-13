import 'package:flutter/material.dart';
import 'package:resolution_app/models/statement.dart';

class InsertDataField extends StatefulWidget {
  final TextEditingController? itemController;
  final TextEditingController? quantityController;
  final TextEditingController? priceController;
  final bool disableCalMode;
  const InsertDataField({
    Key? key,
    required this.itemController,
    required this.priceController,
    required this.quantityController,
    this.disableCalMode = false,
  }) : super(key: key);

  @override
  _InsertDataFieldState createState() => _InsertDataFieldState();
}

class _InsertDataFieldState extends State<InsertDataField> {
  double _total = 0.0;
  Statment singleBillData = Statment(itemName: '', quantity: 0, unitPrice: 0.0);

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      key: _form,
      child: SizedBox(
        height: size.height * 0.1,
        child: Center(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: _buildInputForm(
                      controller: widget.quantityController,
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
                      controller: widget.itemController,
                      labelText: 'البيان',
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
                      controller: widget.priceController,
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
              if (!widget.disableCalMode)
                ElevatedButton(
                  onPressed: () {
                    final isValid = _form.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    setState(() {
                      _total = double.parse(widget.priceController!.text) *
                          int.parse(widget.quantityController!.text);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    primary: Colors.purple,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (!widget.disableCalMode)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Center(
                          child: Text("الاجمالي: ${_total.roundToDouble()}")),
                    ),
                  ),
                ),
              if (!widget.disableCalMode)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Center(
                          child: Text(
                              "الضريبة: ${(_total * 0.14).roundToDouble()}")),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
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
          case 'billDataItem':
            singleBillData = Statment(
              itemName: value!,
              quantity: singleBillData.quantity,
              unitPrice: singleBillData.unitPrice,
            );
            break;
          case 'billDataQuantity':
            singleBillData = Statment(
              itemName: singleBillData.itemName,
              quantity: int.parse(value!),
              unitPrice: singleBillData.unitPrice,
            );
            break;
          case 'billDataPrice':
            singleBillData = Statment(
              itemName: singleBillData.itemName,
              quantity: singleBillData.quantity,
              unitPrice: double.parse(value!),
            );
            break;

          default:
            break;
        }
      },
    );
  }
}
