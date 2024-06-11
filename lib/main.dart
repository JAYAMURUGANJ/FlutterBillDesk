import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/goPay.dart';

void main() {
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
            primary: Colors.deepOrangeAccent, seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const GoPay(),
    );
  }
}
