import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/login_request.dart';
import '../model/login_response.dart';
import '../model/token_preference.dart';
import '../model/variables.dart';

/// ---------------------------------------------------------------------------
/// LoginBloc
/// ---------------------------------------------------------------------------
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final cookiePref = CookiePreference();

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      LoginRequest request = LoginRequest(
        login_name: event.login_name ?? '',
        password: event.password ?? '',
      );

      final response = await apiService.Post('/login', data: request.toJson());

      final loginResponse = LoginResponse.fromJson(response.data);

      if (loginResponse.success == true) {
        emit(LoginSuccess(message: loginResponse.message ?? '', token: loginResponse.token));

        final cookies = response.headers.map['set-cookie'] ?? [];
        cookiePref.saveCookies(cookies);

        // Save token locally
        if (loginResponse.token != null) {
          await cookiePref.saveToken(loginResponse.token!); // reuse save() from your CookiePreference
        }
      } else {
        print('wefhwewiefbhiwefubgwe${loginResponse.message}');
        emit(LoginFailure(error: loginResponse.message ?? 'Login Error'));
      }
    } catch (e) {
      print('ggggggggggggggg${e}');
      emit(LoginFailure(error: 'Catch Error occurred: $e'));
    }
  }
}

/// ---------------------------------------------------------------------------
/// LoginEvent
/// ---------------------------------------------------------------------------
abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String? login_name;
  final String? password;

  LoginSubmitted({this.login_name, this.password});

  @override
  List<Object?> get props => [login_name, password];
}

/// ---------------------------------------------------------------------------
/// LoginState
/// ---------------------------------------------------------------------------
@immutable
abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  LoginInitial() : super();
}

class LoginLoading extends LoginState {
  LoginLoading() : super();
}

class LoginSuccess extends LoginState {
  final String? message;
  final String? token;

  LoginSuccess({
    this.message,
    this.token,
  });

  @override
  List<Object?> get props => [message];
}

class LoginFailure extends LoginState {
  final String? error;

  LoginFailure({this.error});

  @override
  List<Object?> get props => [error];
}


// Future<void> _pickImage(BuildContext context) async {
//   final ImagePicker picker = ImagePicker();
//   final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//   if (pickedFile == null) {
//     print("⛔ No image picked");
//     return;
//   }
//
//   setState(() {
//     _pickedImage = pickedFile.path;
//   });
//
//   final file = File(pickedFile.path);
//   final api = ApiService();
//
//   // **Assuming you have a way to get the current user's ID**
//   const userId = 'YOUR_CURRENT_USER_ID'; // Replace with actual user ID
//
//   try {
//     final formData = dio.FormData.fromMap({
//       'image': await dio.MultipartFile.fromFile(file.path, filename: pickedFile.name),
//       'userId': userId, // Include the user ID in the form data
//     });
//
//     final response = await api.post(
//       '/upload/profile',
//       data: formData,
//     );
//
//     print("📡 Upload response: ${response.data}");
//
//     if (response.statusCode == 200 && response.data['success'] == true) {
//       final imageUrl = response.data['profileImage'];
//
//       setState(() {
//         profileImage = imageUrl;
//         _pickedImage = null;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Зураг амжилттай илгээгдлээ ✅"), backgroundColor: Colors.green),
//       );
//     } else {
//       throw Exception(response.data['message'] ?? 'Upload failed');
//     }
//   } catch (e) {
//     print("❌ Upload error: $e");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Алдаа: $e"), backgroundColor: Colors.red),
//     );
//   }
// }