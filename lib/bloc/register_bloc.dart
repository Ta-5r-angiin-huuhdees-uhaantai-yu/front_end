import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/register_request.dart';
import '../model/register_response.dart';
import '../model/variables.dart';
// import '';

/// ---------------------------------------------------------------------------
/// RegisterBloc
/// ---------------------------------------------------------------------------
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmitEvent>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());

    try {
      RegisterRequest request = RegisterRequest(
        login_name: event.login_name ?? '',
        email: event.email ?? '',
        password: event.password ?? '',
      );

      final response =
      await apiService.Post('/register', data: request.toJson());

      final registerResponse = RegisterResponse.fromJson(response.data);

      if (registerResponse.success == true) {
        emit(RegisterSuccess(message: registerResponse.message ?? ''));
      } else {
        print('efwefwefwfwf');
        emit(
          RegisterFailure(message: registerResponse.message ?? 'Sign Up Error'),
        );
      }
    } catch (e) {
      print('wertyhujkjuytre');
      print(e);
      emit(RegisterFailure(message: 'Catch Error occurred: $e'));
    }
  }
}

/// ---------------------------------------------------------------------------
/// RegisterEvent
/// ---------------------------------------------------------------------------
abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterSubmitEvent extends RegisterEvent {
  final String? login_name;
  final String? email;
  final String? password;

  RegisterSubmitEvent({this.login_name, this.email, this.password});

  @override
  List<Object?> get props => [login_name, email, password];
}

/// ---------------------------------------------------------------------------
/// RegisterState
/// ---------------------------------------------------------------------------
@immutable
abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterSuccess extends RegisterState {
  final String? message;

  RegisterSuccess({this.message});

  @override
  List<Object?> get props => [message];
}

class RegisterFailure extends RegisterState {
  final String? message;

  RegisterFailure({this.message});

  @override
  List<Object?> get props => [message];
}

class RegisterInitial extends RegisterState {
  RegisterInitial() : super();
}

class RegisterLoading extends RegisterState {
  RegisterLoading() : super();
}
