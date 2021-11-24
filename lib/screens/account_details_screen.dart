import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resolution_app/cubit/bill_cubit.dart';
import 'package:resolution_app/models/account.dart';
import 'package:resolution_app/widgets/app_bar.dart';

class AccountDetailsScreen extends StatelessWidget {
  final Account account;
  const AccountDetailsScreen({Key? key, required this.account})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(title: "تفاصيل المعاملة", tabsMode: false),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Text('حذف'),
                content: const Text('هل أنت متأكد من حذف المعاملة؟'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<BillCubit>(context, listen: false)
                          .remove(account.id!);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        'home',
                        ModalRoute.withName("home"),
                      );
                    },
                    child: const Text(
                      "موافق",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "لا",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            height: size.height * 0.9,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    account.transaction == Transaction.import
                        ? "نوع المعاملة: وارد"
                        : "نوع المعاملة: منصرف",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    "التــــــــــــاريخ:   ${account.date}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Center(
                  child: Container(
                    width: size.width,
                    margin: const EdgeInsets.all(20.0),
                    child: DataTable(
                      dividerThickness: 1,
                      headingTextStyle: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'البيان',
                          ),
                        ),
                        DataColumn(
                          label: Text('الكمية'),
                        ),
                        DataColumn(
                          label: Text(
                            'سعر الوحدة',
                          ),
                        ),
                        DataColumn(label: Text('اجمالي السعر')),
                      ],
                      rows: [
                        ..._buildDataRow(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DataRow> _buildDataRow() {
    List<DataRow> table = [];
    for (int i = 0; i < account.data.length; i++) {
      table.add(
        DataRow(
          cells: [
            DataCell(Text(account.data[i].itemName,
                style: const TextStyle(fontSize: 20.0))),
            DataCell(Text(account.data[i].quantity.toString(),
                style: const TextStyle(fontSize: 20.0))),
            DataCell(Text(account.data[i].unitPrice.roundToDouble().toString(),
                style: const TextStyle(fontSize: 20.0))),
            DataCell(Text(
                (account.data[i].unitPrice * account.data[i].quantity)
                    .roundToDouble()
                    .toString(),
                style: const TextStyle(fontSize: 20.0))),
          ],
        ),
      );
    }
    table.add(
      DataRow(cells: [
        const DataCell(
          Text('الاجمالي',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple)),
        ),
        const DataCell(
          Text('', style: TextStyle(fontSize: 20.0)),
        ),
        const DataCell(
          Text('', style: TextStyle(fontSize: 20.0)),
        ),
        DataCell(
          Text(account.getTotalPrice().roundToDouble().toString(),
              style: const TextStyle(fontSize: 20.0)),
        ),
      ]),
    );
    return table;
  }
}
