import 'package:flutter/material.dart';
import 'GlobalVariables.dart';
import 'UserInfo.dart';
import 'ItemInfo.dart';
import 'Price.dart';
import 'About.dart';
import 'PersReq.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});
  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with TickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(g_login),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: const [
              UserInfo(),
              // ItemInfo(),
              Price(),
              Text("data"),
              About()
            ]
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: TabBar(
              // padding: EdgeInsets.all(20),
              indicatorWeight: 10,
              indicatorColor: Colors.lightBlue,
              controller: _tabController,
              tabs: [
                Icon(
                  shadows: [shadow],
                  size: 40,
                  Icons.contact_page,
                  color: Colors.lightBlue,
                ),
                Icon(
                  size: 40,
                  shadows: [shadow],
                  Icons.monetization_on,
                  color: Colors.lightBlue,
                ),
                Icon(
                  shadows: [shadow],
                  size: 40,
                  Icons.trending_up,
                  color: Colors.lightBlue,
                ),
                Icon(
                  shadows: [shadow],
                  size: 40,
                  Icons.person,
                  color: Colors.lightBlue,
                ),
              ]
            ),
          )
        ],
      )
    ); 
  }
}