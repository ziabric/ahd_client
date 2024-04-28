import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'GlobalVariables.dart';

class Price extends StatefulWidget {
  const Price({super.key});
  @override
  State<Price> createState() => _PriceState();
}

class _PriceState extends State<Price> {

  TextEditingController _priceController = TextEditingController();
  String _prevPrice = '';

  Future<List<List<String>>> _getUsers (Connection handler) async {
    List<List<String>> output = [];
    final result = await handler.execute("select * from material join prices on prices.item_id_=material.item_id_;");

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
  
  Future<void> _deleteItem(String id) async {
    final handler = await Connection.open(Endpoint(host: 'localhost', port: 5432, database: 'postgres', username: g_login, password: 'user',));
    await handler.execute("DELETE FROM material WHERE client_id_=$id;");
    await handler.close();
  }

  Future<void> _editItem(String id, String newPrice) async {
    final handler = await Connection.open(Endpoint(host: 'localhost', port: 5432, database: 'postgres', username: g_login, password: 'user',));
    await handler.execute("UPDATE prices SET price_=$newPrice WHERE item_id_=$id;");
    await handler.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: Connection.open(Endpoint(host: 'localhost', port: 5432, database: 'postgres', username: g_login, password: 'user',)), 
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

                        List<String> titles = ["ID", 
                                              "Название товара", 
                                              "Номер категории", 
                                              "Дата создания", 
                                              "Название категории",
                                              "",
                                              "",
                                              "Цена",
                                              "",
                                              ""
                                            ];
                        List<Widget> widgets = [];

                        for (int i = 0; i < ((titles.length < userAnswer.length) ? titles.length : userAnswer.length) ; i += 1) {
                          if (titles[i] == '') continue;
                          widgets.add(Text("${titles[i]}: ${userAnswer[index][i]}"));
                          widgets.add(const Divider());
                        }
                        print(userAnswer.length);
                        // widgets.add(
                        //   Container(
                        //     alignment: Alignment.center,
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.exit_to_app)),
                        //         IconButton(
                        //           onPressed: () {
                        //             _deleteItem(userAnswer[index][0]);
                        //           }, 
                        //           icon: const Icon(Icons.delete)
                        //         ),
                        //         IconButton(
                        //           onPressed: () {
                        //           }, 
                        //           icon: const Icon(Icons.save)
                        //         ),
                        //       ],
                        //     ),
                        //   )
                        // );

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [boxShadow]
                          ),
                          padding: const EdgeInsets.all(25),
                          child: Row(
                            children: [
                            IconButton(
                              onPressed: () {
                                _priceController = TextEditingController.fromValue(TextEditingValue(text: userAnswer[index][7]));
                                _prevPrice = userAnswer[index][7];
                                showDialog(context: context, builder: (context) => Dialog(
                                  child: Container(
                                    padding: const EdgeInsets.all(10), 
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("${titles[0]}: ${userAnswer[index][0]}"),
                                        const Divider(),
                                        Text("${titles[1]}: ${userAnswer[index][1]}"),
                                        const Divider(),
                                        Text("${titles[2]}: ${userAnswer[index][2]}"),
                                        const Divider(),
                                        Text("${titles[3]}: ${userAnswer[index][3]}"),
                                        const Divider(),
                                        Text("${titles[4]}: ${userAnswer[index][4]}"),
                                        const Divider(),
                                        TextField(
                                          decoration: const InputDecoration(labelText: 'Цена'),
                                          obscureText: false,
                                          controller: _priceController,
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
                                                  _deleteItem(userAnswer[index][0]);
                                                }, 
                                                icon: const Icon(Icons.delete)
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  if (_priceController.text != _prevPrice) _editItem(userAnswer[index][0], _priceController.text).then((value) => setState(() {}));
                                                }, 
                                                icon: const Icon(Icons.save)
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ), 
                                ));
                              }, 
                              icon: const Icon(
                                Icons.storage,
                                size: 40,
                              )
                            ),
                            const SizedBox(width: 20,),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userAnswer[index][1],
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 23,
                                    ),
                                  ),
                                  Text(
                                    userAnswer[index][7],
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
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


                        // final TextEditingController _price = TextEditingController(text: userAnswer[index][2]);
                        // final TextEditingController _from = TextEditingController(text: userAnswer[index][3]);
                        // final TextEditingController _to = TextEditingController(text: userAnswer[index][4]);
                        // final TextEditingController _type = TextEditingController(text: userAnswer[index][9]);


                                      // Text(userAnswer[index][6],
                                      //   style: const TextStyle(
                                      //     fontSize: 30
                                      //   ),
                                      // ),
                                      // const Divider(),
                                      // TextField(
                                      //   decoration: const InputDecoration(labelText: 'Price'),
                                      //   controller: _price,
                                      // ),
                                      // TextField(
                                      //   decoration: const InputDecoration(labelText: 'From'),
                                      //   controller: _from,
                                      // ),
                                      // TextField(
                                      //   decoration: const InputDecoration(labelText: 'To'),
                                      //   controller: _to,
                                      // ),
                                      // const SizedBox(height: 7,),
                                      // Text(
                                      //   "Type: ${userAnswer[index][9]}",
                                      //   style: const TextStyle(
                                      //     fontSize: 16
                                      //   ),
                                      // ),
                                      // const Divider(),