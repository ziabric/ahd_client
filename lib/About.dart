import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;
import 'package:flutter/material.dart';
import 'GlobalVariables.dart';

class About extends StatefulWidget {
  const About({super.key});
  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }
  
  var db = mongo_dart.Db('mongodb://127.0.0.1:27017/test');

  Future<Map<String, dynamic>> _getAccInfo() async {

    await db.open();

    print("open");

    var answer = await db.collection("first_collection").find({"name": g_login}).toList();

    print("get");

    print(answer.length);

    for (var row in answer) {
      print("${row["name"].toString()} -- ${row["pass"].toString()}");
    }

    await db.close();
    print("close");

    return answer.first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAccInfo(), 
      builder: ((context, snapshot) {
        return Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Image.memory(base64Decode(snapshot.data!["image"].toString())),
              Text(
                snapshot.data!["lname"].toString(),
                style: const TextStyle(
                  fontSize: 24
                ),
              ),
              Text(
                snapshot.data!["fname"].toString(),
                style: const TextStyle(
                  fontSize: 20
                ),
              ),
              Text(
                snapshot.data!["city"].toString(),
                style: const TextStyle(
                  fontSize: 24
                ),
              ),
            ],
          ),
        );
      })
    ); 
  }
}