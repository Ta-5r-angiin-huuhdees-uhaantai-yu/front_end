import 'package:bd_frontend/model/choose_question_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/api_service.dart';
import 'package:equatable/equatable.dart';
import '../model/leaderboard_response.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final ApiService apiService;

  LeaderboardBloc(this.apiService) : super(LeaderboardInitial()) {
    on<FetchUserAllInfo>(_onFetchUserAllInfo);
  }

  Future<void> _onFetchUserAllInfo(
      FetchUserAllInfo event, Emitter<LeaderboardState> emit) async {
    emit(LeaderboardLoading());
    try {
      final response = await apiService.get('/leaderboard');
      final leaderboardResponse = LeaderboardResponse.fromJson(response.data);

      if (leaderboardResponse.success == true) {
        print('wwwwwwwwwwwwwwww${response.data}');
        emit(LeaderboardSuccess(data: leaderboardResponse.leaderboard));

      } else {
        emit(LeaderboardFailure(error: leaderboardResponse.message ?? 'Lesson Error'));
      }
    } catch (e) {
      emit(LeaderboardFailure(error: "Error: $e"));
    }
  }
}


abstract class LeaderboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserAllInfo extends LeaderboardEvent {}

abstract class LeaderboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardSuccess extends LeaderboardState {
  final List<LeaderItem>? data;

  LeaderboardSuccess({
    this.data,
  });

  @override
  List<Object?> get props => [data];
}

class LeaderboardFailure extends LeaderboardState {
  final String? error;

  LeaderboardFailure({this.error});

  @override
  List<Object?> get props => [error];
}