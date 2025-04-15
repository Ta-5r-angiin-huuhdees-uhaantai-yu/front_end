import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/api_service.dart';import '../model/lesson_all_response.dart';

import 'user_info_bloc.dart';

class LessonAllBloc extends Bloc<LessonAllEvent, LessonAllState> {
  final ApiService apiService;

  LessonAllBloc(this.apiService) : super(LessonAllInitial()) {
    on<FetchLessonInfo>(_onFetchLessonInfo);
  }

  Future<void> _onFetchLessonInfo(
      FetchLessonInfo event, Emitter<LessonAllState> emit) async {
    emit(LessonAllLoading());
    try {
      final response = await apiService.get('/questions/all'); // ✅ use the correct endpoint
      final lessonAllResponse = LessonAllResponse.fromJson(response.data);

      if (lessonAllResponse.success == true) {
        emit(LessonAllSuccess(data: lessonAllResponse.data));
      } else {
        emit(LessonAllFailure(error: lessonAllResponse.message ?? 'Lesson Error'));
      }
    } catch (e) {
      emit(LessonAllFailure(error: "Error: $e"));
    }
  }
}