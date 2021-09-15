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