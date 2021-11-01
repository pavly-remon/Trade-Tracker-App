import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolution_app/models/bill.dart';
import 'package:resolution_app/screens/home_screen.dart';
import 'package:resolution_app/widgets/app_bar.dart';

class BillDetailsScreen extends StatelessWidget {
  final Bill bill;
  const BillDetailsScreen({Key? key, required this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(title: "تفاصيل الفاتورة", tabsMode: false),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Text('حذف'),
                content: const Text('هل أنت متأكد من حذف الفاتورة؟'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<Bills>(context, listen: false)
                          .deleteBill(bill.billNo);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                          ModalRoute.withName("/home"));
                    },
                    child: const Text(
                      "نعم",
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
                    "رقـــــم الفـــاتورة:   ${bill.billNo}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    "اسم العميل/الشركة:     ${bill.companyName}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    "التــــــــــــاريخ:   ${bill.date}",
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
                        DataColumn(label: Text('الضريبة')),
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
    for (int i = 0; i < bill.billData.length; i++) {
      table.add(
        DataRow(
          cells: [
            DataCell(Text(bill.billData[i].itemName,
                style: const TextStyle(fontSize: 20.0))),
            DataCell(Text(bill.billData[i].quantity.toString(),
                style: const TextStyle(fontSize: 20.0))),
            DataCell(Text(bill.billData[i].unitPrice.roundToDouble().toString(),
                style: const TextStyle(fontSize: 20.0))),
            DataCell(Text(
                (bill.billData[i].unitPrice * bill.billData[i].quantity)
                    .roundToDouble()
                    .toString(),
                style: const TextStyle(fontSize: 20.0))),
            DataCell(Text(
                (bill.billData[i].unitPrice * bill.billData[i].quantity * 0.14)
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
          Text('الاجمالي (شامل الضريبة)',
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
        const DataCell(
          Text('', style: TextStyle(fontSize: 20.0)),
        ),
        DataCell(
          Text(bill.getTotalPriceWithTax().roundToDouble().toString(),
              style: const TextStyle(fontSize: 20.0)),
        ),
      ]),
    );
    return table;
  }
}
