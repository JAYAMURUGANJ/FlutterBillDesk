import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/start_txn.dart';
import 'sqlite-helper/db_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper.instance;

  if (!await dbHelper.databaseExists('orders.db')) {
    final db = await dbHelper.database;
    await dbHelper.createTable(db);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BillDesk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          primary: Colors.deepOrangeAccent,
          seedColor: Colors.orange,
        ),
        useMaterial3: true,
      ),
      home: const StartTxn(),
    );
  }
}
