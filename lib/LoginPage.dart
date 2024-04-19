import 'package:flutter/material.dart';

import 'MainWindow.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final TextEditingController _loginText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                  // Add authorisation!!!
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MaterialApp(home: MainWindow(),)));
                }, 
                icon: const Icon(Icons.login)
              )
            ],
          ),
        ),
      ),
    );
  }
}
