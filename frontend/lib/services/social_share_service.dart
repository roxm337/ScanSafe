import 'package:dio/dio.dart';
import '../providers/api_provider.dart';

class SocialShareService {
  final ApiProvider _apiProvider;

  SocialShareService(this._apiProvider);

  Future<Response> generateShareContent(String productId) async {
    return await _apiProvider.get('/product/$productId/share-content');
  }

  Future<Response> trackShare(String productId) async {
    return await _apiProvider.post('/product/$productId/share-track', {});
  }
}