import 'base_response.dart';

class ChooseQuestionResponse extends ResponseBase {
  final List<QuestionItem> data;

  ChooseQuestionResponse({
    bool? success,
    String? message,
    required this.data,
  }) : super(success: success, message: message);

  factory ChooseQuestionResponse.fromJson(Map<String, dynamic> json) {
    final questionList = (json['questions'] as List<dynamic>? ?? [])
        .map((item) => QuestionItem.fromJson(item))
        .toList();

    return ChooseQuestionResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: questionList,
    );
  }
}

class QuestionItem {
  final String id;
  final String lesson;
  final int classLevel;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  QuestionItem({
    required this.id,
    required this.lesson,
    required this.classLevel,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory QuestionItem.fromJson(Map<String, dynamic> json) {
    return QuestionItem(
      id: json['_id'] ?? '',
      lesson: json['lesson'] ?? '',
      classLevel: json['classLevel'] ?? 0,
      questionText: json['questionText'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correctAnswerIndex'] ?? 0,
    );
  }
}