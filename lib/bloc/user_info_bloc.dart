import 'package:bd_frontend/model/lesson_all_response.dart';
import 'package:bd_frontend/model/user_info_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/api_service.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final ApiService apiService;

  UserInfoBloc(this.apiService) : super(UserInfoInitial()) {
    on<FetchUserInfo>(_onFetchUserInfo);
  }

  Future<void> _onFetchUserInfo(
      FetchUserInfo event, Emitter<UserInfoState> emit) async {
    emit(UserInfoLoading());
    try {
      final response = await apiService.get('/user/info');

      final userInfoResponse = UserInfoResponse.fromJson(response.data);

      if (userInfoResponse.success == true) {
        print('Login Name: ${userInfoResponse.loginName}');
        print('Profile Image: ${userInfoResponse.profileImage}');
        print('Total Points: ${userInfoResponse.totalPoints}');
        print('Rank: ${userInfoResponse.rank}');
        print('id: ${userInfoResponse.id}');
        emit(UserInfoSuccess(
          loginName: userInfoResponse.loginName,
          profileImage: userInfoResponse.profileImage,
          totalPoints: userInfoResponse.totalPoints,
          rank: userInfoResponse.rank,
          id: userInfoResponse.id,
        ));
      } else {
        print('wefhwewiefbhiwefubgwe${userInfoResponse.message}');
        emit(UserInfoFailure(error: userInfoResponse.message ?? 'Info Error'));
      }
    } catch (e) {
      emit(UserInfoFailure(error: "Error: $e"));
    }
  }
}

abstract class UserInfoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserInfo extends UserInfoEvent {}

abstract class UserInfoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoSuccess extends UserInfoState {
  final String? loginName;
  final String? profileImage;
  final int? totalPoints;
  final int? rank;
  final String? id;

  UserInfoSuccess({
    this.loginName,
    this.profileImage,
    this.totalPoints,
    this.rank,
    this.id,
  });

  @override
  List<Object?> get props => [loginName, profileImage, totalPoints, rank, id];
}

class UserInfoFailure extends UserInfoState {
  final String? error;

  UserInfoFailure({this.error});

  @override
  List<Object?> get props => [error];
}





abstract class LessonAllEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLessonInfo extends LessonAllEvent {}

abstract class LessonAllState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LessonAllInitial extends LessonAllState {}

class LessonAllLoading extends LessonAllState {}

class LessonAllSuccess extends LessonAllState {
  final List<LessonItem>? data;

  LessonAllSuccess({
    this.data,
  });

  @override
  List<Object?> get props => [data];
}

class LessonAllFailure extends LessonAllState {
  final String? error;

  LessonAllFailure({this.error});

  @override
  List<Object?> get props => [error];
}
