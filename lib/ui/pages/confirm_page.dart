import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'main_page.dart';
import '../../service/auth_service.dart';

class ConfirmPage extends StatefulWidget {
  final data = LoginData;

  @override
  State<StatefulWidget> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  final _authService = AuthService();
  Duration get loginTime => Duration(milliseconds: 2250);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: '認証コードを送信',
      onLogin: _authService.onSignup,
      onSignup: _authService.onSignup,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed(
          _authService.isSignedIn ? '/main' : '/confirm',
          arguments: _authService.data,
        );
      },
      onRecoverPassword: _authService.onRecoverPassword,
    );
  }
}