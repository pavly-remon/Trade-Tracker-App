import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolution_app/screens/auth_screen.dart';

import 'utils/app_router.dart';
import 'models/account.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Accounts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Resolution',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: _appRouter.onGenerateRoute,
        home: const AuthScreen(),
      ),
    );
  }
}
