// import 'package:kitsune/model/base_response.dart';

import 'base_response.dart';

class LoginResponse extends ResponseBase {
  LoginResponse({
    bool? success,
    String? token,
  }) : super(
    success: success,
    token: token,
  );

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool?,
      token: json['token'] as String?,
    );
  }
}