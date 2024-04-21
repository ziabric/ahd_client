import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'GlobalVariables.dart';

class Price extends StatefulWidget {
  const Price({super.key});
  @override
  State<Price> createState() => _PriceState();
}

class _PriceState extends State<Price> {

  Future<List<List<String>>> _getUsers (Connection handler) async {
    List<List<String>> output = [];
    final result = await handler.execute("select * from prices left join (select * from material) as mat on mat.item_id_=prices.item_id_;");

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

                        final TextEditingController _price = TextEditingController(text: userAnswer[index][2]);
                        final TextEditingController _from = TextEditingController(text: userAnswer[index][3]);
                        final TextEditingController _to = TextEditingController(text: userAnswer[index][4]);
                        final TextEditingController _type = TextEditingController(text: userAnswer[index][9]);

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [boxShadow]
                          ),
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                            IconButton(
                              onPressed: () {
                                showDialog(context: context, builder: (context) => Dialog(
                                  child: Container(
                                    padding: const EdgeInsets.all(10), 
                                    child:  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(userAnswer[index][6],
                                        style: const TextStyle(
                                          fontSize: 30
                                        ),
                                      ),
                                      const Divider(),
                                      TextField(
                                        decoration: const InputDecoration(labelText: 'Price'),
                                        controller: _price,
                                      ),
                                      TextField(
                                        decoration: const InputDecoration(labelText: 'From'),
                                        controller: _from,
                                      ),
                                      TextField(
                                        decoration: const InputDecoration(labelText: 'To'),
                                        controller: _to,
                                      ),
                                      const SizedBox(height: 7,),
                                      Text(
                                        "Type: ${userAnswer[index][9]}",
                                        style: const TextStyle(
                                          fontSize: 16
                                        ),
                                      ),
                                      const Divider(),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.exit_to_app)),
                                            IconButton(
                                              onPressed: () {
                                                
                                              }, 
                                              icon: const Icon(Icons.save)
                                            )
                                          ],
                                        ),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    userAnswer[index][6],
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