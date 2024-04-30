import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'GlobalVariables.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});
  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  TextEditingController _bonusCount = TextEditingController();

  Future<List<List<String>>> _getUsers (Connection handler) async {
    List<List<String>> output = [];
    final result = await handler.execute("SELECT client_id_,name_,bonus_card_number_,bonus_count_,age_,count(item_id_) AS total_counts,sell_dt_ FROM customer c INNER JOIN checks ch USING(client_id_) INNER JOIN material mat USING(item_id_) GROUP BY client_id_, name_, bonus_card_number_, age_, sell_dt_, check_id_;");
    // final result = await handler.execute("Select * from customers");

    for (var row in result) {
      List<String> newRow = [];
      int count = 0;
      for (var item in row) {
        if ( item.toString().length == 200 ) {
          String newString = item.toString();
          for ( int i = 0; i < newString.length - 1; i += 1 ) {
            if ( newString[i] == ' ' && newString[i+1] == ' ' ) {
              newString = newString.substring(0, i);
              newRow.add(newString);
              break;
            }
          }
        }
        else {
          newRow.add(item.toString());
        }
        // print("$count:  ${item.toString()}");
        count += 1;
      }
      output.add(newRow);
    }

    await handler.close();

    return output;
  }

  Future<void> _deleteUser(String id) async {
    final handler = await Connection.open(Endpoint(host: 'localhost', port: 5432, database: 'postgres', username: 'postgres', password: 'user',));
    await handler.execute("DELETE FROM customer WHERE client_id_=$id;");
    await handler.close();
  }

  Future<void> _editItem(String id, String newBonus) async {
    final handler = await Connection.open(Endpoint(host: 'localhost', port: 5432, database: 'postgres', username: 'postgres', password: 'user',));
    await handler.execute("update customer set bonus_count_=$newBonus where client_id_=$id;");
    await handler.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: Connection.open(Endpoint(host: 'localhost', port: 5432, database: 'postgres', username: 'postgres', password: 'user',)), 
        builder: (context, handler) {
          if (handler.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (handler.hasError) {
            // print(handler.error);
            return Center(child: Text('Ошибка: ${handler.error}'));
          } else {
            return FutureBuilder(
              future: _getUsers(handler.data!), 
              builder: (context, usersSnapshot) {
                if (usersSnapshot.hasError) {
                  return const Text("Error users");
                } else if (usersSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  var userAnswer = usersSnapshot.data!;
                  return Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {return const SizedBox(height: 10,);},
                      itemCount: userAnswer.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [boxShadow]
                          ),
                          padding: const EdgeInsets.all(15),
                          child: Row(children: [
                            IconButton(
                              onPressed: () {

                                _bonusCount = TextEditingController.fromValue(TextEditingValue(text: userAnswer[index][3]));

                                showDialog(context: context, builder: (context) => Dialog(
                                  child: Container(
                                    padding: const EdgeInsets.all(10), 
                                    child:  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("ФИО: ${userAnswer[index][1]}"),
                                      const Divider(),
                                      Text("Номер бонусной карты: ${userAnswer[index][2]}"),
                                      const Divider(),
                                      Text("id: ${userAnswer[index][0]}"),
                                      const Divider(),
                                      Text("Возраст: ${userAnswer[index][4]}"),
                                      const Divider(),
                                      TextField(
                                        decoration: const InputDecoration(labelText: 'Кол-во бонусов'),
                                        obscureText: false,
                                        controller: _bonusCount,
                                      ),
                                      // Text("Кол-во бонусов: ${userAnswer[index][4]}"),
                                      // const Divider(),
                                      Text("Последняя дата покупки: ${userAnswer[index][6]}"),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.exit_to_app)),
                                          (commonUser) ? IconButton(onPressed: () {
                                            _deleteUser(userAnswer[index][0]).then((value) => setState(() {
                                            
                                            }));
                                            Navigator.pop(context);
                                          }, icon: const Icon(Icons.delete)) : const  Text(""),
                                          (commonUser) ? IconButton(
                                            onPressed: () {
                                              _editItem(userAnswer[index][0], _bonusCount.text).then((value) => setState(() {}));
                                            }, 
                                            icon: const Icon(Icons.save)
                                          ) : const  Text(""),
                                        ],
                                      )
                                    ],
                                  )), 
                                ));
                              }, 
                              icon: const Icon(
                                Icons.contact_page,
                                size: 40,
                              )
                            ),
                            const SizedBox(width: 20,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    userAnswer[index][1],
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 23,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    userAnswer[index][2],
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],),
                        );
                      }
                    ),
                  );
                }
              }
            );
          // } else {
          //   return const Center(child: Text('Error'));
          // }

        }
  })
    );
  }
}