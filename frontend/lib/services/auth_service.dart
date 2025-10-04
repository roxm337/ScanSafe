import 'package:dio/dio.dart';
import '../providers/api_provider.dart';
import '../models/user.dart';

class AuthService {
  final ApiProvider _apiProvider;

  AuthService(this._apiProvider);

  Future<Response> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    
    return await _apiProvider.post('/register', data);
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    final data = {
      'email': email,
      'password': password,
    };
    
    return await _apiProvider.post('/login', data);
  }

  Future<Response> logout() async {
    return await _apiProvider.post('/logout', {});
  }

  Future<Response> fetchUser() async {
    return await _apiProvider.get('/user');
  }
}