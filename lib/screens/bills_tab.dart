import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolution_app/models/bill.dart';
import 'package:resolution_app/widgets/bill_widget.dart';
import 'package:resolution_app/widgets/search_bar.dart';

class BillsTab extends StatefulWidget {
  final Size appBarSize;
  const BillsTab({Key? key, required this.appBarSize}) : super(key: key);

  @override
  State<BillsTab> createState() => _BillsTabState();
}

class _BillsTabState extends State<BillsTab> {
  List<Bill> billsList = [];
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
    billsList = Provider.of<Bills>(context).billsList(_search.text);
    final size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: size.width,
        height: (size.height - widget.appBarSize.height) * 0.95,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SearchBar(
                  search: _search,
                  hintText: "البحث باسم العميل/الشركة",
                ),
              ],
            ),
            _buildBillsListView(context, size),
          ],
        ),
      ),
    );
  }

  Widget _buildBillsListView(BuildContext context, Size size) {
    return SizedBox(
      height: size.height * 0.6,
      child: ListView.builder(
        itemExtent: size.height * 0.15,
        itemCount: billsList.length,
        itemBuilder: (context, i) => BillWidget(
          bill: billsList[i],
        ),
      ),
    );
  }
}
