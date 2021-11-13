import 'package:flutter/material.dart';
import 'package:resolution_app/models/bill.dart';

class BillWidget extends StatelessWidget {
  final Bill bill;
  const BillWidget({Key? key, required this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          elevation: 6,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('bill_details', arguments: bill);
            },
            splashColor: Colors.blue[400],
            hoverColor: Colors.blue[100],
            child: Center(
              child: ListTile(
                leading: CircleAvatar(
                    backgroundImage:
                        const AssetImage('assets/images/appbar.jpg'),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FittedBox(
                        child: Text(
                          bill.billNo,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                title: Text(bill.companyName),
                subtitle: Text(
                    'السعر الاجمالي شامل الضريبة: ${bill.getTotalPriceWithTax().roundToDouble()}'),
                trailing: Text(bill.date),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
