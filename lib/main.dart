//import 'package:app1/screens/HomeScreen.dart';

import 'package:app1/firebase_options.dart';
import 'package:app1/screens/splashScreen.dart';
import 'package:app1/screens/widgetTree.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

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
        scaffoldBackgroundColor: Color(0xff0A0B10),
        useMaterial3: true,
      ),


      home: SplashScreen(),
    );
  }
}