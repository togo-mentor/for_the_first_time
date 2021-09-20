// ログインと新規登録に共通する情報を管理する
abstract class AuthCredentials {
  final String username;
  final String password;

  AuthCredentials({required this.username, required this.password});
}

// ログイン時の認証情報(username ,password)
class LoginCredentials extends AuthCredentials {
  LoginCredentials({required String username, required String password})
      : super(username: username, password: password);
}

// 新規登録時の認証情報(username, email, password)
class SignUpCredentials extends AuthCredentials {
  final String email;

  SignUpCredentials({required String username, required String password, required this.email})
      : super(username: username, password: password);
}