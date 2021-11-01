import 'package:flutter/material.dart';
import 'package:resolution_app/icons.dart';

AppBar mainAppBar({
  required String title,
  required bool tabsMode,
  TabController? tabController,
  void Function(int)? onTap,
}) =>
    AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontFamily: "Eurostile",
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/appbar.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      bottom: tabsMode
          ? TabBar(
              onTap: onTap,
              controller: tabController,
              unselectedLabelColor: Colors.white,
              labelColor: Colors.black,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), // Creates border
                  color: Colors.white),
              tabs: const [
                Tab(
                  icon: Icon(
                    TabIcons.file_invoice_dollar,
                  ),
                  text: 'فواتير',
                ),
                Tab(
                  icon: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      TabIcons.exchange,
                    ),
                  ),
                  text: 'حسابات',
                ),
                Tab(
                  icon: Icon(Icons.business_center),
                  text: 'الشركات',
                ),
              ],
            )
          : null,
    );

AppBar insertAppBar({required String title, required var onPressed}) => AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontFamily: "Eurostile",
          fontWeight: FontWeight.bold,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/appbar.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.save,
            color: Colors.white,
          ),
        )
      ],
    );
