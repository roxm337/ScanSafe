import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../models/product_review.dart';

class ReviewsApiService extends GetxService {
  static ReviewsApiService get to => Get.find();
  
  late ApiProvider apiProvider;

  @override
  void onInit() {
    super.onInit();
    apiProvider = Get.find<ApiProvider>();
  }

  Future<List<ProductReview>> getProductReviews(String productId) async {
    final response = await apiProvider.get('/product/$productId/reviews');
    if (response.data['data'] != null) {
      return (response.data['data'] as List)
          .map((json) => ProductReview.fromJson(json))
          .toList();
    }
    return [];
  }

  Future<ReviewSummary> getProductReviewSummary(String productId) async {
    final response = await apiProvider.get('/product/$productId/reviews/summary');
    if (response.data != null) {
      // Convert the API response to our ReviewSummary model
      Map<String, dynamic> data = response.data;
      
      // Convert tag_counts from Map to proper format
      Map<String, int> tagCounts = {};
      if (data['tag_counts'] != null) {
        data['tag_counts'].forEach((key, value) {
          tagCounts[key] = value is int ? value : int.tryParse(value.toString()) ?? 0;
        });
      }
      
      List<String> commonIssues = [];
      if (data['common_issues'] != null) {
        commonIssues = List<String>.from(data['common_issues']);
      }
      
      return ReviewSummary(
        averageRating: (data['average_rating'] is num) 
            ? (data['average_rating'] as num).toDouble() 
            : double.parse(data['average_rating'].toString()),
        totalReviews: data['total_reviews'],
        tagCounts: tagCounts,
        commonIssues: commonIssues,
      );
    }
    
    return ReviewSummary(
      averageRating: 0.0,
      totalReviews: 0,
      tagCounts: {},
      commonIssues: [],
    );
  }

  Future<bool> submitReview(ProductReview review) async {
    try {
      // Handle the case where productId might be empty, fallback to a generated ID
      String productId = review.productId.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : review.productId;
      final response = await apiProvider.post('/product/$productId/review', {
        'review_text': review.reviewText,
        'rating': review.rating,
        'tags': review.tags,
      });
      return response.statusCode == 201;
    } catch (e) {
      print('Error submitting review: $e');
      return false;
    }
  }

  Future<bool> voteHelpful(String reviewId) async {
    try {
      final response = await apiProvider.post('/review/$reviewId/helpful', {});
      return response.statusCode == 200;
    } catch (e) {
      print('Error voting helpful: $e');
      return false;
    }
  }
}