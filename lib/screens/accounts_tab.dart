import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resolution_app/cubit/account_cubit.dart';
import 'package:resolution_app/models/account.dart';
import 'package:resolution_app/widgets/account_widget.dart';
import 'package:resolution_app/widgets/search_bar.dart';

class AccountsTab extends StatefulWidget {
  final Size appBarSize;
  const AccountsTab({Key? key, required this.appBarSize}) : super(key: key);

  @override
  _AccountsTabState createState() => _AccountsTabState();
}

class _AccountsTabState extends State<AccountsTab> {
  List<Account> accountsList = [];

  final _search = TextEditingController();

  @override
  void initState() {
    _search.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
        child: SizedBox(
      width: size.width,
      height: (size.height - widget.appBarSize.height) * 0.95,
      child: Column(
        children: [
          SearchBarWidget(
            search: _search,
            hintText: "البحث بالتاريخ",
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              height: (size.height - widget.appBarSize.height) * 0.1,
              width: size.width * 0.3,
              child: BlocBuilder<AccountCubit, AccountState>(
                builder: (context, state) {
                  return Card(
                    color: AccountRepository.totalMoney() >= 0
                        ? Colors.green
                        : Colors.red,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: FittedBox(
                        alignment: Alignment.center,
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            " ${AccountRepository.totalMoney()} :مجموع المعاملات",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          _buildBillsListView(
              context, (size.height - widget.appBarSize.height)),
        ],
      ),
    ));
  }

  Widget _buildBillsListView(BuildContext context, double height) {
    return SizedBox(
      height: height * 0.6,
      child: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          accountsList = state.accounts
              .where((element) => element.date.contains(_search.text))
              .toList();
          return ListView.builder(
            itemExtent: height * 0.15,
            itemCount: accountsList.length,
            itemBuilder: (context, i) =>
                AccountWidget(account: accountsList[i]),
          );
        },
      ),
    );
  }
}
