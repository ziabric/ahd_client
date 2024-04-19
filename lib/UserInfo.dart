import 'package:flutter/material.dart';

import 'package:postgres/postgres.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});
  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  // Future<PostgreSQLConnection> getConnection() async {
  //   print("Start");
  //   var connection = PostgreSQLConnection(
  //   "127.0.0.1", 5432, "postgres",
  //   queryTimeoutInSeconds: 3600,
  //   timeoutInSeconds: 3600,
  //   username: "postgres",
  //   password: "user");
  //   print("Opening");
  //   await connection.open();
  //   print("Opened");
  //   return connection;
  // }

  @override
  Widget build(BuildContext context) {

    var connection = PostgreSQLConnection(
    "10.0.0.2", 5432, "postgres",
    username: "postgres",
    password: "user");

    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: connection.open(), 
        builder: (contex, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Индикатор загрузки
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Ошибка: ${snapshot.error}'); // Отображение ошибки
          } else if (snapshot.hasData) {
            return Text('Соединение установлено'); // Виджет после подключения
          } else {
            return Text('Нет данных'); // Состояние без данных
          }
        }
      )
    );
  }
}