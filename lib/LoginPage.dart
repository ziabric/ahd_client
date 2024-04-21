import 'dart:math';

import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;
import 'package:flutter/material.dart';
import 'GlobalVariables.dart';
import 'MainWindow.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  var db = mongo_dart.Db('mongodb://127.0.0.1:27017/test');
  bool authAccept = false;

  final TextEditingController _loginText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController(); 

  List<String> login = [];
  List<String> pass = [];

  Future<void> _auth() async {

    login.clear();
    pass.clear();

    await db.open();
    // await db.drop();

    print("open");

    // db.collection("first_collection").insert({"name": "user3", "pass":"user"});

    var answer = await db.collection("first_collection").find().toList();

    print("get");

    print(answer.length);

    for (var row in answer) {
      print("${row["name"].toString()} -- ${row["pass"].toString()}");
      login.add(row["name"].toString());
      pass.add(row["pass"].toString());
    }

    // await answer.forEach((element) {
    //   print("${element["name"]} -- ${element["pass"]}");
    //   login.add(element["name"]);
    //   pass.add(element["pass"]);
    //   // if ( _loginText.text == element["name"] && _passwordText.text == element["pass"]) {
    //   //   authAccept = true;
    //   //   print("find");
    //   // }
    // });

    await db.close();
    print("close");

    // if (authAccept) {
    //   authAccept = false;
    //   login = _loginText.text;
    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainWindow(),));
    // } else {
    //   await showDialog(context: context, builder: (context) {
    //     return AlertDialog(
    //       title: Text("Auth error"),
    //       icon: Icon(Icons.cancel)
    //     );
    //   });
    // }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _auth(), 
        builder: (context, snapshot) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(labelText: 'Login'),
                    controller: _loginText,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordText,
                  ),
                  const SizedBox(height: 30,),
                  IconButton.filled(
                    onPressed: () {
                      for (int i = 0; i < login.length; i += 1) {
                        if ( login[i] == _loginText.text && pass[i] == _passwordText.text ) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MainWindow()));
                        }
                      }
                    }, 
                    icon: const Icon(Icons.login)
                  )
                ],
              ),
            ),
          );
        }
      )
    );
  }
}
