import 'package:flutter/material.dart';
import 'package:for_the_first_time/service/auth_credentials.dart';

class LoginPage extends StatefulWidget {
  final ValueChanged<LoginCredentials> didProvideCredentials;
  final VoidCallback shouldShowSignUp;
  LoginPage({Key? key, required this.didProvideCredentials, required this.shouldShowSignUp})
   : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

   bool taped = false;


  @override
  Widget build(BuildContext context) {
    // 2
    return Scaffold(
      // 3
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
                  onPressed: widget.shouldShowSignUp,
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

  // 5
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
                // 全画面プログレスダイアログを表示
                showProgressDialog();
                await _login();
                Navigator.of(context, rootNavigator: true).pop();
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

  // 7
  Future _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    print('username: $username');
    print('password: $password');

    final credentials =
    LoginCredentials(username: username, password: password);
    widget.didProvideCredentials(credentials);
  }
}