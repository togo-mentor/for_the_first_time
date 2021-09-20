import 'dart:async';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'auth_credentials.dart';

// ログイン周りのどのページにいるのかを管理するenum
enum AuthFlowStatus { login, signUp, verification, session }

// AuthFlowStatusを管理するstate
class AuthState {
  final AuthFlowStatus authFlowStatus;

  AuthState({required this.authFlowStatus});
}

// Amplifyと通信しつつ、AuthFlowStatusを変更する
class AuthService {
  final authStateController = StreamController<AuthState>();

  // サインアップページを表示する
  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  // ログインページを表示する
  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  // ログインする
  void loginWithCredentials(AuthCredentials credentials) async {
    try {
      final result = await Amplify.Auth.signIn(
          username: credentials.username, password: credentials.password
      );

      if (result.isSignedIn) {
        final state = AuthState(authFlowStatus: AuthFlowStatus.session);
        authStateController.add(state);
      } else {
        print('User could not be signed in');
      }
    } on AmplifyException catch (authError) {
      throw authError;
    }
  }

  // 新規登録する
  void signUpWithCredentials(SignUpCredentials credentials) async {
    try {
      final userAttributes = {'email': credentials.email};

      final result = await Amplify.Auth.signUp(
          username: credentials.username,
          password: credentials.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes)
      );

      if (result.isSignUpComplete) {
        loginWithCredentials(credentials);
      } else {
        final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
        authStateController.add(state);
      }
    } on AmplifyException catch (authError) {
      throw authError;
    }
  }

  // メール認証
  void verifyCode(String verificationCode) {
    final state = AuthState(authFlowStatus: AuthFlowStatus.session);
    authStateController.add(state);
  }

  // ログアウトする
  void logOut() async {
    try {
      // 1
      await Amplify.Auth.signOut();

      // 2
      showLogin();
    } on AmplifyException catch (authError) {
      print('Failed to sign up - $authError');
    }
  }

  // ログイン中かどうか判定する
  void checkAuthStatus() async {
    try {
      await Amplify.Auth.fetchAuthSession();
      final state = AuthState(authFlowStatus: AuthFlowStatus.session);
      authStateController.add(state);
    } catch (_) {
      final state = AuthState(authFlowStatus: AuthFlowStatus.login);
      authStateController.add(state);
    }
  }
}