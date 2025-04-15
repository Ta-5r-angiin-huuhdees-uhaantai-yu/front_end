import 'package:bd_frontend/model/choose_question_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/api_service.dart';
import 'package:equatable/equatable.dart';
import '../model/choose_question_response.dart';

class ChooseQuestionBloc extends Bloc<ChooseQuestionEvent, ChooseQuestionState> {
  final ApiService apiService;

  ChooseQuestionBloc(this.apiService) : super(ChooseQuestionInitial()) {
    on<FetchLessonAllInfo>(_onFetchLessonAllInfo);
  }

  Future<void> _onFetchLessonAllInfo(
      FetchLessonAllInfo event, Emitter<ChooseQuestionState> emit) async {
    emit(ChooseQuestionLoading());
    try {
      final response = await apiService.get('/choose/question');
      final chooseQuestionResponse = ChooseQuestionResponse.fromJson(response.data);

      if (chooseQuestionResponse.success == true) {
        print('wwwwwwwwwwwwwwww${response.data}');
        emit(ChooseQuestionSuccess(data: chooseQuestionResponse.data));
      } else {
        emit(ChooseQuestionFailure(error: chooseQuestionResponse.message ?? 'Lesson Error'));
      }
    } catch (e) {
      emit(ChooseQuestionFailure(error: "Error: $e"));
    }
  }
}


abstract class ChooseQuestionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLessonAllInfo extends ChooseQuestionEvent {}

abstract class ChooseQuestionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChooseQuestionInitial extends ChooseQuestionState {}

class ChooseQuestionLoading extends ChooseQuestionState {}

class ChooseQuestionSuccess extends ChooseQuestionState {
  final List<QuestionItem>? data;

  ChooseQuestionSuccess({
    this.data,
  });

  @override
  List<Object?> get props => [data];
}

class ChooseQuestionFailure extends ChooseQuestionState {
  final String? error;

  ChooseQuestionFailure({this.error});

  @override
  List<Object?> get props => [error];
}