import 'package:dio/dio.dart';
import '../providers/api_provider.dart';

class ReviewsService {
  final ApiProvider _apiProvider;

  ReviewsService(this._apiProvider);

  Future<Response> getProductReviews(String productId) async {
    return await _apiProvider.get('/product/$productId/reviews');
  }

  Future<Response> getProductReviewsSummary(String productId) async {
    return await _apiProvider.get('/product/$productId/reviews/summary');
  }

  Future<Response> addProductReview(String productId, Map<String, dynamic> reviewData) async {
    return await _apiProvider.post('/product/$productId/review', reviewData);
  }

  Future<Response> updateReview(String reviewId, Map<String, dynamic> reviewData) async {
    return await _apiProvider.post('/review/$reviewId', reviewData);
  }

  Future<Response> deleteReview(String reviewId) async {
    return await _apiProvider.post('/review/$reviewId', {});
  }

  Future<Response> markReviewHelpful(String reviewId) async {
    return await _apiProvider.post('/review/$reviewId/helpful', {});
  }
}