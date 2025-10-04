import 'package:dio/dio.dart';
import '../utils/constants.dart';

class ApiProvider {
  final Dio _dio = Dio();

  ApiProvider() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<Response> post(String path, Map<String, dynamic> data) {
    return _dio.post(path, data: data);
  }

  Future<Response> get(String path) {
    return _dio.get(path);
  }

  // Add other methods like put, delete if needed
}
