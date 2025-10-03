import 'package:get/get.dart';
import '../models/product_review.dart';
import '../services/reviews_api_service.dart';

class ReviewsService extends GetxService {
  Future<List<ProductReview>> getProductReviews(String productId) async {
    try {
      final apiService = Get.find<ReviewsApiService>();
      return await apiService.getProductReviews(productId);
    } catch (e) {
      print('Error getting reviews from API: $e');
      // Return empty list on error
      return [];
    }
  }

  Future<ReviewSummary> getProductReviewSummary(String productId) async {
    try {
      final apiService = Get.find<ReviewsApiService>();
      return await apiService.getProductReviewSummary(productId);
    } catch (e) {
      print('Error getting review summary from API: $e');
      // Return empty summary on error
      return ReviewSummary(
        averageRating: 0.0,
        totalReviews: 0,
        tagCounts: {},
        commonIssues: [],
      );
    }
  }

  Future<bool> submitReview(ProductReview review) async {
    try {
      final apiService = Get.find<ReviewsApiService>();
      return await apiService.submitReview(review);
    } catch (e) {
      print('Error submitting review to API: $e');
      return false;
    }
  }

  Future<bool> voteHelpful(String reviewId) async {
    try {
      final apiService = Get.find<ReviewsApiService>();
      return await apiService.voteHelpful(reviewId);
    } catch (e) {
      print('Error voting helpful to API: $e');
      return false;
    }
  }
}