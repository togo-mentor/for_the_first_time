import 'package:flutter/material.dart';
import 'package:for_the_first_time/service/auth_credentials.dart';

class SignUpPage extends StatefulWidget {
  final ValueChanged<SignUpCredentials> didProvideCredentials;
  final VoidCallback shouldShowLogin;
  SignUpPage({Key? key, required this.didProvideCredentials, required this.shouldShowLogin})
   : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 40),
          child: Stack(children: [
            // Sign Up Form
            _signUpForm(),

            // Login Button
            Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.bottomCenter,
              child: TextButton(
                  onPressed: widget.shouldShowLogin,
                  child: Text('Already have an account? Login.'),
                  style: TextButton.styleFrom(
                    primary: Colors.grey[850],
                  )
              ),
            )
          ])),
    );
  }

  void showProgressDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 500),
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  Widget _signUpForm() {
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

        // Email TextField
        TextField(
          controller: _emailController,
          decoration:
              InputDecoration(icon: Icon(Icons.mail), labelText: 'Email'),
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
          // Sign Up Button
          child: (
            TextButton(
                onPressed: () async {
                  // 全画面プログレスダイアログを表示
                  showProgressDialog();
                  await Future.delayed(Duration(seconds: 1));
                  await _signUp();
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text('Sign Up'),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Theme.of(context).accentColor,
                )
            )
          )
        )
      ],
    );
  }

  Future _signUp() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    print('username: $username');
    print('email: $email');
    print('password: $password');

    final credentials = SignUpCredentials(
      username: username, 
      email: email, 
      password: password
    );
    widget.didProvideCredentials(credentials);
  }
}