class ProductReview {
  String id;
  String productId;
  String userId;
  String userName;
  String reviewText;
  int rating; // 1-5 stars
  DateTime date;
  bool isVerified;
  List<String> helpfulVotes;
  List<String> tags; // e.g., ['caused-rash', 'safe-for-peanuts', 'great-taste']

  ProductReview({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.reviewText,
    required this.rating,
    required this.date,
    this.isVerified = false,
    this.helpfulVotes = const [],
    this.tags = const [],
  });

  ProductReview.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        productId = json['product_id'] ?? json['productId'] ?? '',
        userId = json['user_id'] ?? json['userId'] ?? '',
        userName = json['user_name'] ?? json['userName'] ?? '',
        reviewText = json['review_text'] ?? json['reviewText'] ?? '',
        rating = json['rating'] ?? 0,
        date = json['created_at'] != null ? DateTime.parse(json['created_at']) : 
              json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
        isVerified = json['is_verified'] ?? json['isVerified'] ?? false,
        helpfulVotes = json['helpful_votes'] != null ? List<String>.from(json['helpful_votes']) : 
                       json['helpfulVotes'] != null ? List<String>.from(json['helpfulVotes']) : [],
        tags = json['tags'] != null ? List<String>.from(json['tags']) : [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'reviewText': reviewText,
      'rating': rating,
      'date': date.toIso8601String(),
      'isVerified': isVerified,
      'helpfulVotes': helpfulVotes,
      'tags': tags,
    };
  }
}

class ReviewSummary {
  double averageRating;
  int totalReviews;
  Map<String, int> tagCounts; // Count of different tags
  List<String> commonIssues; // Most commonly mentioned issues

  ReviewSummary({
    required this.averageRating,
    required this.totalReviews,
    required this.tagCounts,
    required this.commonIssues,
  });
}