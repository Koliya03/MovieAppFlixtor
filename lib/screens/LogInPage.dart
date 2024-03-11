import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app1/screens/HomeScreen.dart';
import 'package:app1/screens/SignUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app1/screens/authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  String? errorMessage = '';
  late bool rememberMe;

  @override
  void initState() {
    super.initState();
    rememberMe = false;
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        _controllerEmail.text = prefs.getString('email') ?? '';
        _controllerPassword.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _saveRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value);
    if (!value) {
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0A0B10),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            _frontTitle(),
            SizedBox(height: 50),
            _entryField('Email', _controllerEmail),
            SizedBox(height: 20),
            _entryField('Password', _controllerPassword),
            SizedBox(height: 20),
            _errorMessage(),
            SizedBox(height: 20),
            _buildRememberMeCheckbox(),
            SizedBox(height: 20),
            _buildLoginButton(context),
            SizedBox(height: 20),
            _buildSignUpLink(context),
          ],
        ),
      ),
    );
  }

  Widget _frontTitle() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              text: "Hey Welcome Back,\nLogin",
              children: [
                TextSpan(
                  style: TextStyle(
                    color: Color(0xffB40026),
                  ),
                  text: " Now. ",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(color: Color.fromARGB(255, 247, 245, 245)),
          fillColor: Color.fromARGB(255, 159, 83, 83).withOpacity(0.03),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Error: $errorMessage',
      style: TextStyle(color: Colors.red),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: (value) {
            setState(() {
              rememberMe = value!;
            });
            _saveRememberMe(value!);
          },
        ),
        Text(
          'Remember me',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
Widget _buildLoginButton(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 40),
    child: TextButton(
      onPressed: () => signInWithEmailAndPassword(context),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.zero,
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.transparent,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          Colors.white,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            colors: [
              Color(0xff43060F).withOpacity(0.2),
              Color(0xff43060F),
              Color(0xff43060F).withOpacity(0.2),
            ],
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}



  Widget _buildSignUpLink(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.white, fontSize: 16),
        text: "Don't you have an account? ",
        children: [
          TextSpan(
            text: 'Sign Up',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
          ),
        ],
      ),
    );
  }
}
