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

  TextEditingController _name = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _city = TextEditingController();

  String _nameOld = '';
  String _lnameOld = '';
  String _cityOld = '';

  @override
  void initState() {
    super.initState();
  }
  
  var db = mongo_dart.Db('mongodb://127.0.0.1:27017/test');

  Future<Map<String, dynamic>> _getAccInfo() async {
    await db.open();
    var answer = await db.collection("first_collection").find({"name": g_login}).toList();
    for (var row in answer) {
      print("${row["name"].toString()} -- ${row["pass"].toString()}");
    }
    await db.close();
    return answer.first;
  }

  Future<void> _editInfo(String lname, String name, String city) async {
    await db.open();
    var collection = await db.collection("first_collection");
    
    if ( _nameOld != name ) {
      final result = await collection.updateOne(mongo_dart.where.eq('name', g_login), mongo_dart.modify.set('fname', _name.text));
      print(result.isSuccess);
    }
    if ( _lnameOld != lname ) {
      final result = await collection.updateOne(mongo_dart.where.eq('name', g_login), mongo_dart.modify.set('lname', _lname.text));
      print(result.isSuccess);
    }
    if ( _cityOld != city ) {
      final result = await collection.updateOne(mongo_dart.where.eq('name', g_login), mongo_dart.modify.set('city', _city.text));
      print(result.isSuccess);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _getAccInfo(), 
      builder: ((context, snapshot) {

        _nameOld = snapshot.data!["fname"].toString();
        _lnameOld = snapshot.data!["lname"].toString();
        _cityOld = snapshot.data!["city"].toString();

        return Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Image.memory(base64Decode(snapshot.data!["image"].toString())),
              Text(
                snapshot.data!["lname"].toString(),
                style: const TextStyle(
                  fontSize: 34
                ),
              ),
              Text(
                snapshot.data!["fname"].toString(),
                style: const TextStyle(
                  fontSize: 25
                ),
              ),
              Text(
                snapshot.data!["city"].toString(),
                style: const TextStyle(
                  fontSize: 25
                ),
              ),
              IconButton(
                onPressed: () {

                  _lname = TextEditingController.fromValue(TextEditingValue(text: snapshot.data!["lname"].toString()));
                  _name = TextEditingController.fromValue(TextEditingValue(text: snapshot.data!["fname"].toString()));
                  _city = TextEditingController.fromValue(TextEditingValue(text: snapshot.data!["city"].toString()));

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
                            decoration: const InputDecoration(labelText: "Город проживания"),
                            obscureText: false,
                            controller: _city,
                          ),
                          IconButton(
                            onPressed: () {
                              _editInfo(_lname.text, _name.text, _city.text).then((value) => setState(() {}));
                            }, 
                            icon: const Icon(Icons.save)
                          )
                        ],
                      ),
                    )
                  ));
                }, 
                icon: const Icon(Icons.edit)
              )
            ],
          ),
        );
      })
    ); 
  }
}