import 'package:flutter/material.dart';

import 'package:postgres/postgres.dart';

class User {
  late String name;
  late int age;
  // late DateTime birth;
  late int card_number;
  late int bonus_count;
  User(this.name, this.age, this.card_number, this.bonus_count);
}

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});
  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  Future<List<Map<String, dynamic>>> _getUsers (PostgreSQLConnection handler) async {
    var answer = await handler.query("SELECT * FROM Customer");
    List<Map<String, dynamic>> output = [];

    for (var item in answer) {
      output.add(item.toColumnMap());
      // User newUser(userMap["name_"].toString(), int.parse(userMap["age_"].toString()), int.parse(userMap["bonus_card_number_"].toString()), int.parse(userMap["bonus_count_"].toString()));
    }

    return output;
  }

  @override
  Widget build(BuildContext context) {

    var connection = PostgreSQLConnection(
    "127.0.0.1", 5432, "postgres",
    username: "postgres",
    password: "user");

    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: connection.open(), 
        builder: (context, handler) {
          // if (handler.connectionState == ConnectionState.waiting) {
          //   return const Center(child: CircularProgressIndicator()); // Индикатор загрузки
          // } else if (handler.hasError) {
          //   print(handler.error);
          //   return Center(child: Text('Ошибка: ${handler.error}')); // Отображение ошибки
          // } else if (handler.hasData) {
          //   return const Center(child: Text('Соединение установлено')); // Виджет после подключения
          // } else {
          //   return const Center(child: Text('Нет данных')); // Состояние без данных
          // }
          if (handler.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (handler.hasError) {
            print(handler.error);
            return Center(child: Text('Ошибка: ${handler.error}'));
          } else if (handler.hasData) {
            return FutureBuilder(
              future: _getUsers(handler.data!), 
              builder: (context, usersSnapshot) {
                if (usersSnapshot.hasError) {
                  return const Text("Error users");
                } else if (usersSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: usersSnapshot.data!.length,
                    itemBuilder: ((context, index) {
                      return Row(children: [
                        Text(usersSnapshot.data![index]["name_"].toString()),
                        Text(usersSnapshot.data![index]["age_"].toString()),
                      ],);
                    })
                  );
                }
              }
            );
          } else {
            return const Center(child: Text('Error'));
          }

        }
      )
    );
  }
}