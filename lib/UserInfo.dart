import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'GlobalVariables.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});
  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  Future<List<List<String>>> _getUsers (Connection handler) async {
    List<List<String>> output = [];
    final result = await handler.execute("SELECT * FROM customer");

    for (var row in result) {
      List<String> newRow = [];
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
        print(item.toString().length);
      }
      output.add(newRow);
    }

    await handler.close();

    return output;
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
            print(handler.error);
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
                                showDialog(context: context, builder: (context) => Dialog(
                                  child: Container(
                                    padding: const EdgeInsets.all(10), 
                                    child:  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Name: ${userAnswer[index][1]}"),
                                      const Divider(),
                                      Text("Age: ${userAnswer[index][2]}"),
                                      const Divider(),
                                      Text("id: ${userAnswer[index][0]}"),
                                      const Divider(),
                                      Text("Birthday: ${userAnswer[index][3]}"),
                                      const Divider(),
                                      Text("CN: ${userAnswer[index][4]}"),
                                      const Divider(),
                                      Text("Bonus: ${userAnswer[index][5]}"),
                                      const Divider(),
                                      IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.exit_to_app))
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