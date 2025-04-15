import 'base_response.dart';

class AnswerResponse extends ResponseBase {
  final bool? correct;
  final int? answeredCount;

  AnswerResponse({
    bool? success,
    String? message,
    this.correct,
    this.answeredCount,
  }) : super(
    success: success,
    message: message,
  );

  factory AnswerResponse.fromJson(Map<String, dynamic> json) {
    return AnswerResponse(
      success: json['success'] as bool?,
      correct: json['correct'] as bool?,
      answeredCount: json['answeredCount'] as int?,
      message: json['message'] as String?,
    );
  }
}