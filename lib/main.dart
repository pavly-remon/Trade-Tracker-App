import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolution_app/models/bill.dart';
import 'package:resolution_app/screens/auth_screen.dart';
import 'package:resolution_app/screens/insert_bill_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Bills(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Resolution',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          InsertBillScreen.routeName: (ctx) => const InsertBillScreen(),
        },
        home: const AuthScreen(),
      ),
    );
  }
}
