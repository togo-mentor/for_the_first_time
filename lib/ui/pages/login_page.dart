import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:for_the_first_time/ui/pages/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback shouldLogin;
  LoginPage({Key? key, required this.shouldLogin})
   : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

   bool taped = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 40),
          // 4
          child: Stack(children: [
            // Login Form
            _loginForm(),

            // 6
            // Sign Up Button
            Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.bottomCenter,
              child: TextButton(
                  onPressed: () {

                  }, // 新規登録ページに遷移
                  child: Text('Don\'t have an account? Sign up.'),
                  style: TextButton.styleFrom(
                    primary: Colors.grey[850],
                  )),
              ),
            ]
          )),
    );
  }
  // 全画面プログレスダイアログを表示する関数
  void showProgressDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 300),
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  Widget _buildGoogleSignInButton() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              child: Text("Google Sign In"),
              onPressed: () async {
              try {
                widget.shouldLogin();
              } catch (e) {
                print(e);
              }
            },
          )),
        ],
      )
    );
  }

  Widget _loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Username TextField
        TextField(
          controller: _usernameController,
          decoration:
              InputDecoration(icon: Icon(Icons.person), labelText: 'Username'),
        ),
        SizedBox(
          height: 15,
        ),

        // Password TextField
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
              icon: Icon(Icons.lock_open), labelText: 'Password'),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),
        SizedBox(
          height: 25,
        ),

        SizedBox( 
          width: 120,
          // Login Button
          child: TextButton(
              onPressed: () async {
                widget.shouldLogin();
              },
              child: Text('Login'),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Theme.of(context).accentColor,
              ),
          ),
        )
      ],
    );
  }

  // Future _login() async {
  //   final username = _usernameController.text.trim();
  //   final password = _passwordController.text.trim();

  //   print('username: $username');
  //   print('password: $password');

  //   final credentials =
  //   LoginCredentials(username: username, password: password);
  //   widget.didProvideCredentials(credentials);
  // }
}