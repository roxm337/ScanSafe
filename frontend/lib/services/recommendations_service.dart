import 'package:dio/dio.dart';
import '../providers/api_provider.dart';

class RecommendationsService {
  final ApiProvider _apiProvider;

  RecommendationsService(this._apiProvider);

  Future<Response> getUserRecommendations() async {
    return await _apiProvider.get('/recommendations');
  }

  Future<Response> getProductAlternatives(String productId) async {
    return await _apiProvider.get('/product/$productId/alternatives');
  }

  Future<Response> getPersonalizedRecommendations(String productId) async {
    return await _apiProvider.get('/product/$productId/recommendations');
  }

  Future<Response> getTrendingRecommendations() async {
    return await _apiProvider.get('/trending');
  }
}