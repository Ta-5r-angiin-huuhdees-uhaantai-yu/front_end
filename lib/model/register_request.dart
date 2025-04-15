class RegisterRequest {
  final String login_name;
  final String email;
  final String password;

  RegisterRequest({
    required this.login_name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'login_name': login_name,
      'email': email,
      'password': password,
    };
  }
}
