import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'GlobalVariables.dart';

class PersReq extends StatefulWidget {
  const PersReq({super.key});
  @override
  State<PersReq> createState() => _PersReqState();
}

class _PersReqState extends State<PersReq> {

  Future<List<List<String>>> _getUsers (Connection handler) async {
    List<List<String>> output = [];
    final result = await handler.execute("SELECT item_id_,item_name_,mat.type_,pr.price_ - disc.discont_  AS prices FROM material mat INNER JOIN prices pr USING(item_id_) LEFT JOIN discounts disc USING(item_id_) WHERE current_date BETWEEN pr.date_from_ AND pr.date_to_ AND current_date BETWEEN disc.date_from_ AND disc.date_to_");

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

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [boxShadow]
                          ),
                          padding: const EdgeInsets.all(25),
                          child: Row(
                            children: [
                            Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                fontSize: 30
                              ),
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
                                    userAnswer[index][1],
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
