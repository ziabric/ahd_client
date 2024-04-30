import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
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

  final TextEditingController _loginText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController(); 

  List<String> login = [];
  List<String> pass = [];

  Future<void> _auth() async {

    login.clear();
    pass.clear();

    await db.open();

    print("open");

    var answer = await db.collection("first_collection").find().toList();

    print("get");

    print(answer.length);

    for (var row in answer) {
      print("${row["name"].toString()} -- ${row["pass"].toString()}");
      login.add(row["name"].toString());
      pass.add(row["pass"].toString());
    }

    await db.close();
    print("close");


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
                    decoration: const InputDecoration(labelText: 'Логин'),
                    controller: _loginText,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Пароль'),
                    obscureText: true,
                    controller: _passwordText,
                  ),
                  const SizedBox(height: 30,),
                  IconButton.filled(
                    onPressed: () {

                      authAccept = false;
                      commonUser = false;

                      for (int i = 0; i < login.length; i += 1) {
                        if ( login[i] == _loginText.text && pass[i] == _passwordText.text ) {
                          g_login = login[i];
                          authAccept = true;
                          if (g_login != 'postgres') commonUser = true;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MainWindow()));
                        }
                      }
                      if (!authAccept) {
                        showDialog(context: context, builder: (context) => Dialog(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Ошибка авторизации",
                                style: TextStyle(
                                  fontSize: 30
                                ),
                              ),
                              const Divider(),
                              IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.exit_to_app)),
                            ],
                          ),
                          )
                        ));
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
