import 'package:app1/screens/HomeScreen.dart';
import 'package:app1/screens/authentication.dart';
import 'package:app1/screens/login_registration.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class widgetTree extends StatefulWidget {
  const widgetTree({super.key});

  @override
  State<widgetTree> createState() => _widgetTreeState();
}

class _widgetTreeState extends State<widgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          return HomeScreen();

        }else{
          return  registrationPage();
        }
      },
    );
  }
}