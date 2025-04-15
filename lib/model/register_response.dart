import 'base_response.dart';

class RegisterResponse extends ResponseBase {
  RegisterResponse({
    bool? success,
    String? token,
  }) : super(
          success: success,
          token: token,
        );

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] as bool?,
      token: json['token'] as String?,
    );
  }
}
