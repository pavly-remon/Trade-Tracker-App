import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resolution_app/models/bill.dart';
import 'package:resolution_app/screens/auth_screen.dart';
import 'package:resolution_app/screens/bill_details_screen.dart';

import '../cubit/bill_cubit.dart';
import '../screens/home_screen.dart';
import '../screens/insert_account_screen.dart';
import '../screens/insert_bill_screen.dart';

class AppRouter {
  final BillCubit _billCubit = BillCubit();

  Route? onGenerateRoute(RouteSettings routeSettings) {
    // <-- remove static from here!
    //Uncomment below line as needed
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const AuthScreen());
      case 'home':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _billCubit,
            child: const HomeScreen(),
          ),
        );
      case 'insert_bill':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _billCubit,
            child: const InsertBillScreen(),
          ),
        );
      case 'bill_details':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _billCubit,
            child: BillDetailsScreen(bill: args as Bill),
          ),
        );
      case 'insert_account':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _billCubit,
            child: const InsertAccountScreen(),
          ),
        );
      default:
        return null;
    }
  }

  void dispose() {
    _billCubit.close();
  }
}
