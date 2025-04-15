class AnswerRequest {
  final String? questionId;
  final int? selectedIndex;

  AnswerRequest({
    this.questionId,
    this.selectedIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedIndex': selectedIndex,
    };
  }
}
