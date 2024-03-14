import 'package:flutter/material.dart';
import 'package:app1/screens/HomeScreen.dart';
import 'package:app1/screens/LogInPage.dart'; // Import LoginPage
//import 'package:app1/screens/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  bool? rememberMe;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (rememberMe == null) {
      // If rememberMe is null, show a loading indicator or splash screen
      return CircularProgressIndicator(); // Placeholder, you can replace with your own loading indicator
    } else if (rememberMe!) {
      // If rememberMe is true, navigate directly to HomeScreen
      return HomeScreen();
    } else {
      // If rememberMe is false, navigate to LoginPage
      return LoginPage();
    }
  }
}
