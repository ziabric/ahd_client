// import 'package:postgres/postgres.dart';

// var databaseConnection = PostgreSQLConnection(
//     "127.0.0.1", 5432, "postgres",
//     queryTimeoutInSeconds: 3600,
//     timeoutInSeconds: 3600,
//     username: "postgres",
//     password: "user"
//   );

// initDatabaseConnection() async {
//   databaseConnection.open().then((value) {
//     debugPrint("Database Connected!");
//   });
// }

// List<Map<String, Map<String, dynamic>>> result = await databaseConnection.mappedResultsQuery("SELECT * FROM $tableUsers WHERE email = @aEmail",
//               substitutionValues: {
//             "aEmail": email,
//           });