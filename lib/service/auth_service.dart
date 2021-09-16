import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// Amplify Flutter Packages
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

abstract class AuthCredentials {
  final String username;
  final String password;

  AuthCredentials({required this.username, required this.password})
      : assert(username != null),
        assert(password != null);
}

class LoginCredentials extends AuthCredentials {
  LoginCredentials({required String username, required String password})
      : super(username: username, password: password);
}

class SignUpCredentials extends AuthCredentials {
  final String email;
  SignUpCredentials({required String username, required String password, required this.email})
      : assert(email != null),
        super(username: username, password: password);
}

class AuthService {
  bool isSignedIn = false;
  late LoginData data;

  static Future<AuthUser> get currentUser async {
    return await Amplify.Auth.getCurrentUser();
  }

  static Future<AuthSession> get authSession async {
    return await Amplify.Auth.fetchAuthSession();
  }

  static Future<void> signOut() async {
    Amplify.Auth.signOut();
  }

  Future<SignInResult> _signIn(AuthCredentials credentials) async {
    return await Amplify.Auth.signIn(
        username: credentials.username, password: credentials.password);
  }

  Future<SignUpResult> _signUp(SignUpCredentials credentials) async {
    return await Amplify.Auth.signUp(
        username: credentials.email,
        password: credentials.password,
        options: CognitoSignUpOptions(userAttributes: {
          'email': credentials.email,
        }));
  }

  Future<String?> onLogin(LoginData data) async {
    try {
      final credentials = LoginCredentials(
        username: data.name,
        password: data.password,
      );

      final res = await _signIn(credentials);
      isSignedIn = res.isSignedIn;
    } on AuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> onSignup(LoginData data) async {
    try {
      await _signUp(SignUpCredentials(
        email: data.name,
        password: data.password,
        username: data.name,
      ));

      this.data = data;
    } on AuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> onRecoverPassword(String email) async {
    try {
      final res = await Amplify.Auth.resetPassword(username: email);
    } on AuthException catch (e) {
      return e.message;
    }
  }

  Future<void> resetPassword(LoginData data, String code, String password,
      VoidCallback onSucceeded) async {
    final res = await Amplify.Auth.confirmPassword(
      username: data.name,
      newPassword: password,
      confirmationCode: code,
    );
    onSucceeded();
  }

  Future<void> verifyCode(
      LoginData data, String code, VoidCallback onSucceeded) async {
    final res = await Amplify.Auth.confirmSignUp(
      username: data.name,
      confirmationCode: code,
    );

    if (res.isSignUpComplete) {
      // Login user
      final user = await Amplify.Auth.signIn(
          username: data.name, password: data.password);

      if (user.isSignedIn) {
        onSucceeded();
      }
    }
  }

  Future<void> resendCode(LoginData data, VoidCallback onSucceeded) async {
    await Amplify.Auth.resendSignUpCode(username: data.name);
    onSucceeded();
  }
}
