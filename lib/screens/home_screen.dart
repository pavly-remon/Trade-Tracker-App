import 'package:flutter/material.dart';
import 'package:resolution_app/screens/accounts_tab.dart';
import 'package:resolution_app/screens/bills_tab.dart';
import 'package:resolution_app/widgets/app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _tabIndex = 0;
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);

    super.initState();
  }

  onTap(int i) {
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = mainAppBar(
        title: 'Resolution',
        tabsMode: true,
        tabController: _tabController,
        onTap: onTap(_tabIndex));
    final size = appBar.preferredSize;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar,
        body: TabBarView(
          controller: _tabController,
          children: [
            BillsTab(
              appBarSize: size,
            ),
            AccountsTab(appBarSize: size),
            const Center(
              child: Icon(
                Icons.business,
                size: 50,
              ),
            )
          ],
        ),
        floatingActionButton: _tabIndex == 2
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.purple,
                child: const Center(
                  child: Icon(
                    Icons.add,
                  ),
                ),
                onPressed: () {
                  switch (_tabIndex) {
                    case 0:
                      Navigator.of(context).pushNamed('/insert_bill');
                      break;
                    case 1:
                      Navigator.of(context).pushNamed('/insert_account');
                      break;
                    default:
                  }
                },
              ),
      ),
    );
  }
}
