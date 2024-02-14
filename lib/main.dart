import 'package:app1/screens/HomeScreen.dart';
//import 'package:app1/homeScreenTest.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Movie App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(198, 0, 0, 0),
        useMaterial3: true,
      ),


      home: HomeScreen(),
    );
  }
}
