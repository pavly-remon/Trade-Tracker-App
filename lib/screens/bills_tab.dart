import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolution_app/models/bill.dart';
import 'package:resolution_app/widgets/bill_widget.dart';

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
    billsList = Provider.of<Bills>(context).searchBill(_search.text);
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
                _buildSearchBar(size),
                IconButton(
                  splashRadius: 25,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/insert_bill');
                  },
                  icon: const Center(
                    child: Icon(
                      Icons.add,
                    ),
                  ),
                ),
              ],
            ),
            _buildBillsListView(context, size),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(Size size) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: size.height * 0.1,
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            SizedBox(
              child: TextField(
                controller: _search,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'البحث باسم الشركة',
                    hintTextDirection: TextDirection.rtl),
              ),
              width: size.width * 0.6,
            ),
            const Icon(Icons.search),
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
