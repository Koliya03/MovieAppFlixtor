import 'package:app1/dependency_injection.dart';
import 'package:app1/firebase_options.dart';
import 'package:app1/screens/LoginPage.dart'; // Import LoginPage
import 'package:app1/screens/HomeScreen.dart';
import 'package:app1/screens/authentication.dart';
import 'package:app1/screens/widgetTree.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load the "Remember me" status from shared preferences
  final prefs = await SharedPreferences.getInstance();
  final rememberMe = prefs.getBool('rememberMe') ?? false;

  runApp(MyApp(rememberMe: rememberMe));
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  final bool rememberMe;

  const MyApp({Key? key, required this.rememberMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Movie App',
      theme: ThemeData.dark().copyWith(
       // scaffoldBackgroundColor: const Color.fromARGB(198, 0, 0, 0),
        scaffoldBackgroundColor: const Color(0xff0A0B10),
        useMaterial3: true,
      ),
      home: rememberMe ? HomeScreen() : LoginPage(), // Show HomeScreen or LoginPage based on "Remember me"
    );
  }
}
