import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/preferences_controller.dart';
import '../controllers/auth_controller.dart';
import '../services/recommendation_service.dart';
import '../services/reviews_service.dart';
import '../services/social_share_api_service.dart';
import '../models/product.dart';
import '../models/product_review.dart';
import '../components/layout/custom_card.dart';

class ProductScreen extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Obx(() {
        final product = productController.product.value;
        if (product == null) {
          return const Center(child: Text('No product selected'));
        }
        return _buildProductContent(context, product);
      }),
    );
  }

  Widget _buildProductContent(BuildContext context, Product product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          if (product.imageUrl != null)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 60,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 20),

          // Product info
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            product.brand,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 20),

          // Compliance status
          _buildComplianceCard(context, product),
          const SizedBox(height: 16),

          // Ingredients
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  product.ingredientsText.isNotEmpty
                      ? product.ingredientsText
                      : 'No ingredients listed',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Allergens
          if (product.allergens.isNotEmpty && product.allergens.cast<String>().join(', ').trim().isNotEmpty)
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Allergens',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.allergens
                        .where((allergen) => allergen is String && allergen.trim().isNotEmpty)
                        .map((allergen) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                allergen.toString(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          
          // Personalized Recommendations
          FutureBuilder<List<Product>>(
            future: _getAlternatives(product),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              final alternatives = snapshot.data ?? [];
              if (alternatives.isNotEmpty) {
                return _buildAlternativesSection(context, product, alternatives);
              }
              
              return const SizedBox.shrink();
            },
          ),
          
          // Community Reviews Section
          _buildReviewsSection(context, product),
          
          // Social Sharing Section
          _buildSocialSharingSection(context, product),
        ],
      ),
    );
  }

  Widget _buildSocialSharingSection(BuildContext context, Product product) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share This Product',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Share your findings with friends and family',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildSocialShareButton(
                context: context,
                icon: Icons.share,
                label: 'Share',
                color: Theme.of(context).colorScheme.primary,
                platform: 'share',
                product: product,
              ),
              _buildSocialShareButton(
                context: context,
                icon: Icons.ios_share,
                label: 'WhatsApp',
                color: const Color(0xFF25D366), // WhatsApp green
                platform: 'whatsapp',
                product: product,
              ),
              _buildSocialShareButton(
                context: context,
                icon: Icons.facebook,
                label: 'Facebook',
                color: const Color(0xFF1877F2), // Facebook blue
                platform: 'facebook',
                product: product,
              ),
              _buildSocialShareButton(
                context: context,
                icon: Icons.camera_alt_outlined,
                label: 'Stories',
                color: Theme.of(context).colorScheme.tertiary,
                platform: 'stories',
                product: product,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialShareButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required String platform,
    required Product product,
  }) {
    return Obx(() {
      final isLoading = false.obs;
      
      return GestureDetector(
        onTap: isLoading.value ? null : () => _handleShare(context, platform, product, isLoading),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isLoading.value ? color.withValues(alpha: 0.3) : color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isLoading.value ? color.withValues(alpha: 0.5) : color.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isLoading.value
                  ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(color)))
                  : Icon(
                      icon,
                      color: color,
                      size: 18,
                    ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isLoading.value ? color.withValues(alpha: 0.5) : color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _handleShare(BuildContext context, String platform, Product product, RxBool isLoading) async {
    isLoading.value = true;
    
    try {
      final socialShareService = Get.find<SocialShareApiService>();
      final shareContent = await socialShareService.generateShareContent(product.id.isEmpty ? product.ean : product.id);
      
      // In a real app, you would use the share_plus package here
      // For now, just show what would be shared
      String message = shareContent['message'] ?? 'Check out this product: ${product.name}';
      
      // Track the share event
      await socialShareService.trackShare(product.id.isEmpty ? product.ean : product.id, platform);
      
      Get.snackbar(
        'Sharing via $platform',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not generate share content. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Widget _buildReviewsSection(BuildContext context, Product product) {
    return FutureBuilder<ReviewSummary>(
      future: _getReviewSummary(product.id),
      builder: (context, summarySnapshot) {
        if (summarySnapshot.connectionState == ConnectionState.waiting) {
          return CustomCard(
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final summary = summarySnapshot.data ?? ReviewSummary(
          averageRating: 0.0,
          totalReviews: 0,
          tagCounts: {},
          commonIssues: [],
        );

        return FutureBuilder<List<ProductReview>>(
          future: _getProductReviews(product.id),
          builder: (context, reviewsSnapshot) {
            if (reviewsSnapshot.connectionState == ConnectionState.waiting && reviewsSnapshot.data == null) {
              return CustomCard(
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            final reviews = reviewsSnapshot.data ?? [];

            return CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.forum,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Community Reviews',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.add_comment,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          _showReviewDialog(context, product);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  if (summary.totalReviews == 0)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No reviews yet. Be the first to share your experience!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        // Rating summary
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${summary.averageRating}',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Avg Rating',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Theme.of(context).dividerColor,
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${summary.totalReviews}',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Reviews',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Top tags/insights
                        if (summary.commonIssues.isNotEmpty) ...[
                          Text(
                            'Community Insights:',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: summary.commonIssues.take(3).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _formatTag(tag),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                        ],
                        
                        // Recent reviews
                        if (reviews.isNotEmpty) ...[
                          ...reviews.take(2).map((review) => _buildReviewCard(context, review)),
                        ],
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  Future<ReviewSummary> _getReviewSummary(String productId) async {
    final reviewsService = Get.find<ReviewsService>();
    return await reviewsService.getProductReviewSummary(productId);
  }
  
  Future<List<ProductReview>> _getProductReviews(String productId) async {
    final reviewsService = Get.find<ReviewsService>();
    return await reviewsService.getProductReviews(productId);
  }

  String _formatTag(String tag) {
    return tag
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Widget _buildReviewCard(BuildContext context, ProductReview review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: review.isVerified 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).dividerColor,
            width: review.isVerified ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.userName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        if (review.isVerified) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.verified,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      review.date.toLocal().toString().split(' ')[0],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                // Rating stars
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review.rating 
                          ? Icons.star 
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.reviewText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            if (review.tags.isNotEmpty) ...[
              Wrap(
                spacing: 4,
                children: review.tags.map((tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatTag(tag),
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Obx(() {
                  final isLoading = false.obs; // We'll implement a proper loading state if needed
                  return TextButton.icon(
                    icon: isLoading.value 
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 1.5))
                        : Icon(
                            Icons.thumb_up_alt_outlined,
                            size: 14,
                          ),
                    label: Text(
                      'Helpful (${review.helpfulVotes.length})',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onPressed: isLoading.value ? null : () async {
                      isLoading.value = true;
                      final reviewsService = Get.find<ReviewsService>();
                      bool success = await reviewsService.voteHelpful(review.id);
                      isLoading.value = false;
                      
                      if (success) {
                        Get.snackbar('Thanks', 'Review marked as helpful');
                      } else {
                        Get.snackbar('Error', 'Could not mark as helpful');
                      }
                    },
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, Product product) {
    String reviewText = '';
    int rating = 0;
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Share Your Experience'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How was your experience with ${product.name}?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            // Rating selector
            Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    rating = index + 1;
                  },
                  child: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reviewController,
              decoration: const InputDecoration(
                labelText: 'Your review',
                hintText: 'Share details about your experience...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          Obx(() {
            final authController = Get.find<AuthController>();
            final isLoading = false.obs; // Reactive loading state
            
            return ElevatedButton(
              onPressed: rating > 0 && reviewController.text.trim().isNotEmpty && !isLoading.value
                  ? () async {
                      isLoading.value = true;
                      final newReview = ProductReview(
                        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
                        productId: product.id.isEmpty ? product.ean : product.id,
                        userId: authController.user.value?.id.toString() ?? 'guest',
                        userName: authController.user.value?.name ?? 'Anonymous',
                        reviewText: reviewController.text.trim(),
                        rating: rating,
                        date: DateTime.now(),
                        isVerified: false,
                        helpfulVotes: [],
                        tags: [], // Could add tag selection in the future
                      );
                      
                      final reviewsService = Get.find<ReviewsService>();
                      bool success = await reviewsService.submitReview(newReview);
                      isLoading.value = false;
                      
                      if (success) {
                        Get.back();
                        Get.snackbar('Thank You', 'Your review has been submitted!');
                        // Refresh reviews
                        // You could optionally refresh the reviews list here
                      } else {
                        Get.snackbar('Error', 'Could not submit review. Please try again.');
                      }
                    }
                  : null,
              child: isLoading.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text('Submit'),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAlternativesSection(BuildContext context, Product product, List<Product> alternatives) {
    if (alternatives.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomCard(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.recommend,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Recommended Alternatives',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Products that don\'t contain ingredients you should avoid:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          ...alternatives.take(3).map((alternative) => _buildAlternativeCard(context, alternative)),
        ],
      ),
    );
  }
  
  Future<List<Product>> _getAlternatives(Product product) async {
    final recommendationService = Get.find<RecommendationService>();
    return await recommendationService.findAlternatives(product);
  }

  Widget _buildAlternativeCard(BuildContext context, Product alternative) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alternative.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    alternative.brand,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                // In a real app, this would navigate to the alternative product
                Get.snackbar('Alternative Product', 'View ${alternative.name}');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceCard(BuildContext context, Product product) {
    return FutureBuilder<String>(
      future: _getRecommendationMessage(product),
      builder: (context, snapshot) {
        String message = snapshot.data ?? 'Analyzing product safety...';
        if (snapshot.connectionState == ConnectionState.waiting) {
          message = 'Analyzing product safety...';
        }
        
        // Use the recommendation service to generate personalized message
        final recommendationService = Get.find<RecommendationService>();
        
        // Determine if there are allergens that match user preferences
        bool hasUserAllergies = false;
        for (var issue in product.compliance.issues) {
          String ingredient = issue['ingredient'] ?? '';
          if (Get.find<PreferencesController>().hasAllergy(ingredient)) {
            hasUserAllergies = true;
            break;
          }
        }
        
        Color complianceColor = hasUserAllergies 
            ? Theme.of(context).colorScheme.error
            : product.compliance.compliant
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.error;
                
        IconData complianceIcon = hasUserAllergies 
            ? Icons.warning_amber_rounded
            : product.compliance.compliant
                ? Icons.check_circle
                : Icons.warning_amber_rounded;

        return CustomCard(
          color: hasUserAllergies 
              ? Theme.of(context).colorScheme.errorContainer
              : product.compliance.compliant
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.errorContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    complianceIcon,
                    color: complianceColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasUserAllergies 
                          ? '🚨 Contains Ingredients You Should Avoid' 
                          : product.compliance.compliant 
                              ? 'Safe to Consume' 
                              : 'Not Recommended',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: complianceColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: hasUserAllergies 
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                  ),
                ),
              if (product.compliance.issues.isNotEmpty)
                ...product.compliance.issues.map(
                  (issue) {
                    String ingredient = issue['ingredient'] ?? '';
                    bool isUserAllergy = Get.find<PreferencesController>().hasAllergy(ingredient);
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isUserAllergy ? Icons.warning_rounded : Icons.circle,
                            size: 8,
                            color: isUserAllergy 
                                ? Theme.of(context).colorScheme.error 
                                : complianceColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$ingredient${isUserAllergy ? ' (Your Allergy)' : ''}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isUserAllergy 
                                            ? Theme.of(context).colorScheme.error 
                                            : complianceColor,
                                      ),
                                ),
                                if (issue['reason'] != null && !isUserAllergy)
                                  Text(
                                    issue['reason'] ?? '',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              if (product.compliance.advice != null && product.compliance.advice!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'Advice: ${product.compliance.advice}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: complianceColor,
                        ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
  
  Future<String> _getRecommendationMessage(Product product) async {
    final recommendationService = Get.find<RecommendationService>();
    return await recommendationService.generateRecommendationMessage(product);
  }

}
