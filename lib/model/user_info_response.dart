import 'base_response.dart';

class UserInfoResponse extends ResponseBase {
  final String? loginName;
  final String? profileImage;
  final int? totalPoints;
  final int? rank;
  final String? id;

  UserInfoResponse({
    bool? success,
    String? message,
    String? token,
    this.loginName,
    this.profileImage,
    this.totalPoints,
    this.rank,
    this.id,
  }) : super(
    success: success,
    message: message,
  );

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return UserInfoResponse(
      success: json['success'] as bool?,
      loginName: user['login_name'] ?? '',
      profileImage: user['profileImage'] ?? '',
      totalPoints: user['totalPoints'] ?? 0,
      rank: user['rank'] ?? 0,
      id: user['_id'] ?? '',
    );
  }
}
