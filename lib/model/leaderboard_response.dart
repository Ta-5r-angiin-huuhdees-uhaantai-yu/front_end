import 'base_response.dart';

class LeaderboardResponse extends ResponseBase {
  final List<LeaderItem> leaderboard;

  LeaderboardResponse({
    bool? success,
    String? message,
    required this.leaderboard,
  }) : super(success: success, message: message);

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    final leaderboardList = (json['leaderboard'] as List<dynamic>? ?? [])
        .map((item) => LeaderItem.fromJson(item))
        .toList();

    return LeaderboardResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      leaderboard: leaderboardList, // ✅ fixed field name
    );
  }
}

class LeaderItem {
  final String login_name;
  final String profileImage;
  final int totalPoints;
  final int? rank;

  LeaderItem({
    required this.login_name,
    required this.profileImage,
    required this.totalPoints,
    this.rank,
  });

  factory LeaderItem.fromJson(Map<String, dynamic> json) {
    return LeaderItem(
      login_name: json['login_name'] ?? '',
      profileImage: json['profileImage'] ?? '',
      totalPoints: json['totalPoints'] ?? 0,
      rank: json['rank'],
    );
  }
}
