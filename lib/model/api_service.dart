import 'package:bd_frontend/model/token_preference.dart';
import 'package:dio/dio.dart' as dio;

class ApiService {
  final _dio = dio.Dio(dio.BaseOptions(
      baseUrl: "http://192.168.1.13:5000/api",
      // baseUrl: "http://192.168.1.157:1024/api",
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 5000),
      headers: {
        'Content-Type': 'application/json',
        // 'Accept': 'application/json',
        // 'Connection': 'keep-alive',
      },
      validateStatus: (status) {
        if (status == null) return false;
        if (status >= 200 && status < 300) return true;

        print("Unexpected status code: $status");
        return false;
      }));
  final cookiePref = CookiePreference();

  Future<dio.Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    final token = await CookiePreference().getToken();

    final response = await _dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: dio.Options(
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );
    return response;
  }

  Future<dio.Response> Post(String endpoint, {dynamic data}) async {
    try {
      // Get token from local storage
      final token = await CookiePreference().getToken();

      final response = await _dio.post(
        endpoint,
        data: data,
        options: dio.Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } on dio.DioException catch (e) {
      print("Dio POST error: ${e.message}");
      throw Exception("POST request failed: ${e.response?.data ?? e.message}");
    }
  }

  Future<dio.Response> post(String endpoint, {dynamic data}) async {
    try {
      // Get token from local storage
      final token = await CookiePreference().getToken();

      final response = await _dio.post(
        endpoint,
        data: data,
        options: dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } on dio.DioException catch (e) {
      print("Dio POST error: ${e.message}");
      throw Exception("POST request failed: ${e.response?.data ?? e.message}");
    }
  }

  Future<dio.Response> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response;
    } on dio.DioException catch (e) {
      throw Exception("Put request failed: ${e.message}");
    }
  }

  Future<dio.Response> delete(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.delete(endpoint, data: data);
      return response;
    } on dio.DioException catch (e) {
      throw Exception("Delete request failed: ${e.message}");
    }
  }

  Future<void> clearCookies() async {
    try {
      await cookiePref.clearCookies();
    } catch (e) {
      throw Exception("Failed to clear tokens: $e");
    }
  }
}
