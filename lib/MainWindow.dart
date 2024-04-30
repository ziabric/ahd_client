import 'package:postgres/postgres.dart';
import 'package:flutter/material.dart';
import 'GlobalVariables.dart';
import 'UserInfo.dart';
import 'Price.dart';
import 'About.dart';
import 'PersReq.dart';

import 'dart:math';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});
  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with TickerProviderStateMixin {

  late TabController _tabController;
  DateTime _dth = DateTime.now();
  TextEditingController _name = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _name1 = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _referal = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  Future<void> _addUser(String name, int age, DateTime birthDate) async {
    final handler = await Connection.open(Endpoint(host: 'localhost', port: 5432, database: 'postgres', username: 'postgres', password: 'user',));
    print("insert into customer(name_,age_,birth_dt_,bonus_card_number_,bonus_count_) values('$name',$age,'${birthDate.year}-${birthDate.month}-${birthDate.day}',${Random.secure().nextInt(10000)},0);");
    await handler.execute("insert into customer(name_,age_,birth_dt_,bonus_card_number_,bonus_count_) values($name,$age,$birthDate,${Random.secure().nextInt(10000)},0);");
    await handler.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(g_login),
        centerTitle: false,
        actions: [
          (commonUser) ? TextButton.icon(
            onPressed: () {
              showDialog(context: context, builder: (context) => Dialog(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(labelText: "Фамилия"),
                        obscureText: false,
                        controller: _lname,
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: "Имя"),
                        obscureText: false,
                        controller: _name,
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: "Отчество"),
                        obscureText: false,
                        controller: _name1,
                      ),
                      CalendarDatePicker(
                        initialDate: _dth, 
                        firstDate: DateTime(1900), 
                        lastDate: DateTime(2200), 
                        onDateChanged: (dt) {
                          _dth = dt;
                        }
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.exit_to_app)),
                            IconButton(
                              onPressed: () {
                                if (_lname.text != '' && _name.text != '' && _name1.text != '') _addUser("${_lname.text} ${_name.text} ${_name1.text}", (DateTime.now().year - _dth.year), _dth).then((value) => setState(() {}));
                              }, 
                              icon: const Icon(Icons.save)
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))
              );
            }, 
            icon: const Icon(Icons.add), 
            label: const Text("Add user")) : const Text("")
        ],
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: const [
              UserInfo(),
              Price(),
              PersReq(),
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