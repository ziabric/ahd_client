import 'package:flutter/material.dart';

import 'UserInfo.dart';

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
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: const [
              UserInfo(),
              Text("data"),
              Text("data"),
              Text("data"),
            ]
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: TabBar(
              // padding: EdgeInsets.all(20),
              controller: _tabController,
              tabs: const [
                Icon(
                  Icons.contact_page,
                  color: Colors.lightBlue,
                ),
                Icon(
                  Icons.assignment,
                  color: Colors.lightBlue,
                ),
                Icon(
                  Icons.assignment,
                  color: Colors.lightBlue,
                ),
                Icon(
                  Icons.assignment,
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