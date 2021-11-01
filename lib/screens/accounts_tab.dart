import 'package:flutter/material.dart';
import 'package:resolution_app/widgets/search_bar.dart';

class AccountsTab extends StatefulWidget {
  final Size appBarSize;
  const AccountsTab({Key? key, required this.appBarSize}) : super(key: key);

  @override
  _AccountsTabState createState() => _AccountsTabState();
}

class _AccountsTabState extends State<AccountsTab> {
  final _search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
        child: SizedBox(
      width: size.width,
      height: (size.height - widget.appBarSize.height) * 0.95,
      child: Column(
        children: [
          SearchBar(search: _search),
        ],
      ),
    ));
  }
}
