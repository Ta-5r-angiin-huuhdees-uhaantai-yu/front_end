class LoginRequest {
  final String? login_name;
  final String? password;

  LoginRequest({
    this.login_name,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'login_name': login_name,
      'password': password,
    };
  }
}
