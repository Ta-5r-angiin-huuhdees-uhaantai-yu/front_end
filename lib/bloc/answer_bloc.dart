import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/answer_request.dart';
import '../model/answer_response.dart';
import '../model/token_preference.dart';
import '../model/variables.dart';

/// ---------------------------------------------------------------------------
/// AnswerBloc
/// ---------------------------------------------------------------------------
class AnswerBloc extends Bloc<AnswerEvent, AnswerState> {
  AnswerBloc() : super(AnswerInitial()) {
    on<AnswerSubmitted>(_onAnswerSubmitted);
    on<BulkAnswersSubmitted>(_onBulkAnswersSubmitted);
  }

  final cookiePref = CookiePreference();

  Future<void> _onAnswerSubmitted(
      AnswerSubmitted event, Emitter<AnswerState> emit) async {
    emit(AnswerLoading());

    try {
      AnswerRequest request = AnswerRequest(
        questionId: event.questionId ?? '',
        selectedIndex: event.selectedIndex ?? 0,
      );

      final response =
          await apiService.Post('/choose/answer', data: request.toJson());

      final answerResponse = AnswerResponse.fromJson(response.data);

      if (answerResponse.success == true) {
        print('Raw response: ${response.data}'); // debug
        print('Raw response: ${answerResponse.data}'); // debug
        print('eethrhtyjtyjtyj${answerResponse.correct}');
        emit(AnswerSuccess(
          correct: answerResponse.correct,
          answeredCount: answerResponse.answeredCount,
          message: answerResponse.message ?? '',
        ));
      } else {
        print('wefhwewiefbhiwefubgwe${answerResponse.message}');
        emit(AnswerFailure(error: answerResponse.message ?? 'Answer Error'));
      }
    } catch (e) {
      print('ggggggggggggggg${e}');
      emit(AnswerFailure(error: 'Catch Error occurred: $e'));
    }
  }

  Future<void> _onBulkAnswersSubmitted(
      BulkAnswersSubmitted event,
      Emitter<AnswerState> emit,
      ) async {
    emit(AnswerLoading());
    try {
      final response = await apiService.Post(
        '/choose/answer',
        data: jsonDecode(jsonEncode({'answers': event.answers})), // ✅ ensures correct JSON
      );

      final data = response.data;
      if (data['success'] == true) {
        print('cccccccccccccc${response.data}');
        emit(BulkAnswerSuccess(
          correct: null,
          earnedMoney: data['earnedMoney'],
          correctCount: data['correct'],
          message: "Submitted",
        ));
      } else {
        emit(BulkAnswerFailure(error: data['message'] ?? 'Failed to submit answers'));
      }
    } catch (e) {
      emit(BulkAnswerFailure(error: 'Catch error: $e'));
    }
  }
}

/// ---------------------------------------------------------------------------
/// AnswerEvent
/// ---------------------------------------------------------------------------
abstract class AnswerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AnswerSubmitted extends AnswerEvent {
  final String? questionId;
  final int? selectedIndex;

  AnswerSubmitted({this.questionId, this.selectedIndex});

  @override
  List<Object?> get props => [questionId, selectedIndex];
}

class BulkAnswersSubmitted extends AnswerEvent {
  final List<Map<String, dynamic>> answers;

  BulkAnswersSubmitted(this.answers);

  @override
  List<Object?> get props => [answers];
}

/// ---------------------------------------------------------------------------
/// AnswerState
/// ---------------------------------------------------------------------------
@immutable
abstract class AnswerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AnswerInitial extends AnswerState {
  AnswerInitial() : super();
}

class AnswerLoading extends AnswerState {
  AnswerLoading() : super();
}

class AnswerSuccess extends AnswerState {
  final bool? correct;
  final int? answeredCount;
  final String? message;

  AnswerSuccess({
    this.correct,
    this.answeredCount,
    this.message,
  });

  @override
  List<Object?> get props => [message];
}

class BulkAnswerSuccess extends AnswerState {
  final bool? correct;
  final int? earnedMoney;
  final int? correctCount;
  final String? message;

  BulkAnswerSuccess({
    this.correct,
    this.earnedMoney,
    this.correctCount,
    this.message,
  });

  @override
  List<Object?> get props => [correct, earnedMoney, correctCount, message];
}

class AnswerFailure extends AnswerState {
  final String? error;

  AnswerFailure({this.error});

  @override
  List<Object?> get props => [error];
}

class BulkAnswerFailure extends AnswerState {
  final String? error;

  BulkAnswerFailure({this.error});

  @override
  List<Object?> get props => [error];
}
