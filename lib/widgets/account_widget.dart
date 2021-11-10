import 'package:flutter/material.dart';
import 'package:resolution_app/models/account.dart';
import 'package:resolution_app/screens/account_details_screen.dart';

class AccountWidget extends StatelessWidget {
  final Account account;
  const AccountWidget({Key? key, required this.account}) : super(key: key);

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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AccountDetailsScreen(
                          account: account,
                        )),
              );
            },
            splashColor: Colors.blue[400],
            hoverColor: Colors.blue[100],
            child: Center(
              child: ListTile(
                leading: CircleAvatar(
                    backgroundColor: account.transaction == Transaction.import
                        ? Colors.green
                        : Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Icon(
                          account.transaction == Transaction.import
                              ? Icons.arrow_forward_ios
                              : Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    )),
                title: Text(account.date),
                trailing: Text(account.transaction == Transaction.import
                    ? '+ ${account.getTotalPrice().roundToDouble()}'
                    : '- ${account.getTotalPrice().roundToDouble()}'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
