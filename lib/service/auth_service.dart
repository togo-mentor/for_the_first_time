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
    } on AmplifyException {
      rethrow;
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
        loginWithCredentials(credentials); // サインアップが完了したらログインする
      } else {
        final state = AuthState(authFlowStatus: AuthFlowStatus.verification); // サインアップが完了していない場合、認証ページに遷移
        authStateController.add(state);
      }
    } on AmplifyException {
      rethrow;
    }
  }

  // メール認証
  void verifyCode(String verificationCode) {
    final state = AuthState(authFlowStatus: AuthFlowStatus.session); // 認証が終わったらユーザーをログイン状態にする
    authStateController.add(state);
  }

  // ログアウトする
  void logOut() async {
    try {
      await Amplify.Auth.signOut(); // サインアウト
      showLogin(); // ログインページに遷移
    } on AmplifyException catch (authError) {
      print('Failed to sign up - $authError');
    }
  }

  // ログイン中かどうか判定する
  void checkAuthStatus() async {
    try {
      await Amplify.Auth.fetchAuthSession();
      final state = AuthState(authFlowStatus: AuthFlowStatus.session); // ログイン中
      authStateController.add(state);
    } catch (_) {
      final state = AuthState(authFlowStatus: AuthFlowStatus.login); // ログアウト状態の場合、ログインページに遷移
      authStateController.add(state);
    }
  }
}