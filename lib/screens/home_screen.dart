import 'package:flutter/material.dart';
import 'package:resolution_app/screens/bills_tab.dart';
import 'package:resolution_app/widgets/app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = mainAppBar(title: 'Resolution', tabsMode: true);
    final size = appBar.preferredSize;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar,
        body: TabBarView(
          children: [
            BillsTab(
              appBarSize: size,
            ),
            const Icon(
              Icons.playlist_add_check_outlined,
              size: 350,
            )
          ],
        ),
      ),
    );
  }
}
