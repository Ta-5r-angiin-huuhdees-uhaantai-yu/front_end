import 'base_response.dart';

class LessonAllResponse extends ResponseBase {
  final List<LessonItem> data;

  LessonAllResponse({
    bool? success,
    String? message,
    required this.data,
  }) : super(
    success: success,
    message: message,
  );

  factory LessonAllResponse.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List<dynamic>? ?? [])
        .map((item) => LessonItem.fromJson(item))
        .toList();

    return LessonAllResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: dataList,
    );
  }
}

class LessonItem {
  final String lesson;
  final int questionCount;

  LessonItem({
    required this.lesson,
    required this.questionCount,
  });

  factory LessonItem.fromJson(Map<String, dynamic> json) {
    return LessonItem(
      lesson: json['lesson'] ?? '',
      questionCount: json['questionCount'] ?? 0,
    );
  }
}